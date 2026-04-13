#!/usr/bin/env node

const admin = require('firebase-admin');

// Initialize Firebase using application default credentials (from firebase CLI login)
admin.initializeApp({
  projectId: 'seedling-5a9f6',
});

const db = admin.firestore();

const updates = {
  'activity-big-world-little-hands': {
    contentType: 'story_pages',
    content: {
      pages: [
        {
          text: 'Once upon a time, Sparks woke up in a BIG house.',
          character: 'sparks',
          emotion: 'happy',
        },
        {
          text: 'The stairs looked so tall! But Sparks was excited to explore.',
          character: 'sparks',
          emotion: 'excited',
        },
        {
          text: 'Then Sparks found a tiny mouse! It was so small compared to Sparks.',
          character: 'sparks',
          emotion: 'surprised',
        },
        {
          text: 'The mouse showed Sparks a big cheese. "This is BIG for me!" said the mouse.',
          character: 'sparks',
          emotion: 'happy',
        },
        {
          text: 'Sparks learned that big and small are just different ways to look at the world.',
          character: 'sparks',
          emotion: 'proud',
        },
        {
          text: 'Everything has its own size, and that makes the world interesting!',
          character: 'sparks',
          emotion: 'happy',
        },
      ],
    },
  },
  'activity-clover-counts-the-steps': {
    contentType: 'story_pages',
    content: {
      pages: [
        {
          text: 'Clover loved patterns and routines. Today was a BIG day!',
          character: 'clover',
          emotion: 'excited',
        },
        {
          text: '"I need to climb the stairs," said Clover. "One... two... three..."',
          character: 'clover',
          emotion: 'happy',
        },
        {
          text: 'Step by step, Clover counted each one. The pattern was soothing.',
          character: 'clover',
          emotion: 'calm',
        },
        {
          text: 'Sometimes the steps felt hard, but Clover kept counting: "Four... five... six..."',
          character: 'clover',
          emotion: 'frustrated',
        },
        {
          text: 'Almost there! "Seven... eight... nine... TEN!"',
          character: 'clover',
          emotion: 'excited',
        },
        {
          text: 'Clover made it to the top! The pattern was complete, and Clover felt proud.',
          character: 'clover',
          emotion: 'proud',
        },
      ],
    },
  },
  'activity-clover-s-morning': {
    contentType: 'story_pages',
    content: {
      pages: [
        {
          text: 'Every morning, Clover follows the same routine. First: wake up!',
          character: 'clover',
          emotion: 'happy',
        },
        {
          text: 'Second: eat a yummy breakfast. Clover likes knowing what comes next.',
          character: 'clover',
          emotion: 'calm',
        },
        {
          text: 'Third: wash up and brush fur. Clover feels so clean and fresh!',
          character: 'clover',
          emotion: 'happy',
        },
        {
          text: 'Fourth: put on clothes. Clover picks the same favorite outfit.',
          character: 'clover',
          emotion: 'calm',
        },
        {
          text: 'Fifth: look in the mirror and smile. Clover is ready for the day!',
          character: 'clover',
          emotion: 'excited',
        },
        {
          text: 'Clover loves routines because they feel safe. Every day follows a pattern.',
          character: 'clover',
          emotion: 'proud',
        },
      ],
    },
  },
  'activity-sparks-and-the-end-of-park-time': {
    contentType: 'story_pages',
    content: {
      pages: [
        {
          text: 'Sparks was having SO much fun at the park! The day was perfect!',
          character: 'sparks',
          emotion: 'excited',
        },
        {
          text: 'But then... it was time to leave. Sparks felt a BIG feeling growing inside.',
          character: 'sparks',
          emotion: 'worried',
        },
        {
          text: '"I don\'t want to go!" Sparks felt frustrated and upset.',
          character: 'sparks',
          emotion: 'frustrated',
        },
        {
          text: 'Mom said: "I know you\'re sad. Big feelings are okay. Let\'s talk about it."',
          character: 'sparks',
          emotion: 'sad',
        },
        {
          text: 'Sparks took deep breaths. The big feeling got a little smaller.',
          character: 'sparks',
          emotion: 'happy',
        },
        {
          text: 'Sparks learned: it\'s okay to feel sad sometimes. Feelings come and go.',
          character: 'sparks',
          emotion: 'proud',
        },
      ],
    },
  },
  'activity-the-same-blue-truck': {
    contentType: 'story_pages',
    content: {
      pages: [
        {
          text: 'Every day, Clover saw the same blue truck drive by. Clover loved patterns!',
          character: 'clover',
          emotion: 'happy',
        },
        {
          text: '"There it is! The blue truck! Same as always!" Clover wagged with joy.',
          character: 'clover',
          emotion: 'excited',
        },
        {
          text: 'One day, the blue truck didn\'t come. Clover felt worried.',
          character: 'clover',
          emotion: 'worried',
        },
        {
          text: 'But then... there it was! A little later than usual, but still there!',
          character: 'clover',
          emotion: 'surprised',
        },
        {
          text: 'Clover realized that patterns sometimes change a little, and that\'s okay!',
          character: 'clover',
          emotion: 'calm',
        },
        {
          text: 'The blue truck always comes, even if it\'s at a different time. Clover felt safe.',
          character: 'clover',
          emotion: 'proud',
        },
      ],
    },
  },
  'activity-zee-finds-all-the-colors': {
    contentType: 'story_pages',
    content: {
      pages: [
        {
          text: 'Zee the curious octopus was exploring the reef. "What colors are there?"',
          character: 'zee',
          emotion: 'curious',
        },
        {
          text: 'First, Zee found something RED! A beautiful red coral. "How pretty!"',
          character: 'zee',
          emotion: 'excited',
        },
        {
          text: 'Next, a bright YELLOW fish swam by. Zee reached out with tentacles.',
          character: 'zee',
          emotion: 'curious',
        },
        {
          text: 'Then Zee found BLUE rocks and GREEN plants everywhere! So many colors!',
          character: 'zee',
          emotion: 'surprised',
        },
        {
          text: 'Zee also found ORANGE, PURPLE, and so many more! The world was colorful!',
          character: 'zee',
          emotion: 'excited',
        },
        {
          text: 'Zee learned that colors are all around us. Finding them is an adventure!',
          character: 'zee',
          emotion: 'proud',
        },
      ],
    },
  },
  'activity-zee-tries-something-new': {
    contentType: 'story_pages',
    content: {
      pages: [
        {
          text: 'Zee found something new floating in the water. "What is this?" Zee was curious!',
          character: 'zee',
          emotion: 'curious',
        },
        {
          text: 'It was a seaweed snack! Zee had never tried seaweed before.',
          character: 'zee',
          emotion: 'surprised',
        },
        {
          text: '"It\'s different..." Zee felt a little nervous. "What if I don\'t like it?"',
          character: 'zee',
          emotion: 'worried',
        },
        {
          text: 'But Zee was brave! "I can try new things!" Zee tasted the seaweed.',
          character: 'zee',
          emotion: 'excited',
        },
        {
          text: '"Mmm! It\'s crunchy! It\'s yummy! I like trying new things!" Zee was so happy!',
          character: 'zee',
          emotion: 'happy',
        },
        {
          text: 'Zee learned: being brave enough to try something new can lead to wonderful surprises!',
          character: 'zee',
          emotion: 'proud',
        },
      ],
    },
  },
  'activity-sparks-and-the-scary-storm': {
    title: 'Sparks and the Scary Storm',
    type: 'story',
    age_ranges: ['3-7'],
    duration_minutes: 5,
    media_refs: [],
    skills_targeted: ['emotional_regulation', 'fear_management', 'resilience'],
    learning_objectives: [
      'Big feelings like anger and fear are normal',
      'Storms pass, and so do big feelings',
      'You can start again after something goes wrong',
    ],
    parent_follow_up: 'Ask: "Have you ever felt scared and angry at the same time? What does that feel like in your body?"',
    published: true,
    version: 1,
    contentType: 'story_pages',
    content: {
      pages: [
        {
          text: 'Sparks was building the BEST sandcastle ever! Tall towers, a moat, everything!',
          character: 'sparks',
          emotion: 'excited',
        },
        {
          text: 'Dark clouds rolled in. The wind blew harder. "What\'s happening to the sky?"',
          character: 'sparks',
          emotion: 'worried',
        },
        {
          text: 'BOOM! Thunder crashed so loud the ground shook! Sparks hid behind the sandcastle.',
          character: 'sparks',
          emotion: 'scared',
        },
        {
          text: 'The rain washed the sandcastle away. "NO! That\'s not fair!" Sparks stomped and growled.',
          character: 'sparks',
          emotion: 'angry',
        },
        {
          text: 'Mom sat with Sparks and listened to the rain. "Storms pass. So do big feelings."',
          character: 'sparks',
          emotion: 'happy',
        },
        {
          text: 'When the sun came back, Sparks built a NEW sandcastle. Even better than before!',
          character: 'sparks',
          emotion: 'proud',
        },
      ],
    },
  },
  'activity-clover-s-rainy-day': {
    title: "Clover's Rainy Day",
    type: 'story',
    age_ranges: ['3-7'],
    duration_minutes: 5,
    media_refs: [],
    skills_targeted: ['flexibility', 'emotional_regulation', 'routine_adaptation'],
    learning_objectives: [
      'Plans can change and that is okay',
      'Feeling sad, angry, and scared about change is normal',
      'You can make a new plan when the old one breaks',
    ],
    parent_follow_up: 'Ask: "Has something you planned ever gotten changed? What did you do? Could we make a new plan together?"',
    published: true,
    version: 1,
    contentType: 'story_pages',
    content: {
      pages: [
        {
          text: 'Today was PARK DAY! Clover packed a bag and waited by the door. "Let\'s go!"',
          character: 'clover',
          emotion: 'excited',
        },
        {
          text: 'But it was raining. A lot. No park today. Clover\'s tail drooped.',
          character: 'clover',
          emotion: 'sad',
        },
        {
          text: '"It\'s not FAIR!" Clover barked. "The plan was the PARK! Rain ruined everything!"',
          character: 'clover',
          emotion: 'angry',
        },
        {
          text: 'A big BOOM of thunder shook the windows. Clover dove under the blanket.',
          character: 'clover',
          emotion: 'scared',
        },
        {
          text: 'Clover took a deep breath. "Maybe I can make a new plan for inside."',
          character: 'clover',
          emotion: 'calm',
        },
        {
          text: 'Clover built a blanket fort and read stories all day. New plans can be great plans!',
          character: 'clover',
          emotion: 'proud',
        },
      ],
    },
  },
  'activity-zee-learns-to-ask-for-help': {
    title: 'Zee Learns to Ask for Help',
    type: 'story',
    age_ranges: ['3-7'],
    duration_minutes: 5,
    media_refs: [],
    skills_targeted: ['help_seeking', 'emotional_regulation', 'asl_help', 'asl_thank_you', 'asl_please'],
    learning_objectives: [
      'Asking for help is brave, not weak',
      'Practice the ASL sign for HELP and THANK YOU',
      'Frustration and sadness are signals that you might need help',
    ],
    parent_follow_up: 'Practice the HELP sign together. Ask: "When is a time you needed help? Who did you ask?"',
    published: true,
    version: 1,
    contentType: 'story_pages',
    content: {
      pages: [
        {
          text: 'Zee spotted something shiny deep inside a coral hole. "Ooh, what IS that?"',
          character: 'zee',
          emotion: 'curious',
        },
        {
          text: 'Zee pulled and squeezed with all eight tentacles. It wouldn\'t budge!',
          character: 'zee',
          emotion: 'frustrated',
        },
        {
          text: '"I can\'t do it..." Zee\'s tentacles drooped. Maybe it was impossible.',
          character: 'zee',
          emotion: 'sad',
        },
        {
          text: 'Wait! Zee remembered a special sign \u2014 HELP! Zee signed to a passing fish. "Please?"',
          character: 'zee',
          emotion: 'asl/help',
        },
        {
          text: 'The fish wiggled it free \u2014 a beautiful pearl! "Thank you!" Zee signed back.',
          character: 'zee',
          emotion: 'asl/thank you',
        },
        {
          text: 'Zee learned something important: asking for help isn\'t giving up. It\'s being brave!',
          character: 'zee',
          emotion: 'proud',
        },
      ],
    },
  },
  'activity-zee-gets-lost': {
    title: 'Zee Gets Lost',
    type: 'story',
    age_ranges: ['3-7'],
    duration_minutes: 5,
    media_refs: [],
    skills_targeted: ['fear_management', 'help_seeking', 'asl_please', 'asl_i_love_you'],
    learning_objectives: [
      'Being lost or scared can make you feel angry',
      'Practice the ASL sign for PLEASE and I LOVE YOU',
      'You are never really alone when you know how to ask',
    ],
    parent_follow_up: 'Practice the I LOVE YOU sign together. Ask: "If you ever felt lost, what would you do first?"',
    published: true,
    version: 1,
    contentType: 'story_pages',
    content: {
      pages: [
        {
          text: 'Zee swam faster and faster, exploring a new part of the reef. So many new things!',
          character: 'zee',
          emotion: 'excited',
        },
        {
          text: 'But wait... nothing looked familiar. Which way was home? Zee\'s tentacles curled up tight.',
          character: 'zee',
          emotion: 'scared',
        },
        {
          text: '"This is the WORST!" Zee was mad \u2014 mad at the reef, mad at being lost, mad at everything.',
          character: 'zee',
          emotion: 'angry',
        },
        {
          text: 'Zee saw a wise old turtle. Zee signed PLEASE with a tentacle. "Can you help me find home?"',
          character: 'zee',
          emotion: 'asl/please',
        },
        {
          text: 'The turtle led Zee all the way back! Mama was waiting. Zee signed I LOVE YOU with all eight tentacles.',
          character: 'zee',
          emotion: 'asl/i love you',
        },
        {
          text: 'Zee learned: even when things are scary, you are never really alone. Just ask.',
          character: 'zee',
          emotion: 'proud',
        },
      ],
    },
  },
};

async function updateActivities() {
  console.log('🚀 Starting migration of story activities with character data...\n');

  try {
    let count = 0;
    for (const [activityId, data] of Object.entries(updates)) {
      await db.collection('child_activities').doc(activityId).set(data, { merge: true });
      count++;
      console.log(`✅ Updated (${count}/11): ${activityId}`);
    }

    console.log(`\n🎉 Success! All ${count} story activities updated.\n`);
    console.log('Characters now appear in:');
    console.log('  • Sparks: emotional dinosaur (yellow)');
    console.log('  • Clover: routine-loving dog (dusty rose)');
    console.log('  • Zee: curious octopus (teal)');
  } catch (error) {
    console.error('❌ Error during migration:', error.message);
    process.exit(1);
  } finally {
    process.exit(0);
  }
}

updateActivities();
