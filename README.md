# Seedling

**Guidance for you. Wonder for them.**

Seedling is a Flutter + Firebase app with two interconnected modes: expert-grounded AI parenting guidance for parents, and a calm, curated learning world for children. Built with no ads, no dark patterns, and COPPA compliance at the foundation.

- **Platform:** Android (primary), iOS (v2)
- **Stack:** Flutter + Dart, Firebase (Firestore, Auth, Cloud Functions, FCM), Riverpod, go_router, Freezed
- **AI:** Groq / Claude Sonnet, provider-agnostic, routed through Cloud Functions
- **Payments:** Stripe (freemium - free tier + $9/month premium)

---

## App Structure

| Mode | What it does |
|---|---|
| Parent Mode | Situation guide (quick-tap grid), AI chat, content library, session reports |
| Child Mode | Curated activities (stories, games, music), enforced session timer, calm UI |

**Characters:** Sparks (yellow T-Rex, big feelings), Clover (dusty rose dog, routines), Zee (teal octopus, curiosity + ASL)

---

## Landing Page

The marketing landing page lives at `landing/index.html` - a single-file HTML/CSS/JS page. No build step required.

To preview locally:
```bash
open landing/index.html
```

To deploy: upload `landing/index.html` to any static host (Netlify, Vercel, Firebase Hosting, Cloudflare Pages).

---

## Building & Running the App

**Run on device/emulator:**
```bash
flutter run
```

**Build a debug APK:**
```bash
flutter build apk --debug
```

**Build a release APK:**
```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

**Install directly on a connected Android device:**
```bash
flutter install
```

---

## Firebase Setup

Firebase project: `seedling-5a9f6`

**Cloud Functions (AI endpoints):**
```bash
cd firebase/functions
npm install
firebase deploy --only functions
```

**Firestore content seeding:**
```bash
# Requires gcloud auth application-default login first
node scripts/update_story_characters_cli.js
```

**ADC (one-time setup):**
```bash
gcloud auth application-default login
gcloud auth application-default set-quota-project seedling-5a9f6
```

---

## App Icon

Source: `assets/icon/app_icon.png` (1024x1024, cream background #F5F0E8)

To regenerate all icon sizes after updating the source:
```bash
flutter pub run flutter_launcher_icons
```

---

## Key Architecture Notes

- Children never authenticate. No child PII ever reaches an AI prompt. COPPA-compliant by design.
- All AI calls route through Cloud Functions - never direct from the Flutter client.
- System prompts are versioned `.md` files in `firebase/functions/prompts/` - update without an app release.
- Offline-first: Firestore persistence enabled, app works without connectivity.
- Session data auto-purges after 90 days.
