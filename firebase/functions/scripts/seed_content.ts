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

  // ── Behavior (continued) ──────────────────────────────────────────────────
  {
    title: 'Surviving Transitions: When Kids Refuse to Stop',
    category: 'behavior',
    age_ranges: ['0-3', '3-7'],
    situation_tags: ['transitions', 'stopping', 'leaving', 'meltdown', 'wont stop', 'refuses to leave'],
    quick_response:
      "Give a 5-minute warning before every transition. Kids resist stopping because they can't shift gears quickly — your warning gives their brain time to prepare. 'Five more minutes, then we clean up.'",
    full_guide: `## Why transitions are hard\nKids live in the present. When they're deep in play, their brain doesn't have the neurological machinery yet to easily interrupt and shift. Transitions feel like losses — they're giving up something they want.\n\n## The 5-minute warning system\n1. **Warning at 5 minutes:** "Five more minutes, then we're leaving."\n2. **Warning at 2 minutes:** "Two more minutes."\n3. **One-minute notice:** "One more minute, then shoes on."\n4. **Time's up:** State it calmly, act on it. No negotiation.\n\n## What makes transitions easier\n- Give them something to look forward to: "After we leave the park, we'll have a snack in the car."\n- Let them have a small sense of control: "Do you want to say bye to the swings or the slide first?"\n- Be consistent — if you always follow through, they stop pushing the boundary as much\n- Acknowledge the feeling: "I know it's hard to stop. You were really into that."\n\n## What doesn't help\n- Sudden announcements: "Okay, we're leaving now!" (no warning)\n- Empty countdowns: "1... 2... 3... okay, one more minute"\n- Bribery every time — teaches them to hold out for the offer\n- Getting into a power struggle over it`,
    research_basis: [
      'Lansbury, J. (2014). No Bad Kids.',
      'Bodrova, E. & Leong, D.J. (2007). Tools of the Mind.',
    ],
    do_this: [
      'Give 5-minute and 2-minute warnings consistently',
      'Offer a small choice during the transition',
      'Follow through every time',
    ],
    not_that: [
      'Surprise announcements with no warning',
      'Empty countdowns you don\'t follow through on',
      'Bribery as the default tool',
    ],
    follow_up_activity_ids: [],
    published: true,
    version: 1,
  },
  {
    title: 'Sharing Struggles: Why Kids Find It Hard and What to Do',
    category: 'behavior',
    age_ranges: ['0-3', '3-7'],
    situation_tags: ['sharing', 'mine', 'wont share', 'taking toys', 'sibling', 'possessive'],
    quick_response:
      "Sharing is a complex social skill — not a reflex. Children under 4 genuinely can't do it easily. Instead of forcing it, teach turn-taking with a clear structure: 'You have it for 3 minutes, then it's her turn.'",
    full_guide: `## Developmentally, this is expected\nTrue voluntary sharing requires impulse control, perspective-taking, and trust that the toy will come back. Most children aren't neurologically ready for this before age 4-6. Forcing it teaches compliance, not generosity.\n\n## What works better than forcing\n**Turn-taking with timers:**\n- "You have it until the timer beeps. Then it's her turn."\n- Use a visual timer they can both see\n- Both children agree to the rules before the timer starts\n\n**Protect ownership:**\n- Let children identify toys that are "special" and don't have to be shared\n- Having protected items actually makes kids more willing to share everything else\n\n**Problem-solve together (for older kids):**\n- "You both want the truck. What are some ideas?"\n- Accept their solutions even if they're imperfect\n\n## What to avoid\n- Forcing: "Give it to your sister right now" — models power, not generosity\n- Praising the giver while ignoring the effort it took: "Good sharing!" feels hollow\n- Framing it as a character trait: "You're not being nice" — this creates shame, not change`,
    research_basis: [
      'Kohn, A. (2005). Unconditional Parenting.',
      'Markham, L. (2012). Peaceful Parent, Happy Kids.',
    ],
    do_this: [
      'Use timer-based turn-taking instead of forcing',
      'Let them have a few "protected" items they don\'t have to share',
      'Problem-solve together for older kids',
    ],
    not_that: [
      'Force immediate sharing',
      'Shame: "Why won\'t you share?"',
      'Always intervene — let them try to work it out first',
    ],
    follow_up_activity_ids: [],
    published: true,
    version: 1,
  },
  {
    title: "When Kids Lie: What It Means and What to Do",
    category: 'behavior',
    age_ranges: ['3-7'],
    situation_tags: ['lying', 'not telling the truth', 'fibbing', 'dishonest', 'making things up'],
    quick_response:
      "Young children lie for three reasons: to avoid getting in trouble, to get something they want, or because they genuinely can't distinguish fantasy from reality yet. Focus on creating safety to tell the truth — not catching them in lies.",
    full_guide: `## Types of lying (they're different)\n**Fantasy/magical thinking (ages 2-4):** Not really lying — they genuinely can't distinguish wishful thinking from reality. "I already brushed my teeth" might mean they wish they had.\n\n**Avoid-trouble lying (ages 4+):** Classic lying. They know what they did and want to avoid consequences.\n\n**Social lies:** "I'm fine" — normal and actually a sign of social intelligence.\n\n## The truth-telling environment\nThe biggest predictor of children telling the truth is how safe it feels to do so. If telling the truth consistently leads to yelling or harsh punishment, lying becomes rational.\n\n- **Lower the stakes:** "I won't be angry. I just need to know what happened."\n- **Separate confession from punishment:** Sometimes acknowledge the honesty separately from addressing the behavior\n- **Don't ask questions you already know the answer to:** "Did you eat that cookie?" when you know they did sets up the lie. Say instead: "I see the cookie is gone."\n\n## Consequences for lying\n- Ages 3-4: redirect, don't shame. They're still figuring it out.\n- Ages 5+: brief, calm consequence. Emphasize trust: "When I don't know if something is true, I worry more, not less."`,
    research_basis: [
      'Talwar, V. & Lee, K. (2008). Social and Cognitive Correlates of Children\'s Lying Behavior.',
      'Ames, L.B. (1952). The Development of the Sense of Time in the Young Child.',
    ],
    do_this: [
      'Create a low-stakes truth-telling environment',
      'Separate confession acknowledgment from consequence',
      'Don\'t set up lie-traps by asking questions you know the answer to',
    ],
    not_that: [
      'Shame or overreact to lying',
      'Catch them in lies as a gotcha',
      'Assume lying means something is deeply wrong with them',
    ],
    follow_up_activity_ids: [],
    published: true,
    version: 1,
  },
  {
    title: 'Back Talk: When Kids Push Back on Everything',
    category: 'behavior',
    age_ranges: ['3-7'],
    situation_tags: ['back talk', 'talking back', 'rude', 'disrespectful', 'arguing', 'no', 'wont listen'],
    quick_response:
      "Some pushback is developmentally healthy — it means they're building independence. The goal isn't silence; it's respectful disagreement. Name the line: 'You can disagree, but not like that. Try again.'",
    full_guide: `## Why it happens\nBack talk peaks as children develop autonomy and language. They're learning to assert themselves and testing where the limits are. Some of it is age-appropriate independence. Some is learned behavior from modeled behavior. Some is genuine upset.\n\n## The line between assertion and disrespect\nTeach the difference:\n- **Okay:** "I don't want to" / "That's not fair" / "I disagree"\n- **Not okay:** Insults, mocking tone, yelling, name-calling\n\nSay it clearly: "You're allowed to say you don't want to do something. You're not allowed to say it that way. Try again."\n\n## How to respond\n1. Don't escalate. A calm, flat response deflates the power dynamic.\n2. Name the problem: "The way you said that wasn't okay."\n3. Give them a redo: "Try that again with respect."\n4. Don't lecture. One sentence is enough.\n\n## Check what's underneath\nFrequent back talk sometimes signals: too many commands, not enough autonomy, or a child who feels unheard. More choices and more "yes" throughout the day can reduce the frequency.\n\n## What not to do\n- Get louder — they'll match your volume\n- Enter a debate — you don't need to win the argument\n- Take it personally — it's a developmental phase, not a verdict on you`,
    research_basis: [
      'Faber, A. & Mazlish, E. (1980). How to Talk So Kids Will Listen.',
      'MacKenzie, R. (2001). Setting Limits with Your Strong-Willed Child.',
    ],
    do_this: [
      'Name the line between assertion and disrespect',
      'Give a redo: "Try that again with respect."',
      'Stay calm and flat — don\'t match their energy',
    ],
    not_that: [
      'Get into a debate',
      'Escalate your volume',
      'Punish the emotion — only address the delivery',
    ],
    follow_up_activity_ids: [],
    published: true,
    version: 1,
  },

  // ── Sleep (continued) ────────────────────────────────────────────────────────
  {
    title: 'Nightmares and Night Terrors: What They Are and How to Help',
    category: 'sleep',
    age_ranges: ['3-7'],
    situation_tags: ['nightmare', 'night terror', 'bad dream', 'scared at night', 'wakes up screaming', 'scared of dark'],
    quick_response:
      "Nightmares: child wakes, remembers the dream, needs comfort. Night terrors: child appears awake (eyes open, screaming) but isn't — they won't remember it. Nightmares need your presence. Night terrors need you to stay calm and wait.",
    full_guide: `## Nightmares vs. Night Terrors\n\n**Nightmares:**\n- Child wakes fully, is aware of you, remembers the dream\n- Usually in the second half of the night (REM sleep)\n- Ages 3-7 — peak period of imagination + fear development\n\n**Night Terrors:**\n- Child appears awake but isn't — eyes open, may be screaming or thrashing\n- Usually in the first 1-3 hours after falling asleep (deep NREM sleep)\n- Child won't remember it in the morning\n- Do NOT try to wake them — makes it worse and more confusing\n\n## How to help with nightmares\n1. Go to them quickly — presence is the intervention\n2. Don't dismiss: "It was just a dream" feels minimizing. Try: "That sounds really scary. I'm right here."\n3. Keep the lights low; sit with them until calm\n4. Brief check under the bed if they need it — don't refuse or mock it\n5. Get back in their bed with them briefly, then transition back to your room\n\n## How to handle night terrors\n1. Don't try to wake them — wait it out (usually 5-10 min)\n2. Stay nearby to prevent falls\n3. Keep the room calm and dark\n4. Don't discuss it in the morning unless they bring it up\n\n## Prevention strategies\n- Consistent bedtime reduces night terrors (overtiredness triggers them)\n- Address daytime fears proactively — what they suppress during day surfaces at night\n- Brief relaxation ritual before bed (deep breaths, progressive muscle relaxation for older kids)`,
    research_basis: [
      'Mindell, J.A. & Owens, J. (2015). A Clinical Guide to Pediatric Sleep.',
      'American Academy of Sleep Medicine, Pediatric Sleep Guidelines.',
    ],
    do_this: [
      'Respond quickly to nightmares with calm presence',
      'Don\'t try to wake a child in a night terror — wait it out',
      'Treat daytime fears as contributors to nighttime fears',
    ],
    not_that: [
      'Dismiss the dream: "It wasn\'t real"',
      'Shake or forcibly wake during a night terror',
      'Turn on bright lights',
    ],
    follow_up_activity_ids: [],
    published: true,
    version: 1,
  },
  {
    title: 'Early Morning Waking',
    category: 'sleep',
    age_ranges: ['0-3', '3-7'],
    situation_tags: ['early waking', 'wakes up too early', '5am', '6am', 'morning', 'up too early'],
    quick_response:
      "Most early waking is a circadian rhythm issue, not a sleep problem. The fix is almost always a later bedtime — counterintuitive but supported by research. If they're waking before 6 AM, push bedtime 15 minutes later and hold for 5 days.",
    full_guide: `## Why early waking happens\n- **Circadian drive:** Their internal clock is naturally set earlier than adults\n- **Overtiredness:** When kids are undertired, they wake earlier (not later)\n- **Light:** Any light can trigger waking in young children — sunrise, streetlights, hallway light under door\n- **Noise:** Household sounds at 6 AM feel louder when brain is in light sleep\n\n## The counterintuitive fix: Later bedtime\nOvertired kids wake up early. A later bedtime (by 15-minute increments over a week) often solves 5 AM waking. Try this before anything else.\n\n## Environmental changes\n- **Blackout curtains:** Non-negotiable if early waking is the problem. Light is the #1 trigger.\n- **White noise:** Masks household sounds\n- **Room temperature:** 68-72°F is optimal for sleep\n\n## Teaching "quiet time" (ages 3+)\n- Use an OK-to-Wake clock — green light at an appropriate time (never before 6 AM)\n- Teach: "When the light is green, you can come out. Until then, quiet time in your room."\n- Stock their room with books, quiet toys (not screens)\n- Hold the line consistently — this takes 1-2 weeks to stick\n\n## What doesn't work\n- Putting them to bed earlier (will likely make it worse)\n- Keeping them up later hoping they sleep in (they don't — they just become overtired)\n- Responding immediately every time before 6 AM (reinforces the pattern)`,
    research_basis: [
      'Weissbluth, M. (2003). Healthy Sleep Habits, Happy Child.',
      'Mindell, J.A. & Owens, J. (2015). A Clinical Guide to Pediatric Sleep.',
    ],
    do_this: [
      'Install blackout curtains (single biggest environmental fix)',
      'Try pushing bedtime 15 minutes later',
      'Use an OK-to-Wake clock for ages 3+',
    ],
    not_that: [
      'Put them to bed earlier to compensate',
      'Immediately respond before 6 AM every time',
      'Let early waking become a habit pattern',
    ],
    follow_up_activity_ids: [],
    published: true,
    version: 1,
  },

  // ── Emotions (continued) ─────────────────────────────────────────────────────
  {
    title: 'Separation Anxiety: When Saying Goodbye Is Hard',
    category: 'emotions',
    age_ranges: ['0-3', '3-7'],
    situation_tags: ['separation anxiety', 'clingy', 'wont leave mom', 'wont go to school', 'cries at dropoff', 'scared to be alone'],
    quick_response:
      "Separation anxiety is a sign of healthy attachment — your child loves you and hasn't yet fully internalized that you always come back. The fix is consistent, confident goodbyes and always coming back when you said you would.",
    full_guide: `## Why separation anxiety happens\nSeparation anxiety peaks at 8-14 months (object permanence developing), then again at ages 2-3. It resurfaces in some children at 5-7 with new school transitions. It's a feature of healthy attachment, not a problem.\n\n## The goodbye protocol\nConsistency and confidence are everything:\n1. **Acknowledge the feeling:** "I know you'll miss me. I'll miss you too."\n2. **Give a clear, brief goodbye:** Don't linger — it makes it harder\n3. **State your return clearly:** "I'll pick you up right after snack time." Use concrete anchors, not clock times.\n4. **Leave confidently:** A hesitant parent signal escalates the child\n5. **Always come back when you said you would.** Every promise kept builds the internal model: "They always come back."\n\n## What makes it worse\n- Sneaking out (seems kind, destroys trust)\n- Staying and soothing for too long (signals danger)\n- Delaying departure when they cry (rewards the behavior)\n- Skipping school to avoid the distress (the problem compounds)\n\n## When to be concerned\nMost separation anxiety resolves within weeks of consistent practice. If it's: interfering with sleep, causing physical symptoms (nausea, headaches), or not improving after 4+ weeks of consistent goodbye routines — talk to your pediatrician.`,
    research_basis: [
      'Ainsworth, M.D.S. (1978). Patterns of Attachment.',
      'Lieberman, A.F. (1993). The Emotional Life of the Toddler.',
    ],
    do_this: [
      'Brief, confident goodbye with a return-time anchor',
      'Always follow through on when you said you\'d return',
      'Acknowledge the feeling — then leave',
    ],
    not_that: [
      'Sneak out',
      'Linger because they\'re upset',
      'Skip the experience to avoid the distress',
    ],
    follow_up_activity_ids: [],
    published: true,
    version: 1,
  },
  {
    title: 'Anger: When Kids Lose It',
    category: 'emotions',
    age_ranges: ['3-7'],
    situation_tags: ['anger', 'angry', 'rage', 'loses it', 'explosive', 'out of control', 'furious'],
    quick_response:
      "Anger is a normal emotion — the goal isn't to eliminate it, it's to teach your child to feel it without hurting anyone. In the moment: safety first, then presence. Problem-solving happens later, when the brain is back online.",
    full_guide: `## Anger is information\nAnger usually signals a blocked goal, a perceived injustice, or overwhelm. It's not a character flaw. The goal is to help children: (1) feel the anger, (2) not act on it in harmful ways, and (3) eventually express it in words.\n\n## In the moment: the 3-step response\n1. **Safety first:** If they're hitting, throwing, or hurting themselves — calmly interrupt. "I need to keep you and everyone safe right now."\n2. **Stay present but don't engage:** Your calm presence co-regulates their nervous system. Don't argue, reason, or lecture.\n3. **Wait for the storm to pass.** It will. Usually 5-10 minutes.\n\n## After calm: the teaching moment\n- "That was really hard. What happened?"\n- Name what you saw: "It seemed like you were really angry when..."\n- Problem-solve together: "Next time you feel that angry, what could you do instead?"\n\n## Building the anger vocabulary\nTeach specific physical cues:\n- "Your fists are clenching — that's your body's anger signal."\n- "Your chest is getting tight — that's rage building."\n- "Your voice is getting loud — that means you're feeling really frustrated."\n\n## Anger tools (teach when calm, use when needed)\n- Big breaths: breathe in for 4, hold for 4, out for 4\n- "Stomp walk" outside\n- Pillow to punch\n- Physical outlet: run, jump, dance\n- The "volcano" — hands up, breathe in, arms down, breathe out`,
    research_basis: [
      'Siegel, D.J. & Bryson, T.P. (2014). No-Drama Discipline.',
      'Gottman, J. (1997). Raising an Emotionally Intelligent Child.',
    ],
    do_this: [
      'Ensure safety, then stay present through the anger',
      'Teach anger tools during calm moments, not during the meltdown',
      'Save problem-solving for after the child is regulated',
    ],
    not_that: [
      'Reason or lecture during the anger peak',
      'Try to eliminate anger (it\'s a healthy emotion)',
      'Punish the feeling — only redirect harmful behaviors',
    ],
    follow_up_activity_ids: ['activity-emotions-001'],
    published: true,
    version: 1,
  },
  {
    title: "Disappointment: When They Can't Have What They Want",
    category: 'emotions',
    age_ranges: ['0-3', '3-7'],
    situation_tags: ['disappointment', 'wont accept no', 'upset at no', 'can\'t have it', 'wants something', 'not getting their way'],
    quick_response:
      "Your job isn't to prevent disappointment — it's to help them move through it. Say no clearly, acknowledge the feeling, and resist the urge to explain, justify, or negotiate. 'I know you really want that. The answer is no.'",
    full_guide: `## Why this is hard for parents\nWatching your child be disappointed is uncomfortable. The impulse is to fix it: explain, negotiate, offer a compromise. But rescuing children from all disappointment denies them the practice they need to develop resilience.\n\n## How to say no well\n1. **Be direct:** "No." Not "We'll see" or "Maybe later" if you mean no.\n2. **Acknowledge the feeling:** "I know that's disappointing. You really wanted that."\n3. **Hold the limit.** Don't negotiate once you've given the answer.\n4. **Brief empathy, not lengthy explanation.** Explanations invite debate.\n\n## The "no" that sticks\n- Decide before you respond — a "no" that turns into a "yes" teaches them to push harder next time\n- Same answer from both parents — mixed signals invite prolonged attempts\n- Say it calmly and warmly: "I love you and the answer is no."\n\n## What disappointment is teaching them\nEvery time a child experiences a "no" and survives it, they learn:\n- Uncomfortable feelings pass\n- They can handle not getting what they want\n- Their parent is consistent and trustworthy\n\n## Age note\nUnder 2: Distract and redirect — reasoning won't work yet.\nAges 3-5: Brief acknowledge + firm limit.\nAges 6+: Brief explanation acceptable, but still not a negotiation.`,
    research_basis: [
      'Brooks, R. & Goldstein, S. (2001). Raising Resilient Children.',
      'Seligman, M. (1995). The Optimistic Child.',
    ],
    do_this: [
      'Say no clearly — don\'t soften it into a "maybe"',
      'Acknowledge the disappointment without reversing the decision',
      'Hold the limit once set',
    ],
    not_that: [
      'Rescue them from all disappointment',
      'Turn a "no" into a "yes" to end the upset',
      'Over-explain or debate the reason',
    ],
    follow_up_activity_ids: [],
    published: true,
    version: 1,
  },

  // ── Routines ────────────────────────────────────────────────────────────────
  {
    title: 'Morning Routines That Actually Work',
    category: 'routines',
    age_ranges: ['3-7'],
    situation_tags: ['morning', 'morning routine', 'getting ready', 'rush', 'getting dressed', 'chaos'],
    quick_response:
      "Mornings fail because adults run the routine and kids resist. Flip it: give your child ownership of a visual checklist (pictures, not words). When they're managing their own routine, the power struggle disappears.",
    full_guide: `## The root cause of morning chaos\nMost morning failures are caused by: too little time, too many parent-initiated commands, and no built-in ownership for the child. Kids who feel managed resist. Kids who feel ownership cooperate.\n\n## The picture checklist system\nFor ages 3+: Create a laminated card with 5-7 pictures in order:\n1. Wake up / Bathroom\n2. Get dressed\n3. Eat breakfast\n4. Brush teeth\n5. Shoes on\n\nTheir job: check each item off. Your job: stay out of it unless asked.\n\n## Time buffers\n- Add 15 minutes to how long you think it will take\n- Do your own prep before waking them\n- If you're running late, it's a planning problem, not a behavior problem\n\n## Handling getting dressed\n- Lay out two outfit options the night before. Let them choose one.\n- No choice = more resistance. Two options = enough autonomy\n- Weather-appropriate clothing — let them learn from mild natural consequences (slightly cold) rather than daily battles\n\n## The "natural consequence" for dawdling\nIf they miss the bus, or the family is late, say once: "That happened because we ran out of time." Don't lecture. Don't rescue. Let it land.`,
    research_basis: [
      'Fogg, B.J. (2020). Tiny Habits.',
      'Markham, L. (2012). Peaceful Parent, Happy Kids.',
    ],
    do_this: [
      'Create a visual checklist with pictures — give them ownership',
      'Lay out clothes the night before with 2 options',
      'Add 15 minutes to your estimated prep time',
    ],
    not_that: [
      'Issue commands for every step ("Get dressed! Now brush your teeth!")',
      'Rescue from natural consequences of dawdling',
      'Wait to start your own prep until they\'re already awake',
    ],
    follow_up_activity_ids: [],
    published: true,
    version: 1,
  },
  {
    title: 'Picky Eating: When Mealtime Becomes a Battle',
    category: 'routines',
    age_ranges: ['0-3', '3-7'],
    situation_tags: ['picky eating', 'wont eat', 'refuses food', 'mealtimes', 'only eats one thing', 'food refusal'],
    quick_response:
      "Division of responsibility: you decide what, when, and where food is offered. Your child decides whether and how much to eat. When parents take over the second part — cajoling, forcing, bribing — it almost always backfires.",
    full_guide: `## The "division of responsibility" framework\nDeveloped by feeding therapist Ellyn Satter — consistently the most evidence-supported approach to picky eating:\n\n**Your job:** Decide what foods are offered, when meals happen, and where eating takes place.\n**Their job:** Decide whether to eat and how much.\n\nThis framework, applied consistently, produces children who are better eaters over time — not overnight.\n\n## Why forcing doesn't work\n- Creates negative associations with food and mealtimes\n- Overrides the child's internal hunger/fullness signals\n- Turns mealtime into a power struggle, which the child will win\n\n## Practical strategies\n- Serve one "safe" food with every meal that you know they'll eat (without the meal revolving around it)\n- Serve family food — they don't need a special kids' menu\n- Repeated exposure matters: a child may need to see a new food 10-15 times before tasting it\n- "You don't have to eat it, but it stays on your plate" — exposure without pressure\n- Eat together when possible — children eat more variety when they watch adults eat it\n\n## Red flags (actual concern, not just picky)\n- Eating fewer than 20 foods total\n- Gagging or retching on textures\n- No new food acceptance after months of exposure\n- Fear response (not dislike) to new foods\n- Falling off growth curve\n→ Consult your pediatrician; a feeding therapist may help`,
    research_basis: [
      'Satter, E. (2000). Child of Mine: Feeding with Love and Good Sense.',
      'Forestell, C.A. (2017). Flavor Perception and Preference Development in Human Infants.',
    ],
    do_this: [
      'Follow the division of responsibility (your job: what/when/where. Their job: whether/how much)',
      'Serve one safe food alongside new foods without making a separate meal',
      'Keep offering — repeated neutral exposure over weeks matters',
    ],
    not_that: [
      'Force, bribe, or cajole them to eat',
      'Make separate "kid food" for every meal',
      'React with concern or frustration at every refusal (they\'ll use it as leverage)',
    ],
    follow_up_activity_ids: [],
    published: true,
    version: 1,
  },
  {
    title: 'Ending Screen Time Without a Meltdown',
    category: 'routines',
    age_ranges: ['3-7'],
    situation_tags: ['screen time', 'ending screen time', 'taking tablet away', 'meltdown after screens', 'transition off screen'],
    quick_response:
      "Screens are engineered to be hard to leave. The fix is structural: a visible timer that goes off with no negotiation, and a pre-agreed 'what comes next' so the transition has a destination.",
    full_guide: `## Why ending screen time is harder than other transitions\nDigital content is designed to be maximally engaging — autoplay, reward loops, cliffhangers. Asking a child to stop is neurologically harder than any other transition. This is an engineering problem, not a willpower problem.\n\n## The structural solution\n1. **Set the limit before they start:** "You have 30 minutes, then we stop."\n2. **Use a visible timer** they can see (not just a parent announcement)\n3. **5-minute warning:** "Five minutes left."\n4. **When it goes off, it goes off.** No "just one more." No exceptions.\n\n## The "what comes next" bridge\nScreens are easier to leave if there's something to go to:\n- "After screens, we're going outside."\n- "After screens, you get to help me cook dinner."\n- Make the next thing mildly interesting\n\n## If they meltdown anyway\n- Don't restore screen time to calm them down\n- Acknowledge: "I know that's hard to stop. You can be upset about it."\n- Let the feeling move through — don't fix it with more screens\n\n## Reducing the overall pattern\n- No screens during meals\n- No screens in the hour before bed\n- Screens as one activity among many, not the default fill`,
    research_basis: [
      'American Academy of Pediatrics (2016). Media and Young Minds.',
      'Rosen, L.D. (2012). iDisorder.',
    ],
    do_this: [
      'Set time limit before screens start',
      'Use a visible countdown timer',
      'Have a "what comes next" ready',
    ],
    not_that: [
      'Restore screen time to calm the meltdown',
      'Use screens as the default boredom solution',
      'Negotiate after the timer goes off',
    ],
    follow_up_activity_ids: [],
    published: true,
    version: 1,
  },

  // ── Development (continued) ──────────────────────────────────────────────────
  {
    title: 'Potty Training: What Actually Works',
    category: 'development',
    age_ranges: ['0-3', '3-7'],
    situation_tags: ['potty training', 'toilet training', 'accidents', 'wont use potty', 'regression', 'poop refusal'],
    quick_response:
      "Potty training readiness matters more than age or timing. Most children are ready between 2.5-3.5 years. Start when they can follow 2-step instructions, show interest, and can pull pants up/down. Rushing before readiness adds weeks — waiting costs nothing.",
    full_guide: `## Readiness signs (most important)\n- Stays dry for 1-2 hour stretches\n- Shows awareness before/during/after eliminating\n- Can follow 2-step instructions\n- Can pull pants up and down independently\n- Shows interest (even if not excitement)\n\n## The 3-day method (most common effective approach)\n**Day 1:** Underpants all day at home, no diaper. Child stays with you in a small area. Every 20-30 minutes, prompt gently. Celebrate every use of the potty.\n**Day 2:** Continue at home. Begin introducing outings with spare clothes.\n**Day 3:** Short outings. Practice public restrooms.\n\nCritical: Don't go back to diapers except for sleep. Mixed signals extend training.\n\n## Accidents\n- Expected. Don't shame or punish.\n- Matter-of-fact response: "Oops, that's what underpants are for. Let's clean up."\n- Keep spares everywhere: car, daycare, grandparents\n\n## Poop refusal (very common)\n- Withholding poop is a fear response, not defiance\n- Don't force — it escalates fear and can create constipation\n- Warm baths relax the body; try after bath\n- "Just try sitting" without pressure\n- If withholding is consistent for days with visible discomfort: talk to your pediatrician\n\n## Regression\nRegression after illness, new sibling, or major change is normal. Return to extra support and less pressure temporarily. Don't start over completely.`,
    research_basis: [
      'American Academy of Pediatrics, Toilet Training Guidelines.',
      'Choby, B.A. & George, S. (2008). Toilet Training. American Family Physician.',
    ],
    do_this: [
      'Wait for readiness signs before starting',
      'Commit fully once you start — no going back to diapers except sleep',
      'Matter-of-fact response to accidents (no shame)',
    ],
    not_that: [
      'Rush to start because of age or pressure from others',
      'Shame or punish accidents',
      'Force poop — address fear with warmth, not pressure',
    ],
    follow_up_activity_ids: [],
    published: true,
    version: 1,
  },
  {
    title: 'Social Skills: Helping Kids Make Friends',
    category: 'development',
    age_ranges: ['3-7'],
    situation_tags: ['social skills', 'making friends', 'shy', 'doesnt play with others', 'lonely', 'left out', 'social anxiety'],
    quick_response:
      "Friendship skills are learned — not innate. Kids who struggle socially usually need more low-stakes practice, not more advice. The best thing you can do is create more play opportunities and teach a few specific entry scripts.",
    full_guide: `## What friendship skills actually are\nFriendship requires: reading social cues, entering play, maintaining play, resolving conflict, perspective-taking. These are skills — they can be taught.\n\n## Common struggles and what helps\n\n**Can't enter group play:**\n- Teach the "watch, then join" approach: observe for a minute, find a natural opening, comment on what they're doing ("What are you building?")\n- Avoid "Can I play?" — it invites rejection. "I'll be the red builder" (joining action) works better.\n\n**Plays parallel but not together:**\n- Parallel play is developmentally normal until age 4-5\n- Gently coach: "You could ask what that part does."\n- Don't force interaction\n\n**Bossy or struggles to share play control:**\n- Practice "yes, and" games at home\n- Role-play scenarios with stuffed animals or dolls\n- Name it: "Friendships work better when both people get to decide things."\n\n## Creating opportunities\n- 1-on-1 playdates > large groups for kids who struggle socially\n- Structure activities (crafts, games) rather than open-ended time for kids who don't know what to do\n- Brief (90-minute) rather than long playdates — end on a high note\n\n## When to be more concerned\n- Actively rejected (not just excluded) by peers consistently\n- No interest in other children at all by age 4+\n- Deep distress about friendships that isn't improving\n→ School counselor or pediatrician referral may help`,
    research_basis: [
      'Ladd, G.W. (2005). Children\'s Peer Relations and Social Competence.',
      'Thompson, M. & O\'Neill Grace, C. (2001). Best Friends, Worst Enemies.',
    ],
    do_this: [
      'Teach concrete entry scripts ("What are you building?")',
      'Create 1-on-1 structured playdates',
      'Practice social scenarios at home through play',
    ],
    not_that: [
      'Force interactions',
      'Overintervene in social conflicts — let small things work out',
      'Label them as "shy" in front of others',
    ],
    follow_up_activity_ids: [],
    published: true,
    version: 1,
  },
  {
    title: 'Getting Ready to Read: Building Pre-Literacy Skills',
    category: 'development',
    age_ranges: ['0-3', '3-7'],
    situation_tags: ['reading', 'pre-reading', 'literacy', 'letters', 'phonics', 'learning to read', 'books'],
    quick_response:
      "Reading readiness is built in conversation — not flashcards. The three biggest predictors of reading success: vocabulary size, phonemic awareness (hearing sounds in words), and love of books. All three come from daily read-alouds and conversation.",
    full_guide: `## What pre-literacy actually is\nBefore a child can read, they need:\n1. **Print awareness:** Books have words. Words go left to right. Letters make sounds.\n2. **Phonemic awareness:** The ability to hear and play with individual sounds in words.\n3. **Vocabulary:** You can't read a word you don't know.\n4. **Letter knowledge:** Names and sounds of letters.\n5. **Motivation:** Wanting to read.\n\n## How to build each one\n\n**Print awareness:**\n- Run your finger under words as you read\n- Point out signs, labels, menus\n- "That says 'STOP.' S-T-O-P."\n\n**Phonemic awareness:**\n- Rhyme games: "Cat — what rhymes with cat? Bat, mat, hat!"\n- Sound games: "I'm thinking of something in the kitchen that starts with /s/."\n- Clap syllables: "Ba-na-na: 3 claps!"\n\n**Vocabulary:**\n- Talk constantly. Narrate what you're doing.\n- Read books above their level — picture books have sophisticated vocabulary\n- Explain words in context: "Enormous means really, really big."\n\n**Letter knowledge:**\n- Alphabet songs and books\n- Letter magnets on the fridge — spell their name daily\n- Name letters when you see them in the environment\n\n## Reading aloud tips\n- Read daily — even 10 minutes makes a difference\n- Let them choose the books (even if you've read it 50 times)\n- Stop and ask questions: "What do you think will happen next?"\n- Silly voices, character voices — anything that makes it fun`,
    research_basis: [
      'Adams, M.J. (1990). Beginning to Read: Thinking and Learning About Print.',
      'Whitehurst, G.J. & Lonigan, C.J. (1998). Child Development and Emergent Literacy.',
    ],
    do_this: [
      'Read aloud daily — at least 10-15 minutes',
      'Play rhyme and sound games during everyday moments',
      'Point to words as you read them',
    ],
    not_that: [
      'Drill flashcards — it builds compliance, not love of reading',
      'Correct every mispronunciation — engagement matters more',
      'Wait for school to start teaching pre-literacy',
    ],
    follow_up_activity_ids: [],
    published: true,
    version: 1,
  },
];

// ── Child Activities ─────────────────────────────────────────────────────────
// MVP minimum: 15 activities across story/game/music, primarily 3-7 age range

const childActivities: Omit<ChildActivity, 'id'>[] = [
  // ── Stories ────────────────────────────────────────────────────────────────
  // All 6 MVP stories — scripts in docs/seedling/story-0*.md
  {
    title: 'Sparks and the End of Park Time',
    type: 'story',
    age_ranges: ['3-7'],
    duration_minutes: 5,
    media_refs: [],
    skills_targeted: ['emotional_regulation', 'transition_coping', 'co_regulation', 'asl_angry', 'asl_all_done'],
    learning_objectives: [
      'Big feelings are normal and survivable',
      'Name the ANGRY feeling in the moment',
      'Practice the ASL sign for ANGRY and ALL DONE',
    ],
    parent_follow_up:
      'Ask: "Remember when Sparks didn\'t want to leave the park? Has that ever happened to you? What does that feeling feel like in your body?"',
    published: true,
    version: 1,
  },
  {
    title: 'Zee Tries Something New',
    type: 'story',
    age_ranges: ['3-7'],
    duration_minutes: 4,
    media_refs: [],
    skills_targeted: ['fear_of_new', 'emotional_regulation', 'courage', 'asl_scared', 'asl_try'],
    learning_objectives: [
      'Scared and brave can happen at the same time',
      'Practice the ASL sign for SCARED and TRY',
      'Name a time they tried something even though it felt hard',
    ],
    parent_follow_up:
      'Ask: "Is there something you want to try but feel a little scared about? What do you think would happen if you tried?"',
    published: true,
    version: 1,
  },
  {
    title: "Clover's Morning",
    type: 'story',
    age_ranges: ['3-7'],
    duration_minutes: 4,
    media_refs: [],
    skills_targeted: ['routine_building', 'self_regulation', 'problem_solving', 'asl_morning', 'asl_ready'],
    learning_objectives: [
      'Routines are comforting and predictable',
      'Small disruptions can be fixed without the whole routine breaking',
      'Practice the ASL sign for MORNING and READY',
    ],
    parent_follow_up:
      'Ask: "What\'s your favorite part of your morning? Is there anything that feels hard to change?"',
    published: true,
    version: 1,
  },
  {
    title: 'The Same Blue Truck',
    type: 'story',
    age_ranges: ['3-7'],
    duration_minutes: 5,
    media_refs: [],
    skills_targeted: ['conflict_resolution', 'perspective_taking', 'collaborative_problem_solving', 'asl_want', 'asl_together'],
    learning_objectives: [
      'Wanting something another person wants is a normal feeling',
      'There are solutions where everyone gets what they need',
      'Practice the ASL sign for WANT and TOGETHER',
    ],
    parent_follow_up:
      'Ask: "Has that ever happened to you — wanting the same thing as someone else? What did you do?"',
    published: true,
    version: 1,
  },
  {
    title: 'Zee Finds All the Colors',
    type: 'story',
    age_ranges: ['3-7'],
    duration_minutes: 5,
    media_refs: [],
    skills_targeted: ['color_recognition', 'observational_thinking', 'asl_red', 'asl_yellow', 'asl_green', 'asl_blue'],
    learning_objectives: [
      'Name 8 colors: red, orange, yellow, green, blue, purple, white, black',
      'Find colors in the real environment',
      'Practice ASL signs for RED, YELLOW, GREEN, BLUE',
    ],
    parent_follow_up:
      'Go on a color walk — "Zee\'s colors." Let your child lead and name what they find.',
    published: true,
    version: 1,
  },
  {
    title: 'Clover Counts the Steps',
    type: 'story',
    age_ranges: ['3-7'],
    duration_minutes: 4,
    media_refs: [],
    skills_targeted: ['counting_1_to_10', 'one_to_one_correspondence', 'asl_numbers'],
    learning_objectives: [
      'Count from 1 to 10 with one-to-one correspondence',
      'Understand that numbers measure real things',
      'Practice ASL number signs 1-10',
    ],
    parent_follow_up:
      'Go on a counting walk. Count stairs, fence posts, cars — anything. Who can find the most of something?',
    published: true,
    version: 1,
  },

  // ── Games ──────────────────────────────────────────────────────────────────
  {
    title: 'Counting Rainbow',
    type: 'game',
    content_type: 'game_sequence',
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
    content: {
      rounds: [
        {
          prompt: '1, 2, 3, ?',
          sequence: ['1', '2', '3', '?'],
          options: ['4', '5', '6'],
          correct_index: 0,
          hint: "We're counting up by one! What comes after 3?",
          feedback_correct: 'Great! 1, 2, 3, 4!',
          feedback_wrong: 'Try again! Keep counting up: 1, 2, 3...',
        },
        {
          prompt: 'Red, orange, yellow, ?',
          sequence: ['Red', 'Orange', 'Yellow', '?'],
          options: ['Green', 'Blue', 'Purple'],
          correct_index: 0,
          hint: 'Think of a rainbow! Red, orange, yellow, and then...',
          feedback_correct: 'Perfect! That\'s the rainbow order!',
          feedback_wrong: 'Think about a rainbow in the sky. What comes after yellow?',
        },
        {
          prompt: 'Star, star-star, star-star-star, ?',
          sequence: ['⭐', '⭐⭐', '⭐⭐⭐', '?'],
          options: ['⭐⭐⭐⭐', '⭐⭐', '⭐'],
          correct_index: 0,
          hint: 'The stars are growing by one each time!',
          feedback_correct: 'Yes! One more star each time!',
          feedback_wrong: 'Look at the pattern — each time there\'s one more!',
        },
        {
          prompt: '5, 6, 7, ?',
          sequence: ['5', '6', '7', '?'],
          options: ['8', '9', '10'],
          correct_index: 0,
          hint: 'Keep counting! 5, 6, 7... what\'s next?',
          feedback_correct: 'Right! 5, 6, 7, 8!',
          feedback_wrong: 'Count with your fingers: 5, 6, 7...',
        },
        {
          prompt: 'Red, red, blue, blue, ?',
          sequence: ['Red', 'Red', 'Blue', 'Blue', '?'],
          options: ['Red', 'Green', 'Yellow'],
          correct_index: 0,
          hint: 'The pattern goes: two reds, two blues, two...',
          feedback_correct: 'Perfect! Two of each color!',
          feedback_wrong: 'Look at the pattern — pairs of colors!',
        },
        {
          prompt: '2, 4, 6, ?',
          sequence: ['2', '4', '6', '?'],
          options: ['8', '5', '7'],
          correct_index: 0,
          hint: "We're skip-counting by 2! Count on your fingers: 2, 4, 6...",
          feedback_correct: 'Great! Skip-counting by 2s!',
          feedback_wrong: 'Count by 2s — 2, 4, 6... what\'s next?',
        },
      ],
      rounds_to_win: 5,
    },
  },
  {
    title: 'Shape Detective',
    type: 'game',
    content_type: 'game_tap_match',
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
    content: {
      rounds: [
        {
          prompt: 'Which shape has 3 sides?',
          options: ['Circle', 'Triangle', 'Square', 'Rectangle'],
          correct_index: 1,
          hint: 'Make a shape with 3 fingers. It looks like a mountain!',
          feedback_correct: 'Perfect! Triangle has 3 sides!',
          feedback_wrong: 'A triangle has 3 sides. Try again!',
        },
        {
          prompt: 'Which shape has NO sides?',
          options: ['Triangle', 'Square', 'Circle', 'Rectangle'],
          correct_index: 2,
          hint: 'Roll a ball - it goes round and round. What shape is that?',
          feedback_correct: 'Right! A circle has no sides!',
          feedback_wrong: 'Think of something that rolls — a ball!',
        },
        {
          prompt: 'A window is usually which shape?',
          options: ['Triangle', 'Circle', 'Rectangle', 'Square'],
          correct_index: 2,
          hint: 'Look around the room. Windows have 4 sides - 2 long ones and 2 short ones.',
          feedback_correct: 'Yes! Windows are rectangles!',
          feedback_wrong: 'Windows are wider than they are tall — rectangles!',
        },
        {
          prompt: 'How many corners does a square have?',
          options: ['3', '4', '5', '6'],
          correct_index: 1,
          hint: 'Draw a square in the air with your finger. Count each time you turn a corner!',
          feedback_correct: 'Great! 4 corners!',
          feedback_wrong: 'A square has 4 corners. Count them!',
        },
        {
          prompt: 'A pizza slice looks like:',
          options: ['Circle', 'Rectangle', 'Triangle', 'Square'],
          correct_index: 2,
          hint: 'Think about the pointy end you hold. It has 3 sides!',
          feedback_correct: 'Perfect! A triangle!',
          feedback_wrong: 'Pizza slices have a pointy end — triangles!',
        },
        {
          prompt: 'Which shape has 4 equal sides?',
          options: ['Rectangle', 'Circle', 'Square', 'Triangle'],
          correct_index: 2,
          hint: 'All sides the same length. Not long and short - ALL the same!',
          feedback_correct: 'Yes! A square!',
          feedback_wrong: 'All sides equal — that\'s a square!',
        },
      ],
      rounds_to_win: 5,
    },
  },
  {
    title: 'Letter Sounds Safari',
    type: 'game',
    content_type: 'game_tap_match',
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
    content: {
      rounds: [
        {
          prompt: 'What letter says SSSS?',
          options: ['F', 'S', 'Z', 'T'],
          correct_index: 1,
          hint: 'Say it slowly: Sssssss... like a snake! What letter looks like a snake?',
          feedback_correct: 'Right! S says SSSS like a snake!',
          feedback_wrong: 'Make the sound: Sssssss... snake!',
        },
        {
          prompt: 'What letter says BUH?',
          options: ['D', 'B', 'P', 'G'],
          correct_index: 1,
          hint: 'BUH... BUH... Bear! What letter does Bear start with?',
          feedback_correct: 'Perfect! B says BUH!',
          feedback_wrong: 'BUH BUH... like Bear! Try again!',
        },
        {
          prompt: 'What letter does LION start with?',
          options: ['R', 'L', 'M', 'N'],
          correct_index: 1,
          hint: 'Say it with me: Llllll-ion. Feel your tongue touch the top of your mouth!',
          feedback_correct: 'Yes! L for LION!',
          feedback_wrong: 'Listen: Llllll-ion. What sound is that?',
        },
        {
          prompt: 'ELEPHANT starts with this letter:',
          options: ['A', 'E', 'I', 'O'],
          correct_index: 1,
          hint: 'Eh-eh-elephant. Which letter says "ehh"?',
          feedback_correct: 'Great! E for ELEPHANT!',
          feedback_wrong: 'Eh-eh-elephant. That\'s E!',
        },
        {
          prompt: 'What letter says FFF?',
          options: ['V', 'F', 'P', 'B'],
          correct_index: 1,
          hint: 'Blow air through your teeth: Fffff... like a fan!',
          feedback_correct: 'Right! F says FFF!',
          feedback_wrong: 'Make the sound: Fffff... like blowing air!',
        },
        {
          prompt: 'PENGUIN starts with this letter:',
          options: ['B', 'D', 'P', 'T'],
          correct_index: 2,
          hint: 'Pop your lips: Puh-puh-penguin!',
          feedback_correct: 'Perfect! P for PENGUIN!',
          feedback_wrong: 'Pop your lips: Puh-puh! That\'s P!',
        },
        {
          prompt: 'What letter does CROCODILE start with?',
          options: ['G', 'C', 'Q', 'K'],
          correct_index: 1,
          hint: 'Kuh-kuh-crocodile! The letter looks like an open mouth.',
          feedback_correct: 'Yes! C for CROCODILE!',
          feedback_wrong: 'Kuh-kuh-crocodile. That sound is C!',
        },
      ],
      rounds_to_win: 5,
    },
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

  // ── Games (continued) ─────────────────────────────────────────────────────
  {
    title: 'Memory Match',
    type: 'game',
    content_type: 'game_memory',
    age_ranges: ['3-7'],
    duration_minutes: 8,
    media_refs: [],
    skills_targeted: ['working memory', 'concentration', 'visual discrimination'],
    learning_objectives: [
      'Hold images in working memory across turns',
      'Practice focused attention for 5-8 minutes',
      'Build persistence through a challenge',
    ],
    parent_follow_up:
      'Play a real memory card game together. Start with 8 pairs — let them win sometimes. As they get better, add more pairs.',
    published: true,
    version: 1,
    content: {
      pairs: [
        { a: '🐱', b: 'Cat' },
        { a: '🐶', b: 'Dog' },
        { a: '🐠', b: 'Fish' },
        { a: '🦋', b: 'Butterfly' },
        { a: '🐢', b: 'Turtle' },
        { a: '🦅', b: 'Eagle' },
      ],
    },
  },
  {
    title: 'Number Hop',
    type: 'game',
    content_type: 'game_tap_match',
    age_ranges: ['3-7'],
    duration_minutes: 7,
    media_refs: [],
    skills_targeted: ['number recognition', 'counting', 'gross motor', 'number ordering'],
    learning_objectives: [
      'Recognize numerals 1-10',
      'Count forward and backward from any number',
      'Connect movement to learning',
    ],
    parent_follow_up:
      'Write numbers 1-10 on paper plates on the floor. Call a number and have them hop to it. Mix up the order. Try it backward.',
    published: true,
    version: 1,
    content: {
      rounds: [
        {
          prompt: 'Frog on 3, hops forward 2',
          options: ['4', '5', '6'],
          correct_index: 1,
          hint: 'Hold up 3 fingers. Now add 2 more. Count them all!',
          feedback_correct: 'Great! 3 + 2 = 5!',
          feedback_wrong: 'Start at 3, hop 2 more: 4, 5!',
        },
        {
          prompt: 'Frog on 7, hops back 3',
          options: ['4', '5', '6'],
          correct_index: 1,
          hint: 'Start at 7 and count backwards: 7... 6... 5...',
          feedback_correct: 'Perfect! 7 - 3 = 4!',
          feedback_wrong: 'Count backward from 7: 6, 5, 4!',
        },
        {
          prompt: 'Frog hops 1, then 1, then 1 from 2',
          options: ['4', '5', '6'],
          correct_index: 0,
          hint: 'Start at 2. Add one hop at a time: 3... 4... 5...',
          feedback_correct: 'Right! 2 + 1 + 1 + 1 = 5!',
          feedback_wrong: 'Start at 2, add 3 hops of 1 each!',
        },
        {
          prompt: 'Which number is bigger?',
          options: ['3', '8', '5'],
          correct_index: 1,
          hint: 'Think of a number line. Which number is furthest from zero?',
          feedback_correct: 'Yes! 8 is bigger!',
          feedback_wrong: 'The bigger number comes later when counting!',
        },
        {
          prompt: 'Frog needs to reach 10, on 8',
          options: ['1', '2', '3'],
          correct_index: 1,
          hint: 'Count from 8 to 10 on your fingers: 9... 10! How many fingers did you use?',
          feedback_correct: 'Perfect! 8 + 2 = 10!',
          feedback_wrong: 'Count: 8... 9... 10! That\'s 2 hops!',
        },
      ],
      rounds_to_win: 5,
    },
  },
  {
    title: 'Pattern Maker',
    type: 'game',
    content_type: 'game_sequence',
    age_ranges: ['3-7'],
    duration_minutes: 8,
    media_refs: [],
    skills_targeted: ['pattern recognition', 'logical thinking', 'pre-math reasoning', 'sequencing'],
    learning_objectives: [
      'Identify AB, ABB, and ABC patterns',
      'Extend a pattern by predicting what comes next',
      'Create an original pattern',
    ],
    parent_follow_up:
      'Make patterns with household objects — forks and spoons, colored blocks, socks. Ask them to continue it. Then let them make one for you to continue.',
    published: true,
    version: 1,
    content: {
      rounds: [
        {
          prompt: 'Red, blue, red, blue, ?',
          sequence: ['Red', 'Blue', 'Red', 'Blue', '?'],
          options: ['Red', 'Blue', 'Yellow'],
          correct_index: 0,
          hint: 'The colors take turns! Red\'s turn, blue\'s turn, red\'s turn... whose turn is it?',
          feedback_correct: 'Perfect! Red\'s turn!',
          feedback_wrong: 'Red and blue take turns! What comes next?',
        },
        {
          prompt: 'Star, moon, star, moon, ?',
          sequence: ['⭐', '🌙', '⭐', '🌙', '?'],
          options: ['⭐', '🌙', '☀️'],
          correct_index: 0,
          hint: 'Look at the first two. They keep repeating!',
          feedback_correct: 'Yes! The star comes next!',
          feedback_wrong: 'Star and moon alternate — what comes next?',
        },
        {
          prompt: 'Dog, dog, cat, dog, dog, ?',
          sequence: ['Dog', 'Dog', 'Cat', 'Dog', 'Dog', '?'],
          options: ['Cat', 'Dog', 'Mouse'],
          correct_index: 0,
          hint: 'Two dogs then one cat. Two dogs then one...',
          feedback_correct: 'Great! Cat comes next!',
          feedback_wrong: 'Two dogs, then cat, then two dogs, then cat!',
        },
        {
          prompt: 'Triangle, square, triangle, ?',
          sequence: ['△', '□', '△', '?'],
          options: ['□', '△', '○'],
          correct_index: 0,
          hint: 'They go back and forth. Triangle, square, triangle...',
          feedback_correct: 'Perfect! Square!',
          feedback_wrong: 'Triangle and square take turns!',
        },
        {
          prompt: '1, 1, 2, 1, 1, ?',
          sequence: ['1', '1', '2', '1', '1', '?'],
          options: ['2', '1', '3'],
          correct_index: 0,
          hint: 'Look at the pattern: 1-1-2, 1-1-?',
          feedback_correct: 'Yes! 2 comes next!',
          feedback_wrong: 'The pattern repeats: 1-1-2, 1-1-2!',
        },
        {
          prompt: 'Apple, banana, orange, apple, banana, ?',
          sequence: ['🍎', '🍌', '🍊', '🍎', '🍌', '?'],
          options: ['🍊', '🍌', '🍎'],
          correct_index: 0,
          hint: 'Three fruits repeating! Apple, banana, then...',
          feedback_correct: 'Perfect! Orange!',
          feedback_wrong: 'Three fruits in order: apple, banana, orange!',
        },
      ],
      rounds_to_win: 5,
    },
  },
  {
    title: 'Word Builder',
    type: 'game',
    content_type: 'game_tap_match',
    age_ranges: ['7-12'],
    duration_minutes: 8,
    media_refs: [],
    skills_targeted: ['morphology', 'prefixes', 'suffixes', 'vocabulary', 'reading_comprehension'],
    learning_objectives: [
      'Identify and understand word prefixes (un-, re-, pre-)',
      'Identify and understand word suffixes (-er, -less, -able)',
      'Build new words by combining roots with affixes',
    ],
    parent_follow_up:
      'Play word building games at home. Start with a root word like "play" and add prefixes/suffixes: replay, replayed, player, playful, unplayable.',
    published: true,
    version: 1,
    content: {
      rounds: [
        {
          prompt: 'Adding UN- means:',
          options: ['Do it again', 'Not', 'Before', 'With'],
          correct_index: 1,
          hint: 'Think: UN-happy, UN-lock, UN-done. What do these all have in common?',
          feedback_correct: 'Right! UN- means NOT!',
          feedback_wrong: 'UN-happy is not happy. UN- means NOT!',
        },
        {
          prompt: 'Which word means "not possible"?',
          options: ['Possible', 'Reposible', 'Impossible', 'Preposible'],
          correct_index: 2,
          hint: 'The prefix that means "not" goes at the front. Which one sounds right?',
          feedback_correct: 'Yes! Impossible!',
          feedback_wrong: 'Use the prefix that means "not"!',
        },
        {
          prompt: '-ER at the end means:',
          options: ['Not', 'Before', 'A person who does something', 'Again'],
          correct_index: 2,
          hint: 'A teach-ER teaches. A sing-ER sings. A climb-ER...',
          feedback_correct: 'Perfect! -ER means a person who does it!',
          feedback_wrong: 'A teacher is a person who teaches!',
        },
        {
          prompt: 'What does PREVIEW mean?',
          options: ['View it again', 'View it after', 'View it before', 'View it wrong'],
          correct_index: 2,
          hint: 'PRE means before. Like pre-heat means heat before cooking.',
          feedback_correct: 'Right! Preview means see before!',
          feedback_wrong: 'PRE- means before. Preview is seeing before!',
        },
        {
          prompt: 'Which word means "heat it again"?',
          options: ['Preheat', 'Unheat', 'Reheat', 'Lessreheat'],
          correct_index: 2,
          hint: 'RE means again. Re-play means play again. Re-heat means...',
          feedback_correct: 'Yes! Reheat!',
          feedback_wrong: 'RE- means again. Reheat means heat again!',
        },
        {
          prompt: 'What does CARELESS mean?',
          options: ['Full of care', 'Before care', 'Without care', 'Care again'],
          correct_index: 2,
          hint: '-LESS means without. Homeless means without a home. Careless means...',
          feedback_correct: 'Perfect! Careless means without care!',
          feedback_wrong: '-LESS means without. Careless is without care!',
        },
        {
          prompt: 'Which word means "able to be washed"?',
          options: ['Unwashed', 'Washable', 'Piewashed', 'Washless'],
          correct_index: 1,
          hint: '-ABLE means it CAN be done. Readable means it can be read.',
          feedback_correct: 'Yes! Washable!',
          feedback_wrong: '-ABLE means it can be done. Washable means can be washed!',
        },
      ],
      rounds_to_win: 5,
    },
  },

  // ── Music (continued) ──────────────────────────────────────────────────────
  {
    title: 'Move Like an Animal',
    type: 'music',
    age_ranges: ['3-7'],
    duration_minutes: 5,
    media_refs: [],
    skills_targeted: ['gross motor', 'imagination', 'body awareness', 'following directions'],
    learning_objectives: [
      'Move creatively in response to music',
      'Name and imitate 8 animals',
      'Listen and respond to verbal cues',
    ],
    parent_follow_up:
      'Name an animal and move like it together. Bear crawl, frog hop, penguin waddle. See who can do the silliest animal walk.',
    published: true,
    version: 1,
  },
  {
    title: 'Rhythm Hands',
    type: 'music',
    age_ranges: ['3-7'],
    duration_minutes: 5,
    media_refs: [],
    skills_targeted: ['rhythm', 'beat awareness', 'fine motor', 'coordination', 'listening'],
    learning_objectives: [
      'Keep a steady beat with clapping and tapping',
      'Distinguish fast from slow rhythm',
      'Echo simple clapping patterns',
    ],
    parent_follow_up:
      'Clap a short pattern (clap clap pause clap) and have them echo it back. Start simple, get complex. Try it with spoons on bowls.',
    published: true,
    version: 1,
  },
];

function toSlug(title: string): string {
  return title
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-|-$/g, '');
}

async function deleteCollection(collectionPath: string): Promise<void> {
  const snapshot = await db.collection(collectionPath).get();
  if (snapshot.empty) return;
  const batch = db.batch();
  snapshot.docs.forEach((doc) => batch.delete(doc.ref));
  await batch.commit();
}

async function seedContent() {
  console.log('Clearing existing content collections...');
  await deleteCollection('parent_guides');
  await deleteCollection('child_activities');
  console.log('✓ Cleared existing content');

  console.log('Seeding Firestore content library...');

  // Seed parent guides — deterministic IDs based on title slug
  const guideBatch = db.batch();
  for (const guide of parentGuides) {
    const id = `guide-${toSlug(guide.title)}`;
    const ref = db.collection('parent_guides').doc(id);
    guideBatch.set(ref, guide);
  }
  await guideBatch.commit();
  console.log(`✓ Seeded ${parentGuides.length} parent guides`);

  // Seed child activities — deterministic IDs based on title slug
  const activityBatch = db.batch();
  for (const activity of childActivities) {
    const id = `activity-${toSlug(activity.title)}`;
    const ref = db.collection('child_activities').doc(id);
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
