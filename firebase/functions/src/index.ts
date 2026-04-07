import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';
import { getProviderForTier } from './ai/provider_factory.js';
import type { ParentGuide, ChildProfileContext, CompletedActivity } from './ai/types.js';

admin.initializeApp();
const db = admin.firestore();

// ── Helpers ──────────────────────────────────────────────────────────────────

/**
 * Matches guides against extracted tags from the situation string.
 * Returns up to 3 best-matching guides.
 * MVP: tag intersection. v2: vector similarity search.
 */
export function matchGuidesByTags(
  guides: ParentGuide[],
  tags: string[]
): ParentGuide[] {
  const normalizedTags = tags.map((t) => t.toLowerCase().trim());

  return guides
    .filter((guide) =>
      guide.situation_tags.some((tag) =>
        normalizedTags.some(
          (inputTag) =>
            tag.toLowerCase().includes(inputTag) ||
            inputTag.includes(tag.toLowerCase())
        )
      )
    )
    .slice(0, 3);
}

/**
 * Extracts likely situation tags from the parent's free-text input.
 * MVP: simple keyword splitting. v2: NLP keyword extraction.
 */
function extractTags(situation: string): string[] {
  return situation
    .toLowerCase()
    .split(/\s+/)
    .filter((word) => word.length > 3)
    .slice(0, 10);
}

function getApiKeys() {
  return {
    groqApiKey: functions.config().groq?.api_key ?? process.env.GROQ_API_KEY ?? '',
    anthropicApiKey: functions.config().anthropic?.api_key ?? process.env.ANTHROPIC_API_KEY ?? '',
  };
}

// ── getParentGuidance ────────────────────────────────────────────────────────

interface GetParentGuidanceData {
  situation: string;
  childId: string;
}

export const getParentGuidance = functions.https.onCall(
  async (data: GetParentGuidanceData, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'Must be signed in.');
    }

    const { situation, childId } = data;
    const userId = context.auth.uid;

    if (!situation?.trim()) {
      throw new functions.https.HttpsError('invalid-argument', 'Situation is required.');
    }

    functions.logger.info('getParentGuidance called', { userId, childId });

    // 1. Get user tier
    const userDoc = await db.collection('users').doc(userId).get();
    const tier = userDoc.exists ? (userDoc.data()?.tier ?? 'free') : 'free';

    // 2. Get child profile context (no names — COPPA)
    const childDoc = await db
      .collection('users')
      .doc(userId)
      .collection('children')
      .doc(childId)
      .get();

    if (!childDoc.exists) {
      throw new functions.https.HttpsError('not-found', 'Child profile not found.');
    }

    const childData = childDoc.data()!;
    const childProfile: ChildProfileContext = {
      id: childId,
      age_range: childData.age_range,
      session_timer_minutes: childData.session_timer_minutes ?? 20,
      content_selection: childData.content_selection ?? {
        enabled_categories: [],
        enabled_activity_types: [],
      },
    };

    // 3. Retrieve matching guides from Firestore
    const guidesSnapshot = await db
      .collection('parent_guides')
      .where('published', '==', true)
      .where('age_ranges', 'array-contains', childProfile.age_range)
      .get();

    const allGuides = guidesSnapshot.docs.map((doc) => ({
      id: doc.id,
      ...(doc.data() as Omit<ParentGuide, 'id'>),
    }));

    const tags = extractTags(situation);
    const retrievedGuides = matchGuidesByTags(allGuides, tags);

    // 4. Get AI provider for user's tier
    const provider = getProviderForTier(tier, getApiKeys());

    // 5. Generate response
    const aiResponse = await provider.getParentGuidance({
      situation,
      retrievedGuides,
      childProfile,
    });

    // 6. Store in chat_sessions
    const sessionRef = await db
      .collection('users')
      .doc(userId)
      .collection('chat_sessions')
      .add({
        child_id: childId,
        created_at: admin.firestore.FieldValue.serverTimestamp(),
        messages: [
          { role: 'user', content: situation, guide_refs: [] },
          {
            role: 'assistant',
            content: aiResponse.response,
            guide_refs: aiResponse.guide_refs,
          },
        ],
      });

    functions.logger.info('Chat session created', { sessionId: sessionRef.id });

    return {
      response: aiResponse.response,
      guide_refs: aiResponse.guide_refs,
      session_id: sessionRef.id,
    };
  }
);

// ── generateSessionReport ────────────────────────────────────────────────────

interface GenerateSessionReportData {
  childId: string;
  sessionId: string;
  activities: CompletedActivity[];
  duration_minutes: number;
}

export const generateSessionReport = functions.https.onCall(
  async (data: GenerateSessionReportData, context) => {
    if (!context.auth) {
      throw new functions.https.HttpsError('unauthenticated', 'Must be signed in.');
    }

    const { childId, sessionId, activities, duration_minutes } = data;
    const userId = context.auth.uid;

    functions.logger.info('generateSessionReport called', { userId, childId, sessionId });

    // 1. Get user tier
    const userDoc = await db.collection('users').doc(userId).get();
    const tier = userDoc.exists ? (userDoc.data()?.tier ?? 'free') : 'free';

    // 2. Get child profile context (no names — COPPA)
    const childDoc = await db
      .collection('users')
      .doc(userId)
      .collection('children')
      .doc(childId)
      .get();

    if (!childDoc.exists) {
      throw new functions.https.HttpsError('not-found', 'Child profile not found.');
    }

    const childData = childDoc.data()!;
    const childProfile: ChildProfileContext = {
      id: childId,
      age_range: childData.age_range,
      session_timer_minutes: childData.session_timer_minutes ?? 20,
      content_selection: childData.content_selection ?? {
        enabled_categories: [],
        enabled_activity_types: [],
      },
    };

    // 3. Generate report
    const provider = getProviderForTier(tier, getApiKeys());
    const report = await provider.generateSessionReport({
      activities,
      childProfile,
      session_duration_minutes: duration_minutes,
    });

    // 4. Save report to session document
    await db
      .collection('users')
      .doc(userId)
      .collection('children')
      .doc(childId)
      .collection('sessions')
      .doc(sessionId)
      .update({ report });

    functions.logger.info('Session report saved', { sessionId });

    return report;
  }
);
