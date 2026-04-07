import { GroqProvider } from '../groq_provider.js';
import type { ParentGuidanceParams, SessionReportParams } from '../types.js';

// Mock the Groq SDK
jest.mock('groq-sdk', () => ({
  __esModule: true,
  default: jest.fn().mockImplementation(() => ({
    chat: {
      completions: {
        create: jest.fn().mockResolvedValue({
          choices: [
            {
              message: {
                content: JSON.stringify({
                  response: 'Stay calm and get down to their level.',
                  guide_refs: ['guide-tantrum-001'],
                }),
              },
            },
          ],
        }),
      },
    },
  })),
}));

// Mock prompt loader
jest.mock('../../prompts/prompt_loader.js', () => ({
  loadPrompt: jest.fn().mockReturnValue('mock prompt {{RETRIEVED_GUIDES}} {{SITUATION}} {{AGE_RANGE}}'),
  fillPrompt: jest.fn().mockImplementation((template: string, vars: Record<string, string>) => {
    let result = template;
    for (const [k, v] of Object.entries(vars)) {
      result = result.replaceAll(`{{${k}}}`, v);
    }
    return result;
  }),
}));

describe('GroqProvider', () => {
  let provider: GroqProvider;

  beforeEach(() => {
    provider = new GroqProvider('test-api-key');
  });

  describe('getParentGuidance', () => {
    const params: ParentGuidanceParams = {
      situation: 'My child is having a tantrum',
      retrievedGuides: [
        {
          id: 'guide-tantrum-001',
          title: 'Handling Tantrums',
          category: 'behavior',
          age_ranges: ['3-7'],
          situation_tags: ['tantrum', 'meltdown'],
          quick_response: 'Stay calm, get to their level.',
          full_guide: 'Full guide content here.',
          research_basis: [],
          do_this: ['Stay calm'],
          not_that: ['Yell back'],
          follow_up_activity_ids: [],
          published: true,
          version: 1,
        },
      ],
      childProfile: {
        id: 'child-1',
        age_range: '3-7',
        session_timer_minutes: 20,
        content_selection: {
          enabled_categories: ['behavior'],
          enabled_activity_types: ['story', 'game'],
        },
      },
    };

    it('returns a response with guide refs', async () => {
      const result = await provider.getParentGuidance(params);
      expect(result.response).toBeTruthy();
      expect(result.guide_refs).toBeInstanceOf(Array);
    });

    it('includes the guide ID in guide_refs', async () => {
      const result = await provider.getParentGuidance(params);
      expect(result.guide_refs).toContain('guide-tantrum-001');
    });
  });

  describe('generateSessionReport', () => {
    const params: SessionReportParams = {
      activities: [
        {
          activity_id: 'act-001',
          type: 'story',
          duration_seconds: 600,
          title: 'The Very Hungry Caterpillar',
          skills_targeted: ['reading', 'counting'],
          parent_follow_up: 'Ask your child to retell the story.',
        },
      ],
      childProfile: {
        id: 'child-1',
        age_range: '3-7',
        session_timer_minutes: 20,
        content_selection: {
          enabled_categories: ['behavior'],
          enabled_activity_types: ['story'],
        },
      },
      session_duration_minutes: 12,
    };

    it('returns a session report', async () => {
      const result = await provider.generateSessionReport(params);
      expect(result).toBeDefined();
    });
  });
});
