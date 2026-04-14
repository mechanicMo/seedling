import Groq from 'groq-sdk';
import { loadPrompt, fillPrompt } from '../prompts/prompt_loader.js';
import type { AIProvider } from './ai_provider.js';
import type {
  ParentGuidanceParams,
  ParentGuidanceResponse,
  SessionReportParams,
  SessionReport,
} from './types.js';

const MODEL = 'llama-3.3-70b-versatile';

export class GroqProvider implements AIProvider {
  private client: Groq;

  constructor(apiKey: string) {
    this.client = new Groq({ apiKey });
  }

  async getParentGuidance(
    params: ParentGuidanceParams
  ): Promise<ParentGuidanceResponse> {
    const { situation, retrievedGuides, childProfile } = params;

    const guidesText = retrievedGuides
      .map(
        (g) =>
          `[${g.id}] ${g.title}\n` +
          `Quick response: ${g.quick_response}\n` +
          `Do this: ${g.do_this.join('; ')}\n` +
          `Not that: ${g.not_that.join('; ')}`
      )
      .join('\n\n');

    const template = loadPrompt('parent_guide');
    const systemPrompt = fillPrompt(template, {
      AGE_RANGE: childProfile.age_range,
      RETRIEVED_GUIDES: guidesText || 'No guides retrieved.',
      SITUATION: situation,
    });

    const completion = await this.client.chat.completions.create({
      model: MODEL,
      messages: [
        { role: 'system', content: systemPrompt },
        {
          role: 'user',
          content: `Please help me with this situation and respond with JSON: ${situation}`,
        },
      ],
      temperature: 0.3,
      response_format: { type: 'json_object' },
    });

    const raw = completion.choices[0]?.message?.content ?? '{}';
    const parsed = JSON.parse(raw) as Partial<ParentGuidanceResponse>;

    return {
      response: parsed.response ?? 'No response generated.',
      guide_refs: parsed.guide_refs ?? retrievedGuides.map((g) => g.id),
    };
  }

  async generateSessionReport(
    params: SessionReportParams
  ): Promise<SessionReport> {
    const { activities, childProfile, session_duration_minutes } = params;

    const activitiesText = activities
      .map(
        (a) =>
          `- ${a.title} (${a.type}, ${Math.round(a.duration_seconds / 60)} min)\n` +
          `  Skills: ${a.skills_targeted.join(', ')}\n` +
          `  Follow-up: ${a.parent_follow_up}`
      )
      .join('\n');

    const template = loadPrompt('session_report');
    const systemPrompt = fillPrompt(template, {
      AGE_RANGE: childProfile.age_range,
      DURATION_MINUTES: String(session_duration_minutes),
      ACTIVITIES: activitiesText || 'No activities completed.',
    });

    const completion = await this.client.chat.completions.create({
      model: MODEL,
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: 'Generate the session report.' },
      ],
      temperature: 0.3,
      response_format: { type: 'json_object' },
    });

    const raw = completion.choices[0]?.message?.content ?? '{}';
    const parsed = JSON.parse(raw) as Partial<SessionReport>;

    return {
      summary: parsed.summary ?? 'Session complete.',
      skills_practiced: parsed.skills_practiced ?? [],
      parent_follow_ups: parsed.parent_follow_ups ?? [],
      ai_observations: parsed.ai_observations ?? '',
    };
  }
}
