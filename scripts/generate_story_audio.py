#!/usr/bin/env python3
"""Generate ElevenLabs audio + timestamps for all seeded Seedling stories."""

import base64
import json
import os
import time
from pathlib import Path
from urllib.request import Request, urlopen

# Load API key from .env
env_path = Path(__file__).parent.parent / ".env"
API_KEY = None
for line in env_path.read_text().splitlines():
    if line.startswith("ELEVENLABS_API_KEY="):
        API_KEY = line.split("=", 1)[1].strip()
        break

if not API_KEY:
    raise SystemExit("ELEVENLABS_API_KEY not found in .env")

VOICE_MAP = {
    "sparks": "cgSgspJ2msm6clMCkdW9",  # Jessica
    "clover": "pFZP5JQG7iQjIQuC4Bku",  # Lily
    "zee": "FGY2WhTYpPnrIDTdsKH5",      # Laura
}

MODEL_ID = "eleven_multilingual_v2"
BASE_URL = "https://api.elevenlabs.io/v1/text-to-speech"
OUTPUT_DIR = Path(__file__).parent.parent / "assets" / "audio" / "stories"

# All 11 seeded stories — character and pages
STORIES = {
    "activity-big-world-little-hands": {
        "character": "sparks",
        "pages": [
            "Once upon a time, Sparks woke up in a BIG house.",
            "The stairs looked so tall! But Sparks was excited to explore.",
            "Then Sparks found a tiny mouse! It was so small compared to Sparks.",
            'The mouse showed Sparks a big cheese. "This is BIG for me!" said the mouse.',
            "Sparks learned that big and small are just different ways to look at the world.",
            "Everything has its own size, and that makes the world interesting!",
        ],
    },
    "activity-clover-counts-the-steps": {
        "character": "clover",
        "pages": [
            "Clover loved patterns and routines. Today was a BIG day!",
            '"I need to climb the stairs," said Clover. "One... two... three..."',
            "Step by step, Clover counted each one. The pattern was soothing.",
            'Sometimes the steps felt hard, but Clover kept counting: "Four... five... six..."',
            'Almost there! "Seven... eight... nine... TEN!"',
            "Clover made it to the top! The pattern was complete, and Clover felt proud.",
        ],
    },
    "activity-clover-s-morning": {
        "character": "clover",
        "pages": [
            "Every morning, Clover follows the same routine. First: wake up!",
            "Second: eat a yummy breakfast. Clover likes knowing what comes next.",
            "Third: wash up and brush fur. Clover feels so clean and fresh!",
            "Fourth: put on clothes. Clover picks the same favorite outfit.",
            "Fifth: look in the mirror and smile. Clover is ready for the day!",
            "Clover loves routines because they feel safe. Every day follows a pattern.",
        ],
    },
    "activity-sparks-and-the-end-of-park-time": {
        "character": "sparks",
        "pages": [
            "Sparks was having SO much fun at the park! The day was perfect!",
            "But then... it was time to leave. Sparks felt a BIG feeling growing inside.",
            '"I don\'t want to go!" Sparks felt frustrated and upset.',
            'Mom said: "I know you\'re sad. Big feelings are okay. Let\'s talk about it."',
            "Sparks took deep breaths. The big feeling got a little smaller.",
            "Sparks learned: it's okay to feel sad sometimes. Feelings come and go.",
        ],
    },
    "activity-the-same-blue-truck": {
        "character": "clover",
        "pages": [
            "Every day, Clover saw the same blue truck drive by. Clover loved patterns!",
            '"There it is! The blue truck! Same as always!" Clover wagged with joy.',
            "One day, the blue truck didn't come. Clover felt worried.",
            "But then... there it was! A little later than usual, but still there!",
            "Clover realized that patterns sometimes change a little, and that's okay!",
            "The blue truck always comes, even if it's at a different time. Clover felt safe.",
        ],
    },
    "activity-zee-finds-all-the-colors": {
        "character": "zee",
        "pages": [
            'Zee the curious octopus was exploring the reef. "What colors are there?"',
            'First, Zee found something RED! A beautiful red coral. "How pretty!"',
            "Next, a bright YELLOW fish swam by. Zee reached out with tentacles.",
            "Then Zee found BLUE rocks and GREEN plants everywhere! So many colors!",
            "Zee also found ORANGE, PURPLE, and so many more! The world was colorful!",
            "Zee learned that colors are all around us. Finding them is an adventure!",
        ],
    },
    "activity-zee-tries-something-new": {
        "character": "zee",
        "pages": [
            'Zee found something new floating in the water. "What is this?" Zee was curious!',
            "It was a seaweed snack! Zee had never tried seaweed before.",
            '"It\'s different..." Zee felt a little nervous. "What if I don\'t like it?"',
            'But Zee was brave! "I can try new things!" Zee tasted the seaweed.',
            '"Mmm! It\'s crunchy! It\'s yummy! I like trying new things!" Zee was so happy!',
            "Zee learned: being brave enough to try something new can lead to wonderful surprises!",
        ],
    },
    "activity-sparks-and-the-scary-storm": {
        "character": "sparks",
        "pages": [
            "Sparks was building the BEST sandcastle ever! Tall towers, a moat, everything!",
            'Dark clouds rolled in. The wind blew harder. "What\'s happening to the sky?"',
            "BOOM! Thunder crashed so loud the ground shook! Sparks hid behind the sandcastle.",
            'The rain washed the sandcastle away. "NO! That\'s not fair!" Sparks stomped and growled.',
            'Mom sat with Sparks and listened to the rain. "Storms pass. So do big feelings."',
            "When the sun came back, Sparks built a NEW sandcastle. Even better than before!",
        ],
    },
    "activity-clover-s-rainy-day": {
        "character": "clover",
        "pages": [
            'Today was PARK DAY! Clover packed a bag and waited by the door. "Let\'s go!"',
            "But it was raining. A lot. No park today. Clover's tail drooped.",
            '"It\'s not FAIR!" Clover barked. "The plan was the PARK! Rain ruined everything!"',
            "A big BOOM of thunder shook the windows. Clover dove under the blanket.",
            'Clover took a deep breath. "Maybe I can make a new plan for inside."',
            "Clover built a blanket fort and read stories all day. New plans can be great plans!",
        ],
    },
    "activity-zee-learns-to-ask-for-help": {
        "character": "zee",
        "pages": [
            'Zee spotted something shiny deep inside a coral hole. "Ooh, what IS that?"',
            "Zee pulled and squeezed with all eight tentacles. It wouldn't budge!",
            '"I can\'t do it..." Zee\'s tentacles drooped. Maybe it was impossible.',
            'Wait! Zee remembered a special sign \u2014 HELP! Zee signed to a passing fish. "Please?"',
            'The fish wiggled it free \u2014 a beautiful pearl! "Thank you!" Zee signed back.',
            "Zee learned something important: asking for help isn't giving up. It's being brave!",
        ],
    },
    "activity-zee-gets-lost": {
        "character": "zee",
        "pages": [
            "Zee swam faster and faster, exploring a new part of the reef. So many new things!",
            "But wait... nothing looked familiar. Which way was home? Zee's tentacles curled up tight.",
            '"This is the WORST!" Zee was mad \u2014 mad at the reef, mad at being lost, mad at everything.',
            'Zee saw a wise old turtle. Zee signed PLEASE with a tentacle. "Can you help me find home?"',
            "The turtle led Zee all the way back! Mama was waiting. Zee signed I LOVE YOU with all eight tentacles.",
            "Zee learned: even when things are scary, you are never really alone. Just ask.",
        ],
    },
}


def generate_page(text: str, voice_id: str, output_prefix: Path) -> None:
    """Call ElevenLabs with-timestamps API and save audio + timestamps."""
    url = f"{BASE_URL}/{voice_id}/with-timestamps"
    payload = json.dumps({
        "text": text,
        "model_id": MODEL_ID,
        "voice_settings": {
            "stability": 0.6,
            "similarity_boost": 0.8,
            "style": 0.4,
        },
    }).encode()

    req = Request(url, data=payload, method="POST")
    req.add_header("xi-api-key", API_KEY)
    req.add_header("Content-Type", "application/json")

    with urlopen(req) as resp:
        data = json.loads(resp.read())

    # Save MP3
    audio_bytes = base64.b64decode(data["audio_base64"])
    mp3_path = output_prefix.with_suffix(".mp3")
    mp3_path.write_bytes(audio_bytes)

    # Save timestamps
    timestamps = data.get("normalized_alignment") or data.get("alignment")
    json_path = output_prefix.with_name(output_prefix.name + "_timestamps.json")
    json_path.write_text(json.dumps(timestamps, indent=2))

    print(f"  ✅ {mp3_path.name} ({len(audio_bytes)} bytes)")


def main():
    total_chars = 0
    total_pages = 0

    for story_id, story in STORIES.items():
        character = story["character"]
        voice_id = VOICE_MAP[character]
        story_dir = OUTPUT_DIR / story_id
        story_dir.mkdir(parents=True, exist_ok=True)

        print(f"\n📖 {story_id} (voice: {character})")

        for i, text in enumerate(story["pages"]):
            output_prefix = story_dir / f"page_{i}"

            # Skip if already generated
            if output_prefix.with_suffix(".mp3").exists():
                print(f"  ⏭️  page_{i}.mp3 already exists, skipping")
                continue

            generate_page(text, voice_id, output_prefix)
            total_chars += len(text)
            total_pages += 1

            # Rate limit: small delay between requests
            time.sleep(0.5)

    print(f"\n🎉 Done! Generated {total_pages} pages, {total_chars} characters used.")


if __name__ == "__main__":
    main()
