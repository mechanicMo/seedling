import * as admin from 'firebase-admin';

// Mock firebase-admin before importing index
jest.mock('firebase-admin', () => ({
  initializeApp: jest.fn(),
  firestore: jest.fn().mockReturnValue({
    collection: jest.fn().mockReturnValue({
      where: jest.fn().mockReturnThis(),
      get: jest.fn().mockResolvedValue({
        docs: [
          {
            id: 'guide-001',
            data: () => ({
              title: 'Handling Tantrums',
              category: 'behavior',
              age_ranges: ['3-7'],
              situation_tags: ['tantrum', 'meltdown'],
              quick_response: 'Stay calm.',
              full_guide: 'Full content.',
              research_basis: [],
              do_this: ['Stay calm'],
              not_that: ['Yell'],
              follow_up_activity_ids: [],
              published: true,
              version: 1,
            }),
          },
        ],
      }),
      doc: jest.fn().mockReturnValue({
        get: jest.fn().mockResolvedValue({
          exists: true,
          data: () => ({ tier: 'free' }),
        }),
        collection: jest.fn().mockReturnValue({
          add: jest.fn().mockResolvedValue({ id: 'session-new' }),
        }),
      }),
    }),
  }),
}));

jest.mock('firebase-functions', () => ({
  https: {
    onCall: jest.fn((handler) => handler),
  },
  logger: {
    info: jest.fn(),
    error: jest.fn(),
  },
}));

jest.mock('./ai/groq_provider.js', () => ({
  GroqProvider: jest.fn().mockImplementation(() => ({
    getParentGuidance: jest.fn().mockResolvedValue({
      response: 'Stay calm and get to their level.',
      guide_refs: ['guide-001'],
    }),
  })),
}));

jest.mock('./ai/provider_factory.js', () => ({
  getProviderForTier: jest.fn().mockReturnValue({
    getParentGuidance: jest.fn().mockResolvedValue({
      response: 'Stay calm and get to their level.',
      guide_refs: ['guide-001'],
    }),
  }),
}));

jest.mock('./prompts/prompt_loader.js', () => ({
  loadPrompt: jest.fn().mockReturnValue('mock prompt'),
  fillPrompt: jest.fn().mockReturnValue('filled mock prompt'),
}));

// Import after mocks
import { matchGuidesByTags } from './index.js';

describe('matchGuidesByTags', () => {
  it('returns guides that match any provided tag', () => {
    const guides = [
      {
        id: 'g1',
        situation_tags: ['tantrum', 'meltdown'],
        title: 'Tantrums',
        category: 'behavior',
        age_ranges: ['3-7'],
        quick_response: '',
        full_guide: '',
        research_basis: [],
        do_this: [],
        not_that: [],
        follow_up_activity_ids: [],
        published: true,
        version: 1,
      },
      {
        id: 'g2',
        situation_tags: ['sleep', 'bedtime'],
        title: 'Sleep',
        category: 'sleep',
        age_ranges: ['3-7'],
        quick_response: '',
        full_guide: '',
        research_basis: [],
        do_this: [],
        not_that: [],
        follow_up_activity_ids: [],
        published: true,
        version: 1,
      },
    ];

    const result = matchGuidesByTags(guides, ['tantrum', 'hitting']);
    expect(result).toHaveLength(1);
    expect(result[0].id).toBe('g1');
  });

  it('returns empty array when no tags match', () => {
    const result = matchGuidesByTags([], ['xyz']);
    expect(result).toHaveLength(0);
  });

  it('limits to top 3 results', () => {
    const guides = Array.from({ length: 5 }, (_, i) => ({
      id: `g${i}`,
      situation_tags: ['tantrum'],
      title: `Guide ${i}`,
      category: 'behavior',
      age_ranges: ['3-7'],
      quick_response: '',
      full_guide: '',
      research_basis: [],
      do_this: [],
      not_that: [],
      follow_up_activity_ids: [],
      published: true,
      version: 1,
    }));

    const result = matchGuidesByTags(guides, ['tantrum']);
    expect(result.length).toBeLessThanOrEqual(3);
  });
});

// Suppress unused import warning for admin — it's used by the mocked module
void (admin as unknown);
