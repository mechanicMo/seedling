import * as admin from 'firebase-admin';
import type { ParentGuide, ChildActivity } from '../src/ai/types.js';

// Initialize — uses Application Default Credentials
// Run with: GOOGLE_APPLICATION_CREDENTIALS=path/to/service-account.json npx ts-node -P tsconfig.dev.json scripts/seed_content.ts
// Or against emulator: FIRESTORE_EMULATOR_HOST=localhost:8080 npx ts-node ...
admin.initializeApp();
const db = admin.firestore();

// ── Parent Guides ────────────────────────────────────────────────────────────
// MVP minimum: 20 guides across 5 categories
// Template below — add all 20 before production launch

const parentGuides: Omit<ParentGuide, 'id'>[] = [
  // ── Behavior ──────────────────────────────────────────────────────────────
  {
    title: 'Handling Tantrums',
    category: 'behavior',
    age_ranges: ['3-7'],
    situation_tags: ['tantrum', 'meltdown', 'screaming', 'crying', 'floor'],
    quick_response:
      "Stay calm — your calm is their anchor. Don't try to reason during the tantrum. Get down to their level, keep your voice low, and wait it out. The goal right now is safety, not problem-solving.",
    full_guide: `## What's happening\nTantrums peak between ages 2-4 as children develop emotionally but lack the vocabulary to express big feelings. The prefrontal cortex (reasoning center) is offline during a meltdown — logic won't help.\n\n## What to do\n1. Ensure safety — remove from danger if needed.\n2. Stay close but calm. Your nervous system regulates theirs.\n3. Get to their level — kneel or sit on the floor.\n4. Use minimal words: "I'm right here. I can see you're upset."\n5. Don't negotiate, threaten, or bribe during the tantrum.\n6. After it passes — and it will — reconnect with a hug first, then briefly name what happened.\n\n## What not to do\n- Don't try to reason or problem-solve during it\n- Don't mimic their volume\n- Don't threaten consequences in the moment\n- Don't ignore completely — presence matters\n\n## The bigger picture\nTantrums are developmentally normal and don't reflect parenting failure. Consistent, calm responses over weeks reduce frequency.`,
    research_basis: [
      'Siegel, D.J. & Bryson, T.P. (2011). The Whole-Brain Child.',
      'Karp, H. (2004). The Happiest Toddler on the Block.',
    ],
    do_this: [
      'Stay physically present and calm',
      'Get down to their level',
      'Wait it out — reconnect after',
    ],
    not_that: [
      'Reason or negotiate during the meltdown',
      'Match their volume',
      'Threaten consequences in the moment',
    ],
    follow_up_activity_ids: ['activity-emotions-001'],
    published: true,
    version: 1,
  },
  {
    title: 'When Children Hit, Bite, or Kick',
    category: 'behavior',
    age_ranges: ['0-3', '3-7'],
    situation_tags: ['hitting', 'biting', 'kicking', 'aggressive', 'hurting others'],
    quick_response:
      "Calmly stop the behavior and set the limit: 'I won't let you hit.' No long explanation. Move them away from the situation if needed. Hitting back to 'show them how it feels' backfires — it models the behavior you're trying to stop.",
    full_guide: `## Why it happens\nHitting and biting are common in toddlers and young children — not because they're "bad" but because they lack impulse control and language to manage big feelings. It usually signals frustration, overwhelm, or a need for attention.\n\n## Immediate response\n1. Calmly and firmly: "I won't let you hit."\n2. Move them away or step in between — not as punishment, as a limit.\n3. Acknowledge the feeling: "You're really frustrated right now."\n4. Short consequence if needed (brief time-in with parent) — keep it proportionate.\n\n## What to do afterwards\n- Problem-solve together once calm: "What can you do next time when you feel that way?"\n- Practice alternative behaviors: stomping, squeezing a pillow, using words.\n- Check for triggers — hunger, tiredness, transitions often precede these incidents.\n\n## Pattern watch\nIf it's happening frequently, track when and where. Consistent triggers (specific child, specific time of day) point to prevention opportunities.`,
    research_basis: [
      'Lansbury, J. (2014). No Bad Kids.',
      'American Academy of Pediatrics (2018). Guidance on Effective Discipline.',
    ],
    do_this: [
      'Calmly name and stop the behavior',
      'Acknowledge the feeling behind it',
      'Practice alternatives when calm',
    ],
    not_that: [
      'Hit back to demonstrate',
      'Long explanations in the moment',
      "Shame (\"you're so mean\")",
    ],
    follow_up_activity_ids: [],
    published: true,
    version: 1,
  },

  // ── Sleep ──────────────────────────────────────────────────────────────────
  {
    title: 'Bedtime Resistance',
    category: 'sleep',
    age_ranges: ['3-7'],
    situation_tags: ['bedtime', 'wont sleep', 'stalling', 'refusing bed', 'nighttime'],
    quick_response:
      "A predictable bedtime routine (same order, same time) is the single most effective intervention for bedtime resistance. When children know what's coming next, anxiety drops and compliance improves.",
    full_guide: `## What drives bedtime resistance\nMost bedtime resistance is anxiety (separation, fear of dark, fear of missing out) combined with overtiredness. Overtired children actually fight sleep harder — their cortisol spikes.\n\n## The 20-minute routine\nA consistent 20-minute routine before bed signals the brain to wind down:\n1. Bath or wash up (10 min)\n2. Pajamas + teeth\n3. 1-2 books (no screens)\n4. Short connection ritual (song, prayer, 3 good things about the day)\n5. Lights out — same time every night\n\n## Common stalling tactics and how to handle them\n- "I need water" — keep a water bottle in their room\n- "I'm scared" — validate, brief reassurance, then exit. Don't linger.\n- "One more book" — set the number of books before you start\n- Getting out of bed — walk them back quietly, no conversation, no anger\n\n## Sleep windows\n- Ages 3-5: 10-13 hours total\n- Ages 6-7: 9-11 hours total\nBedtime that allows for this given their wake time is the target.`,
    research_basis: [
      'Mindell, J.A. & Owens, J. (2015). A Clinical Guide to Pediatric Sleep.',
      'American Academy of Sleep Medicine, Pediatric Sleep Guidelines.',
    ],
    do_this: [
      'Establish a consistent 20-minute routine',
      'Same bedtime every night (including weekends)',
      'Brief validation + exit for fears',
    ],
    not_that: [
      'Engage with stalling tactics',
      'Screens in the hour before bed',
      'Variable bedtimes on weekends',
    ],
    follow_up_activity_ids: [],
    published: true,
    version: 1,
  },

  // ── Emotions ──────────────────────────────────────────────────────────────
  {
    title: 'Emotional Regulation: Teaching Big Feelings',
    category: 'emotions',
    age_ranges: ['3-7'],
    situation_tags: ['emotions', 'feelings', 'regulation', 'big feelings', 'upset', 'angry'],
    quick_response:
      "Name what you see: 'You look really disappointed.' That alone — before any advice — helps children feel understood and begins to bring the brain's thinking center back online.",
    full_guide: `## Emotion coaching vs. dismissing\nEmotion coaching (naming, validating, problem-solving after calm) produces children with higher emotional intelligence and better peer relationships than emotion-dismissing approaches.\n\n## The 4-step process\n1. **Notice and name**: "I can see you're really angry right now."\n2. **Validate**: "Of course you're frustrated — that was hard."\n3. **Set limits if needed**: "And hitting is not okay."\n4. **Problem-solve together** (only when calm): "What could you do next time?"\n\n## The feeling vocabulary ladder\nHelp expand their feeling vocabulary beyond happy/sad/mad:\n- Body clues: "Where do you feel that in your body?"\n- Intensity: "On a scale of 1-10, how [feeling] are you?"\n- Name less common emotions: surprised, disappointed, embarrassed, proud, nervous\n\n## What not to say\n- "You're fine" (dismisses their experience)\n- "Stop crying" (impossible request, increases shame)\n- "You shouldn't feel that way" (invalidates)`,
    research_basis: [
      'Gottman, J. & DeClaire, J. (1997). Raising an Emotionally Intelligent Child.',
      'Siegel, D.J. (2014). Brainstorm.',
    ],
    do_this: [
      'Name emotions before problem-solving',
      'Validate the feeling, set limits on behavior',
      'Build feeling vocabulary over time',
    ],
    not_that: [
      '"You\'re fine" or "Stop crying"',
      'Problem-solve before the child is calm',
      'Punish emotional expressions',
    ],
    follow_up_activity_ids: ['activity-emotions-001'],
    published: true,
    version: 1,
  },

  // ── Development ────────────────────────────────────────────────────────────
  {
    title: 'Screen Time Guidelines by Age',
    category: 'development',
    age_ranges: ['0-3', '3-7'],
    situation_tags: ['screen time', 'tablet', 'phone', 'tv', 'ipad', 'youtube'],
    quick_response:
      "Quality matters more than quantity, but structure helps. For ages 3-7: 1 hour/day of intentional, co-viewed content. Not background TV. The real concern isn't the screen — it's what it's displacing (sleep, movement, conversation, play).",
    full_guide: `## Current guidance\n**Under 18 months:** Video chat only (FaceTime with family is fine)\n**18-24 months:** High-quality programming, co-viewed with parent\n**Ages 2-5:** 1 hour/day, high-quality content\n**Ages 6+:** Consistent limits; ensure it doesn't displace sleep, physical activity, or family time\n\n## What "quality" means\n- Educational, age-appropriate content\n- Co-viewed when possible — parents talking about what's on screen increases learning\n- Interactive > passive (apps that require responses > passive video)\n- Not background TV — children's language development suffers with background TV on\n\n## What screen time displaces (the real concern)\n- Sleep — screens before bed suppress melatonin\n- Physical movement\n- Real conversation\n- Unstructured play\n\n## Practical strategies\n- Dedicated screen-free zones: bedroom, dinner table\n- Screen-free times: an hour before bed, morning rush\n- No devices during family meals\n- "Parking lot" for devices during family activities`,
    research_basis: [
      'American Academy of Pediatrics (2016). Media and Young Minds.',
      'Rideout, V. (2017). The Common Sense Census.',
    ],
    do_this: [
      "Co-view and discuss what's on screen",
      'Keep screens out of bedrooms',
      'Protect the hour before bed',
    ],
    not_that: [
      'Background TV',
      'Screens as the default "calm down" tool',
      'Unrestricted access without boundaries',
    ],
    follow_up_activity_ids: [],
    published: true,
    version: 1,
  },

  // ── Additional guides (add 15 more before launch) ──────────────────────────
  // Categories needed: behavior x4, sleep x2, emotions x3, routines x3, development x3
  // Situation tags to cover: transitions, sharing, lying, picky eating, potty training,
  // nightmares, morning routines, sibling conflict, back talk, whining, separation anxiety
];

// ── Child Activities ─────────────────────────────────────────────────────────
// MVP minimum: 15 activities across story/game/music, primarily 3-7 age range

const childActivities: Omit<ChildActivity, 'id'>[] = [
  // ── Stories ────────────────────────────────────────────────────────────────
  {
    title: 'The Feelings Monster',
    type: 'story',
    age_ranges: ['3-7'],
    duration_minutes: 8,
    media_refs: [], // R2 URLs added when media is uploaded
    skills_targeted: ['emotional vocabulary', 'empathy', 'self-expression'],
    learning_objectives: [
      'Name 5 common emotions',
      'Recognize emotions in others',
      'Understand that all feelings are okay',
    ],
    parent_follow_up:
      'After the story, ask: "Which feeling did the monster have that you have too?" Name a time today when you felt the same way.',
    published: true,
    version: 1,
  },
  {
    title: 'The Brave Little Seed',
    type: 'story',
    age_ranges: ['3-7'],
    duration_minutes: 10,
    media_refs: [],
    skills_targeted: ['resilience', 'growth mindset', 'persistence'],
    learning_objectives: [
      'Understand that growth takes time',
      'Identify a time they tried something hard',
      'Build language for "not yet"',
    ],
    parent_follow_up:
      "Ask: \"What's something hard that you're still growing at?\" Celebrate the effort, not the result.",
    published: true,
    version: 1,
  },

  // ── Games ──────────────────────────────────────────────────────────────────
  {
    title: 'Counting Rainbow',
    type: 'game',
    age_ranges: ['3-7'],
    duration_minutes: 6,
    media_refs: [],
    skills_targeted: ['counting', 'color recognition', 'number sense'],
    learning_objectives: [
      'Count to 10 with 1:1 correspondence',
      'Name 7 rainbow colors',
      'Match quantity to numeral',
    ],
    parent_follow_up:
      'Count things around the house together — stairs, toys, shoes. Count in a fun voice (robot, whisper, silly).',
    published: true,
    version: 1,
  },
  {
    title: 'Shape Detective',
    type: 'game',
    age_ranges: ['3-7'],
    duration_minutes: 7,
    media_refs: [],
    skills_targeted: ['shape recognition', 'spatial reasoning', 'visual discrimination'],
    learning_objectives: [
      'Name circle, square, triangle, rectangle',
      'Find shapes in real environments',
      'Describe shape properties (sides, corners)',
    ],
    parent_follow_up:
      'Go on a shape hunt around the house. Who can find the most circles? Most triangles?',
    published: true,
    version: 1,
  },
  {
    title: 'Letter Sounds Safari',
    type: 'game',
    age_ranges: ['3-7'],
    duration_minutes: 8,
    media_refs: [],
    skills_targeted: ['phonics', 'letter recognition', 'pre-reading'],
    learning_objectives: [
      'Match 10 letters to their sounds',
      'Identify words that start with a given sound',
      'Build phonemic awareness',
    ],
    parent_follow_up:
      'Play "I Spy" with sounds: "I spy something that starts with the /s/ sound." Take turns being the spy.',
    published: true,
    version: 1,
  },

  // ── Music ──────────────────────────────────────────────────────────────────
  {
    title: 'Feelings in My Body',
    type: 'music',
    age_ranges: ['3-7'],
    duration_minutes: 5,
    media_refs: [],
    skills_targeted: ['body awareness', 'emotional expression', 'movement'],
    learning_objectives: [
      'Connect emotions to physical sensations',
      'Express feelings through movement',
      'Practice calming strategies through song',
    ],
    parent_follow_up:
      'Ask your child to show you with their body what "happy" feels like, then "sad," then "calm."',
    published: true,
    version: 1,
  },
  {
    title: 'The Alphabet Groove',
    type: 'music',
    age_ranges: ['3-7'],
    duration_minutes: 6,
    media_refs: [],
    skills_targeted: ['letter recognition', 'sequence', 'rhythm and music'],
    learning_objectives: [
      'Recite alphabet with rhythm',
      'Associate letters with actions',
      'Develop beat awareness',
    ],
    parent_follow_up:
      'Make up actions for each letter of their name. Sing it together at breakfast.',
    published: true,
    version: 1,
  },

  // ── Additional activities (add 8 more before launch) ──────────────────────
  // Types needed: story x2, game x3, music x3 more
  // Skills to target: numbers/math, listening comprehension, creative thinking,
  // social skills (sharing, taking turns), gross motor, fine motor
];

async function seedContent() {
  console.log('Seeding Firestore content library...');

  // Seed parent guides
  const guideBatch = db.batch();
  for (const guide of parentGuides) {
    const ref = db.collection('parent_guides').doc();
    guideBatch.set(ref, guide);
  }
  await guideBatch.commit();
  console.log(`✓ Seeded ${parentGuides.length} parent guides`);

  // Seed child activities
  const activityBatch = db.batch();
  for (const activity of childActivities) {
    const ref = db.collection('child_activities').doc();
    activityBatch.set(ref, activity);
  }
  await activityBatch.commit();
  console.log(`✓ Seeded ${childActivities.length} child activities`);

  console.log('Content seeding complete.');
}

seedContent()
  .then(() => process.exit(0))
  .catch((err) => {
    console.error('Seeding failed:', err);
    process.exit(1);
  });
