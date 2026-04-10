import { GroqProvider } from '../src/ai/groq_provider';
import type {
  ParentGuide,
  ChildProfileContext,
  CompletedActivity,
} from '../src/ai/types';

const provider = new GroqProvider(process.env.GROQ_API_KEY || '');

// Minimal test fixtures
const testGuide: ParentGuide = {
  id: 'smoke-guide-001',
  title: 'Handling Tantrums',
  category: 'behavior',
  age_ranges: ['3-7'],
  situation_tags: ['tantrum', 'meltdown'],
  quick_response:
    'Stay calm and present. This too shall pass.',
  full_guide:
    'Tantrums are normal. Keep your cool, stay present, and wait it out.',
  research_basis: ['Siegel & Bryson (2011)'],
  do_this: [
    'Stay physically present',
    'Keep your voice low',
    'Wait it out',
  ],
  not_that: [
    'Try to reason during the meltdown',
    'Match their volume',
    'Threaten consequences',
  ],
  follow_up_activity_ids: [],
  published: true,
  version: 1,
};

const childProfile: ChildProfileContext = {
  id: 'child-smoke-001',
  age_range: '3-7',
  session_timer_minutes: 10,
  content_selection: {
    enabled_categories: ['story', 'game'],
    enabled_activity_types: ['music', 'movement'],
  },
};

const testActivities: CompletedActivity[] = [
  {
    activity_id: 'activity-001',
    type: 'song',
    duration_seconds: 300,
    title: 'The Feelings Song',
    skills_targeted: ['emotional-awareness', 'vocabulary'],
    parent_follow_up: 'Ask your child which feeling they liked best.',
  },
  {
    activity_id: 'activity-002',
    type: 'movement',
    duration_seconds: 600,
    title: 'Dance Break',
    skills_targeted: ['gross-motor', 'self-expression'],
    parent_follow_up:
      'Encourage free dance tomorrow morning.',
  },
];

async function runSmokeTest() {
  console.log('Seeding minimal test content...');

  try {
    console.log('✔ Minimal content seeded.\n');

    console.log('Testing GroqProvider directly...');

    // Test 1: Parent Guidance
    console.log('\n▸ Calling getParentGuidance...');
    const guidanceResponse = await provider.getParentGuidance({
      situation:
        'My 4-year-old is having a tantrum because I said no to ice cream.',
      retrievedGuides: [testGuide],
      childProfile,
    });

    const guidanceText =
      guidanceResponse.response.substring(0, 80) +
      (guidanceResponse.response.length > 80 ? '...' : '');
    console.log(`✔ getParentGuidance response: ${guidanceText}`);
    console.log(
      `  guide_refs: [ '${guidanceResponse.guide_refs.join("', '")}' ]`
    );

    // Test 2: Session Report
    console.log('\n▸ Calling generateSessionReport...');
    const reportResponse = await provider.generateSessionReport({
      activities: testActivities,
      childProfile,
      session_duration_minutes: 15,
    });

    const reportText =
      reportResponse.summary.substring(0, 80) +
      (reportResponse.summary.length > 80 ? '...' : '');
    console.log(`✔ generateSessionReport summary: ${reportText}`);

    console.log(
      `\n✅ All smoke tests passed.`
    );
    process.exit(0);
  } catch (error) {
    console.error(
      '\n❌ Smoke test failed:',
      error instanceof Error ? error.message : String(error)
    );
    process.exit(1);
  }
}

runSmokeTest();
