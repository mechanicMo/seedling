# Story Characters Migration Guide

This guide explains how to update Firestore with character data for the 7 story activities. The characters (Sparks, Clover, and Zee) will now appear in the stories with emotion expressions.

## Updated Stories

1. **activity-big-world-little-hands** - Sparks (emotional dinosaur)
2. **activity-clover-counts-the-steps** - Clover (routine-loving dog)
3. **activity-clover-s-morning** - Clover
4. **activity-sparks-and-the-end-of-park-time** - Sparks
5. **activity-the-same-blue-truck** - Clover
6. **activity-zee-finds-all-the-colors** - Zee (curious octopus)
7. **activity-zee-tries-something-new** - Zee

## Option 1: Dart Migration (Recommended)

If you have the Flutter/Dart development environment set up:

```bash
cd ~/Code/seedling
dart lib/scripts/migrate_story_characters.dart
```

Requirements:
- Firebase initialized in the project
- Firestore emulator running (optional) or Firestore configured in Firebase

## Option 2: Node.js Migration

If you have Node.js installed:

```bash
cd ~/Code/seedling
npm install -g firebase-admin
# Add your Firebase service account key to: scripts/firebase-key.json
node scripts/update_story_characters.js
```

## Option 3: Manual Update via Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select the Seedling project
3. Navigate to Firestore Database
4. For each activity listed above:
   - Find the document in `child_activities` collection
   - Click Edit
   - Update the `content.pages` array to include `character` and `emotion` fields
   - Example structure:
   
   ```json
   {
     "pages": [
       {
         "text": "Story text here",
         "character": "sparks",
         "emotion": "happy"
       },
       ...
     ]
   }
   ```

## Character Files Created

- `lib/features/child/widgets/characters/sparks_character.dart` - Yellow emotional dinosaur
- `lib/features/child/widgets/characters/clover_character.dart` - Dusty rose routine-loving dog
- `lib/features/child/widgets/characters/zee_character.dart` - Teal curious octopus

Each character supports emotion expressions:
- happy, sad, angry, scared, surprised, frustrated, proud

## Story Reader Updates

The `story_reader_widget.dart` now supports:
- Character illustrations on each page
- Dynamic emotion expressions based on story context
- Backward compatibility with text-only pages (old format still works)

## Testing

After migration, open the Seedling app and navigate to any story activity. You should see:
1. Character illustrations displayed on each page
2. Emotion expressions changing based on the story's emotional context
3. Page text synchronized with the character's emotion
