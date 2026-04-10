const admin = require('firebase-admin');
const serviceAccount = require('../firebase-key.json'); // You'll need to add this

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://seedling-7f4a8.firebaseio.com',
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
          emotion: 'happy',
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
          emotion: 'happy',
        },
        {
          text: '"I need to climb the stairs," said Clover. "One... two... three..."',
          character: 'clover',
          emotion: 'happy',
        },
        {
          text: 'Step by step, Clover counted each one. The pattern was soothing.',
          character: 'clover',
          emotion: 'happy',
        },
        {
          text: 'Sometimes the steps felt hard, but Clover kept counting: "Four... five... six..."',
          character: 'clover',
          emotion: 'frustrated',
        },
        {
          text: 'Almost there! "Seven... eight... nine... TEN!"',
          character: 'clover',
          emotion: 'happy',
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
          emotion: 'happy',
        },
        {
          text: 'Third: wash up and brush fur. Clover feels so clean and fresh!',
          character: 'clover',
          emotion: 'happy',
        },
        {
          text: 'Fourth: put on clothes. Clover picks the same favorite outfit.',
          character: 'clover',
          emotion: 'happy',
        },
        {
          text: 'Fifth: look in the mirror and smile. Clover is ready for the day!',
          character: 'clover',
          emotion: 'happy',
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
          emotion: 'happy',
        },
        {
          text: 'But then... it was time to leave. Sparks felt a BIG feeling growing inside.',
          character: 'sparks',
          emotion: 'sad',
        },
        {
          text: '"I don\'t want to go!" Sparks felt frustrated and upset.',
          character: 'sparks',
          emotion: 'angry',
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
          emotion: 'happy',
        },
        {
          text: 'One day, the blue truck didn\'t come. Clover felt worried.',
          character: 'clover',
          emotion: 'scared',
        },
        {
          text: 'But then... there it was! A little later than usual, but still there!',
          character: 'clover',
          emotion: 'happy',
        },
        {
          text: 'Clover realized that patterns sometimes change a little, and that\'s okay!',
          character: 'clover',
          emotion: 'happy',
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
          emotion: 'happy',
        },
        {
          text: 'First, Zee found something RED! A beautiful red coral. "How pretty!"',
          character: 'zee',
          emotion: 'happy',
        },
        {
          text: 'Next, a bright YELLOW fish swam by. Zee reached out with tentacles.',
          character: 'zee',
          emotion: 'happy',
        },
        {
          text: 'Then Zee found BLUE rocks and GREEN plants everywhere! So many colors!',
          character: 'zee',
          emotion: 'surprised',
        },
        {
          text: 'Zee also found ORANGE, PURPLE, and so many more! The world was colorful!',
          character: 'zee',
          emotion: 'happy',
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
          emotion: 'happy',
        },
        {
          text: 'It was a seaweed snack! Zee had never tried seaweed before.',
          character: 'zee',
          emotion: 'surprised',
        },
        {
          text: '"It\'s different..." Zee felt a little nervous. "What if I don\'t like it?"',
          character: 'zee',
          emotion: 'scared',
        },
        {
          text: 'But Zee was brave! "I can try new things!" Zee tasted the seaweed.',
          character: 'zee',
          emotion: 'happy',
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
};

async function updateActivities() {
  try {
    const batch = db.batch();

    for (const [activityId, data] of Object.entries(updates)) {
      const ref = db.collection('child_activities').doc(activityId);
      batch.update(ref, data);
    }

    await batch.commit();
    console.log('✅ Successfully updated all story activities with character data!');
  } catch (error) {
    console.error('❌ Error updating activities:', error);
  } finally {
    process.exit(0);
  }
}

updateActivities();
