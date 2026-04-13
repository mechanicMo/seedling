# Game Hints - Implementation Plan

## Goal

Replace the current "highlight the answer" hint with pedagogical hints that teach kids HOW to find the answer, rather than just showing it. Hints appear in a colored box below the options when the hint button is tapped.

---

## Design

### Hint button
- Large button below the answer options (not small top-right)
- Lightbulb icon + "Need a hint?" text
- Warm amber/yellow styling, rounded, friendly
- Disabled briefly after use (2s cooldown) to prevent spam-tapping
- No limit on uses - this is learning, not testing

### Hint display
- Appears below the options in a soft amber/cream box with rounded corners
- Animated slide-in from bottom
- Stays visible until the kid answers or moves to next round
- Dismissed on correct answer

### Hint content approach
Each round in Firestore gets a new `hint` field. This keeps hints data-driven and editable without code changes.

---

## Hint content per game

### Letter Sounds Safari (tap_match)

The hints use phonetic repetition and animal associations - what a 4-year-old actually responds to.

| Prompt | Hint |
|--------|------|
| What letter says SSSS? | Say it slowly: Sssssss... like a snake! What letter looks like a snake? |
| What letter says BUH? | BUH... BUH... Bear! What letter does Bear start with? |
| What letter does LION start with? | Say it with me: Llllll-ion. Feel your tongue touch the top of your mouth! |
| ELEPHANT starts with this letter: | Eh-eh-elephant. Which letter says "ehh"? |
| What letter says FFF? | Blow air through your teeth: Fffff... like a fan! |
| PENGUIN starts with this letter: | Pop your lips: Puh-puh-penguin! |
| What letter does CROCODILE start with? | Kuh-kuh-crocodile! The letter looks like an open mouth. |

### Number Hop (tap_match)

Hints use counting-on-fingers strategy - concrete and physical.

| Prompt | Hint |
|--------|------|
| Frog on 3, hops forward 2 | Hold up 3 fingers. Now add 2 more. Count them all! |
| Frog on 7, hops back 3 | Start at 7 and count backwards: 7... 6... 5... |
| Frog hops 1, then 1, then 1 from 2 | Start at 2. Add one hop at a time: 3... 4... 5... |
| Which number is bigger? | Think of a number line. Which number is furthest from zero? |
| Frog needs to reach 10, on 8 | Count from 8 to 10 on your fingers: 9... 10! How many fingers did you use? |

### Shape Detective (tap_match)

Hints use body/real-world associations.

| Prompt | Hint |
|--------|------|
| Which shape has 3 sides? | Make a shape with 3 fingers. It looks like a mountain! |
| Which shape has NO sides? | Roll a ball - it goes round and round. What shape is that? |
| A window is usually which shape? | Look around the room. Windows have 4 sides - 2 long ones and 2 short ones. |
| How many corners does a square have? | Draw a square in the air with your finger. Count each time you turn a corner! |
| A pizza slice looks like: | Think about the pointy end you hold. It has 3 sides! |
| Which shape has 4 equal sides? | All sides the same length. Not long and short - ALL the same! |

### Word Builder (tap_match, ages 7-12)

Hints use word family examples.

| Prompt | Hint |
|--------|------|
| Adding UN- means: | Think: UN-happy, UN-lock, UN-done. What do these all have in common? |
| Which word means 'not possible'? | The prefix that means "not" goes at the front. Which one sounds right? |
| -ER at the end means: | A teach-ER teaches. A sing-ER sings. A climb-ER... |
| What does PREVIEW mean? | PRE means before. Like pre-heat means heat before cooking. |
| Which word means 'heat it again'? | RE means again. Re-play means play again. Re-heat means... |
| What does CARELESS mean? | -LESS means without. Homeless means without a home. Careless means... |
| Which word means 'able to be washed'? | -ABLE means it CAN be done. Readable means it can be read. |

### Counting Rainbow (sequence)

Hints describe the pattern in simple words.

| Prompt | Hint |
|--------|------|
| 1, 2, 3, ? | We're counting up by one! What comes after 3? |
| Red, orange, yellow, ? | Think of a rainbow! Red, orange, yellow, and then... |
| Star, star-star, star-star-star, ? | The stars are growing by one each time! |
| 5, 6, 7, ? | Keep counting! 5, 6, 7... what's next? |
| Red, red, blue, blue, ? | The pattern goes: two reds, two blues, two... |
| 2, 4, 6, ? | We're skip-counting by 2! Count on your fingers: 2, 4, 6... |

### Pattern Maker (sequence)

| Prompt | Hint |
|--------|------|
| Red, blue, red, blue, ? | The colors take turns! Red's turn, blue's turn, red's turn... whose turn is it? |
| Star, moon, star, moon, ? | Look at the first two. They keep repeating! |
| Dog, dog, cat, dog, dog, ? | Two dogs then one cat. Two dogs then one... |
| Triangle, square, triangle, ? | They go back and forth. Triangle, square, triangle... |
| 1, 1, 2, 1, 1, ? | Look at the pattern: 1-1-2, 1-1-? |
| Apple, banana, orange, apple, banana, ? | Three fruits repeating! Apple, banana, then... |

### Memory Match (memory_flip)

Memory hints work differently - briefly reveal the LOCATIONS of one unmatched pair by flashing the cards with a glow effect for 1.5 seconds. The hint text says:

> "Look carefully! Two matching cards are glowing!"

This teaches spatial memory rather than just giving the answer.

---

## Data model change

Add `hint` string field to each round in Firestore:

**Tap match / Sequence rounds:**
```json
{
  "prompt": "What letter says BUH?",
  "options": ["D", "B", "P", "G"],
  "correct_index": 1,
  "hint": "BUH... BUH... Bear! What letter does Bear start with?",
  "feedback_correct": "B says BUH - like Bear!",
  "feedback_wrong": "Try again - BUH, BUH..."
}
```

**Memory match** - no data change needed, hint is always the card-reveal behavior.

---

## Implementation tasks

### Task 1: Update Firestore seeding script
- Add `hint` field to every round in all 6 games
- Use the hint text from the tables above

### Task 2: Update TapMatchGameWidget
- Remove current `_hintIndex` highlight-the-answer logic
- Add `_showingHint` bool state
- Move hint button below options: large, amber, "Need a hint?" with lightbulb icon
- On tap: read `hint` from current round data, set `_showingHint = true`
- Show hint in animated amber box below options
- Clear hint on correct answer or round change

### Task 3: Update SequenceGameWidget
- Same pattern as tap match
- Remove `_hintIndex` logic
- Add hint box below options
- Read `hint` from round data

### Task 4: Update MemoryFlipGameWidget
- Keep the card-reveal behavior (briefly glow an unmatched pair)
- Move hint button to bottom, larger styling
- Add text hint box: "Look carefully! Two matching cards are glowing!"
- Reveal duration: 1.5s

### Task 5: Run Firestore migration with hint data

### Task 6: Test all 6 games on device
