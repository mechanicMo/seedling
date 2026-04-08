import * as admin from 'firebase-admin';

// Initialize — uses Application Default Credentials
// Run with: GOOGLE_APPLICATION_CREDENTIALS=path/to/service-account.json npx ts-node -P tsconfig.dev.json scripts/update_media_refs.ts <collection> <docId> <audioUrl>
// Or against emulator: FIRESTORE_EMULATOR_HOST=localhost:8080 npx ts-node -P tsconfig.dev.json scripts/update_media_refs.ts <collection> <docId> <audioUrl>
admin.initializeApp();
const db = admin.firestore();

async function run() {
  const args = process.argv.slice(2);

  // Validate arguments
  if (args.length < 3) {
    console.log('Usage: npx ts-node -P tsconfig.dev.json scripts/update_media_refs.ts <collection> <docId> <audioUrl>');
    console.log('');
    console.log('Examples:');
    console.log('  npx ts-node -P tsconfig.dev.json scripts/update_media_refs.ts \\');
    console.log('    child_activities \\');
    console.log('    activity-sparks-and-the-end-of-park-time \\');
    console.log('    https://pub-abc123.r2.dev/seedling-media/stories/sparks-end-of-park-time.mp3');
    console.log('');
    console.log('  npx ts-node -P tsconfig.dev.json scripts/update_media_refs.ts \\');
    console.log('    parent_guides \\');
    console.log('    guide-handling-tantrums \\');
    console.log('    https://pub-abc123.r2.dev/seedling-media/guides/handling-tantrums.mp3');
    process.exit(1);
  }

  const [collection, docId, audioUrl] = args;

  // Validate collection
  if (collection !== 'child_activities' && collection !== 'parent_guides') {
    console.error(`Error: Invalid collection "${collection}". Must be "child_activities" or "parent_guides".`);
    process.exit(1);
  }

  try {
    // Get the document
    const docRef = db.collection(collection).doc(docId);
    const docSnapshot = await docRef.get();

    if (!docSnapshot.exists) {
      console.error(`Error: Document "${collection}/${docId}" not found.`);
      process.exit(1);
    }

    // Update media_refs with the single audio URL
    await docRef.update({
      media_refs: [audioUrl],
    });

    console.log(`✓ Updated ${collection}/${docId} → media_refs: ['${audioUrl}']`);
    process.exit(0);
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : String(error);
    console.error(`Error updating document: ${errorMessage}`);
    process.exit(1);
  }
}

run();
