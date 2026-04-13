# Story Emotion Enrichment Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace generic "happy" emotion defaults with narrative-accurate emotions across all 7 seeded stories, so character art actually reflects what's happening in each scene.

**Architecture:** Update the three story migration scripts (JS, JS-CLI, Dart) with enriched emotion mappings, then run the CLI migration to push to Firestore. No Flutter code changes needed - the widget already reads and renders per-page emotions correctly.

**Tech Stack:** Node.js (Firebase Admin SDK), Dart (Firestore), Firebase CLI auth

---

## Emotion Audit

### Available Assets

| Character | Available Emotions |
|---|---|
| **Sparks** | angry, excited, frustrated, happy, proud, sad, scared, surprised, worried |
| **Clover** | angry, calm, excited, frustrated, happy, proud, sad, scared, surprised, worried |
| **Zee** | angry, curious, excited, frustrated, happy, proud, sad, scared, surprised, worried |
| **Zee ASL** | help, i love you, more, please, thank you |

### Current vs. Proposed Emotions (20 changes across 42 pages)

**activity-big-world-little-hands (Sparks) - 1 change:**

| Page | Text | Current | Proposed | Reasoning |
|---|---|---|---|---|
| 0 | "Sparks woke up in a BIG house." | happy | happy | - |
| 1 | "Sparks was excited to explore." | happy | **excited** | Text literally says "excited" |
| 2 | "Sparks found a tiny mouse!" | surprised | surprised | - |
| 3 | '"This is BIG for me!" said the mouse.' | happy | happy | - |
| 4 | "big and small are just different ways..." | proud | proud | - |
| 5 | "that makes the world interesting!" | happy | happy | - |

**activity-clover-counts-the-steps (Clover) - 3 changes:**

| Page | Text | Current | Proposed | Reasoning |
|---|---|---|---|---|
| 0 | "Today was a BIG day!" | happy | **excited** | Anticipation energy |
| 1 | '"One... two... three..."' | happy | happy | - |
| 2 | "The pattern was soothing." | happy | **calm** | Text says "soothing" - Clover's signature |
| 3 | "the steps felt hard..." | frustrated | frustrated | - |
| 4 | '"Seven... eight... nine... TEN!"' | happy | **excited** | Counting climax, not resting happy |
| 5 | "Clover felt proud." | proud | proud | - |

**activity-clover-s-morning (Clover) - 3 changes:**

| Page | Text | Current | Proposed | Reasoning |
|---|---|---|---|---|
| 0 | "First: wake up!" | happy | happy | - |
| 1 | "Clover likes knowing what comes next." | happy | **calm** | Routine contentment, not excitement |
| 2 | "Clover feels so clean and fresh!" | happy | happy | - |
| 3 | "picks the same favorite outfit." | happy | **calm** | Quiet comfort of familiar patterns |
| 4 | "Clover is ready for the day!" | happy | **excited** | End-of-routine energy boost |
| 5 | "routines feel safe." | proud | proud | - |

**activity-sparks-and-the-end-of-park-time (Sparks) - 3 changes:**

| Page | Text | Current | Proposed | Reasoning |
|---|---|---|---|---|
| 0 | "SO much fun at the park!" | happy | **excited** | "SO much fun" is excited energy |
| 1 | "BIG feeling growing inside." | sad | **worried** | Anticipatory dread, not sadness yet |
| 2 | "felt frustrated and upset." | angry | **frustrated** | Text says "frustrated" - anger comes later conceptually, but the image is too intense for this moment |
| 3 | '"I know you\'re sad."' | sad | sad | - |
| 4 | "big feeling got a little smaller." | happy | happy | - |
| 5 | "Feelings come and go." | proud | proud | - |

**activity-the-same-blue-truck (Clover) - 4 changes:**

| Page | Text | Current | Proposed | Reasoning |
|---|---|---|---|---|
| 0 | "Clover loved patterns!" | happy | happy | - |
| 1 | "Clover wagged with joy." | happy | **excited** | Wagging = active joy |
| 2 | "Clover felt worried." | scared | **worried** | Text literally says "worried", not scared |
| 3 | "there it was! A little later..." | happy | **surprised** | Relief + surprise moment |
| 4 | "that's okay!" | happy | **calm** | Acceptance/settling down |
| 5 | "Clover felt safe." | proud | proud | - |

**activity-zee-finds-all-the-colors (Zee) - 4 changes:**

| Page | Text | Current | Proposed | Reasoning |
|---|---|---|---|---|
| 0 | '"What colors are there?"' | happy | **curious** | Zee's signature emotion, text describes curiosity |
| 1 | '"How pretty!"' | happy | **excited** | Discovery delight |
| 2 | "Zee reached out with tentacles." | happy | **curious** | Investigating, reaching out |
| 3 | "So many colors!" | surprised | surprised | - |
| 4 | "so many more! The world was colorful!" | happy | **excited** | Peak discovery energy |
| 5 | "Finding them is an adventure!" | proud | proud | - |

**activity-zee-tries-something-new (Zee) - 3 changes:**

| Page | Text | Current | Proposed | Reasoning |
|---|---|---|---|---|
| 0 | '"What is this?" Zee was curious!' | happy | **curious** | Text literally says "curious" |
| 1 | "Zee had never tried seaweed before." | surprised | surprised | - |
| 2 | '"What if I don\'t like it?"' | scared | **worried** | "a little nervous" - milder than scared |
| 3 | '"I can try new things!"' | happy | **excited** | Brave energy, overcoming fear |
| 4 | '"I like trying new things!" so happy!' | happy | happy | - |
| 5 | "brave enough to try something new..." | proud | proud | - |

### Post-Enrichment Coverage

| Character | Emotions Used | Still Unused |
|---|---|---|
| **Sparks** | excited, frustrated, happy, proud, sad, surprised, worried (7/9) | angry, scared |
| **Clover** | calm, excited, frustrated, happy, proud, surprised, worried (7/10) | angry, sad, scared |
| **Zee** | curious, excited, happy, proud, surprised, worried (6/10) | angry, frustrated, sad, scared |
| **Zee ASL** | 0/5 | all (need dedicated ASL stories) |

Unused emotions are situationally intense (angry, scared, sad) - they belong in stories written for those arcs, not shoehorned into existing happy ones.

---

## Task 1: Update CLI Migration Script

**Files:**
- Modify: `scripts/update_story_characters_cli.js`

- [ ] **Step 1: Update Big World Little Hands emotions**

In `scripts/update_story_characters_cli.js`, change page 1 of `activity-big-world-little-hands`:

```js
// Line ~25 — page 1
{
  text: 'The stairs looked so tall! But Sparks was excited to explore.',
  character: 'sparks',
  emotion: 'excited',  // was: 'happy'
},
```

- [ ] **Step 2: Update Clover Counts the Steps emotions**

Change pages 0, 2, 4 of `activity-clover-counts-the-steps`:

```js
// Page 0
{
  text: 'Clover loved patterns and routines. Today was a BIG day!',
  character: 'clover',
  emotion: 'excited',  // was: 'happy'
},
// Page 2
{
  text: 'Step by step, Clover counted each one. The pattern was soothing.',
  character: 'clover',
  emotion: 'calm',  // was: 'happy'
},
// Page 4
{
  text: 'Almost there! "Seven... eight... nine... TEN!"',
  character: 'clover',
  emotion: 'excited',  // was: 'happy'
},
```

- [ ] **Step 3: Update Clover's Morning emotions**

Change pages 1, 3, 4 of `activity-clover-s-morning`:

```js
// Page 1
{
  text: 'Second: eat a yummy breakfast. Clover likes knowing what comes next.',
  character: 'clover',
  emotion: 'calm',  // was: 'happy'
},
// Page 3
{
  text: 'Fourth: put on clothes. Clover picks the same favorite outfit.',
  character: 'clover',
  emotion: 'calm',  // was: 'happy'
},
// Page 4
{
  text: 'Fifth: look in the mirror and smile. Clover is ready for the day!',
  character: 'clover',
  emotion: 'excited',  // was: 'happy'
},
```

- [ ] **Step 4: Update Sparks and the End of Park Time emotions**

Change pages 0, 1, 2 of `activity-sparks-and-the-end-of-park-time`:

```js
// Page 0
{
  text: 'Sparks was having SO much fun at the park! The day was perfect!',
  character: 'sparks',
  emotion: 'excited',  // was: 'happy'
},
// Page 1
{
  text: 'But then... it was time to leave. Sparks felt a BIG feeling growing inside.',
  character: 'sparks',
  emotion: 'worried',  // was: 'sad' — anticipatory dread, not sadness yet
},
// Page 2
{
  text: '"I don\'t want to go!" Sparks felt frustrated and upset.',
  character: 'sparks',
  emotion: 'frustrated',  // was: 'angry' — text says frustrated
},
```

- [ ] **Step 5: Update The Same Blue Truck emotions**

Change pages 1, 2, 3, 4 of `activity-the-same-blue-truck`:

```js
// Page 1
{
  text: '"There it is! The blue truck! Same as always!" Clover wagged with joy.',
  character: 'clover',
  emotion: 'excited',  // was: 'happy'
},
// Page 2
{
  text: 'One day, the blue truck didn\'t come. Clover felt worried.',
  character: 'clover',
  emotion: 'worried',  // was: 'scared' — text says worried
},
// Page 3
{
  text: 'But then... there it was! A little later than usual, but still there!',
  character: 'clover',
  emotion: 'surprised',  // was: 'happy' — relief + surprise
},
// Page 4
{
  text: 'Clover realized that patterns sometimes change a little, and that\'s okay!',
  character: 'clover',
  emotion: 'calm',  // was: 'happy' — acceptance
},
```

- [ ] **Step 6: Update Zee Finds All the Colors emotions**

Change pages 0, 1, 2, 4 of `activity-zee-finds-all-the-colors`:

```js
// Page 0
{
  text: 'Zee the curious octopus was exploring the reef. "What colors are there?"',
  character: 'zee',
  emotion: 'curious',  // was: 'happy' — Zee's signature emotion
},
// Page 1
{
  text: 'First, Zee found something RED! A beautiful red coral. "How pretty!"',
  character: 'zee',
  emotion: 'excited',  // was: 'happy'
},
// Page 2
{
  text: 'Next, a bright YELLOW fish swam by. Zee reached out with tentacles.',
  character: 'zee',
  emotion: 'curious',  // was: 'happy' — investigating
},
// Page 4
{
  text: 'Zee also found ORANGE, PURPLE, and so many more! The world was colorful!',
  character: 'zee',
  emotion: 'excited',  // was: 'happy' — peak discovery
},
```

- [ ] **Step 7: Update Zee Tries Something New emotions**

Change pages 0, 2, 3 of `activity-zee-tries-something-new`:

```js
// Page 0
{
  text: 'Zee found something new floating in the water. "What is this?" Zee was curious!',
  character: 'zee',
  emotion: 'curious',  // was: 'happy' — text says curious
},
// Page 2
{
  text: '"It\'s different..." Zee felt a little nervous. "What if I don\'t like it?"',
  character: 'zee',
  emotion: 'worried',  // was: 'scared' — "a little nervous" is milder
},
// Page 3
{
  text: 'But Zee was brave! "I can try new things!" Zee tasted the seaweed.',
  character: 'zee',
  emotion: 'excited',  // was: 'happy' — brave energy
},
```

- [ ] **Step 8: Commit**

```bash
git add scripts/update_story_characters_cli.js
git commit -m "feat: enrich story emotions — 20 pages updated from generic happy to narrative-accurate"
```

---

## Task 2: Update Legacy JS and Dart Migration Scripts

**Files:**
- Modify: `scripts/update_story_characters.js`
- Modify: `lib/scripts/migrate_story_characters.dart`

These files mirror the CLI script and should stay in sync.

- [ ] **Step 1: Update `scripts/update_story_characters.js` with identical emotion changes**

Apply the exact same 20 emotion changes from Task 1 to `scripts/update_story_characters.js`. The structure is identical — same story IDs, same page arrays, same field names. Every emotion change listed in Task 1 steps 1-7 applies here.

Key changes (summary — apply all 20):
- `activity-big-world-little-hands` page 1: `'happy'` → `'excited'`
- `activity-clover-counts-the-steps` pages 0,2,4: `'happy'` → `'excited'`, `'happy'` → `'calm'`, `'happy'` → `'excited'`
- `activity-clover-s-morning` pages 1,3,4: `'happy'` → `'calm'`, `'happy'` → `'calm'`, `'happy'` → `'excited'`
- `activity-sparks-and-the-end-of-park-time` pages 0,1,2: `'happy'` → `'excited'`, `'sad'` → `'worried'`, `'angry'` → `'frustrated'`
- `activity-the-same-blue-truck` pages 1,2,3,4: `'happy'` → `'excited'`, `'scared'` → `'worried'`, `'happy'` → `'surprised'`, `'happy'` → `'calm'`
- `activity-zee-finds-all-the-colors` pages 0,1,2,4: `'happy'` → `'curious'`, `'happy'` → `'excited'`, `'happy'` → `'curious'`, `'happy'` → `'excited'`
- `activity-zee-tries-something-new` pages 0,2,3: `'happy'` → `'curious'`, `'scared'` → `'worried'`, `'happy'` → `'excited'`

- [ ] **Step 2: Update `lib/scripts/migrate_story_characters.dart` with identical emotion changes**

Apply the exact same 20 changes to the Dart file. Same structure, single-quoted strings. Every change from the summary in Step 1 applies identically.

- [ ] **Step 3: Verify all three files match**

Run: `diff <(grep "emotion:" scripts/update_story_characters_cli.js) <(grep "emotion:" scripts/update_story_characters.js)`

Expected: No differences (identical emotion values).

Run: `diff <(grep "'emotion'" lib/scripts/migrate_story_characters.dart | sed "s/'//g") <(grep "emotion:" scripts/update_story_characters_cli.js | sed "s/'//g")`

Expected: No meaningful differences (only formatting).

- [ ] **Step 4: Commit**

```bash
git add scripts/update_story_characters.js lib/scripts/migrate_story_characters.dart
git commit -m "chore: sync emotion enrichment to legacy JS and Dart migration scripts"
```

---

## Task 3: Run Firestore Migration

**Prerequisites:** Firebase CLI authenticated (`firebase login`), project set to `seedling-5a9f6`.

- [ ] **Step 1: Verify Firebase auth**

Run: `firebase projects:list | grep seedling`

Expected: Shows `seedling-5a9f6` in the project list.

- [ ] **Step 2: Run the CLI migration**

Run: `cd /Users/mohitramchandani/Code/seedling && node scripts/update_story_characters_cli.js`

Expected output:
```
🚀 Starting migration of story activities with character data...

✅ Updated (1/7): activity-big-world-little-hands
✅ Updated (2/7): activity-clover-counts-the-steps
✅ Updated (3/7): activity-clover-s-morning
✅ Updated (4/7): activity-sparks-and-the-end-of-park-time
✅ Updated (5/7): activity-the-same-blue-truck
✅ Updated (6/7): activity-zee-finds-all-the-colors
✅ Updated (7/7): activity-zee-tries-something-new

🎉 Success! All 7 story activities updated with character data.
```

- [ ] **Step 3: Verify in Firebase Console**

Open the Firestore console, navigate to `child_activities` → `activity-the-same-blue-truck` → `content.pages[2]`. Confirm `emotion` field reads `worried` (not `scared`).

Check `activity-zee-finds-all-the-colors` → `content.pages[0]`. Confirm `emotion` reads `curious`.

---

## Task 4: On-Device Verification

- [ ] **Step 1: Run the app**

Run: `cd /Users/mohitramchandani/Code/seedling && flutter run`

- [ ] **Step 2: Test emotional arcs**

Open each story and swipe through pages. Verify the character image changes to match:

1. **Zee Finds All the Colors** — page 0 should show curious Zee (not happy). Page 1 excited. Page 2 curious again.
2. **The Same Blue Truck** — page 2 should show worried Clover (not scared). Page 3 surprised. Page 4 calm.
3. **Sparks and the End of Park Time** — page 0 excited. Page 1 worried (building tension). Page 2 frustrated.

- [ ] **Step 3: Final commit**

```bash
git add -A
git commit -m "docs: add story emotion enrichment plan"
```
