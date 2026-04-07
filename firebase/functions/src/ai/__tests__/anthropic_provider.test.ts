import { AnthropicProvider } from '../anthropic_provider.js';
import type { ParentGuidanceParams } from '../types.js';

// Mock Anthropic SDK
jest.mock('@anthropic-ai/sdk', () => ({
  __esModule: true,
  default: jest.fn().mockImplementation(() => ({
    messages: {
      create: jest.fn().mockResolvedValue({
        content: [
          {
            type: 'text',
            text: JSON.stringify({
              response: 'Take a deep breath and get to their level.',
              guide_refs: ['guide-tantrum-001'],
            }),
          },
        ],
      }),
    },
  })),
}));

jest.mock('../../prompts/prompt_loader.js', () => ({
  loadPrompt: jest.fn().mockReturnValue('mock prompt'),
  fillPrompt: jest.fn().mockReturnValue('filled prompt'),
}));

describe('AnthropicProvider', () => {
  let provider: AnthropicProvider;

  beforeEach(() => {
    provider = new AnthropicProvider('test-api-key');
  });

  it('returns a parent guidance response', async () => {
    const params: ParentGuidanceParams = {
      situation: 'My child is hitting',
      retrievedGuides: [],
      childProfile: {
        id: 'child-1',
        age_range: '3-7',
        session_timer_minutes: 20,
        content_selection: {
          enabled_categories: ['behavior'],
          enabled_activity_types: ['story'],
        },
      },
    };

    const result = await provider.getParentGuidance(params);
    expect(result.response).toBeTruthy();
    expect(result.guide_refs).toBeInstanceOf(Array);
  });
});
