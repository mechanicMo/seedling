import Anthropic from '@anthropic-ai/sdk';
import { loadPrompt, fillPrompt } from '../prompts/prompt_loader.js';
import type { AIProvider } from './ai_provider.js';
import type {
  ParentGuidanceParams,
  ParentGuidanceResponse,
  SessionReportParams,
  SessionReport,
} from './types.js';

const MODEL = 'claude-sonnet-4-6';
const MAX_TOKENS = 1024;

export class AnthropicProvider implements AIProvider {
  private client: Anthropic;

  constructor(apiKey: string) {
    this.client = new Anthropic({ apiKey });
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

    const message = await this.client.messages.create({
      model: MODEL,
      max_tokens: MAX_TOKENS,
      system: systemPrompt,
      messages: [
        {
          role: 'user',
          content: `Please help me with this situation: ${situation}\n\nRespond as JSON with fields: response (string), guide_refs (string[]).`,
        },
      ],
    });

    const raw =
      message.content[0]?.type === 'text' ? message.content[0].text : '{}';
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

    const message = await this.client.messages.create({
      model: MODEL,
      max_tokens: MAX_TOKENS,
      system: systemPrompt,
      messages: [
        {
          role: 'user',
          content:
            'Generate the session report as JSON with fields: summary (string), skills_practiced (string[]), parent_follow_ups (string[]), ai_observations (string).',
        },
      ],
    });

    const raw =
      message.content[0]?.type === 'text' ? message.content[0].text : '{}';
    const parsed = JSON.parse(raw) as Partial<SessionReport>;

    return {
      summary: parsed.summary ?? 'Session complete.',
      skills_practiced: parsed.skills_practiced ?? [],
      parent_follow_ups: parsed.parent_follow_ups ?? [],
      ai_observations: parsed.ai_observations ?? '',
    };
  }
}
