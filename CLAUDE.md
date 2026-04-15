# Seedling — Session Start

## Required Reads (in order)

1. `SESSION.md` — current focus, recent work, where to start
2. `~/Downloads/claude/docs/superpowers/plans/2026-04-03-seedling-plan-1-foundation.md` — current plan, all tasks

## Context

Flutter/Firebase learning/milestone tracking app for kids (built for Sherani). Very early — Plan 1 Foundation in progress.

Stack: Flutter/Dart + Firebase (Firestore + Auth) + Riverpod 2.x + go_router 14.x + freezed 2.x

**Children are sub-documents under parent accounts — they never authenticate themselves.**
Firebase project on Blaze plan required for Cloud Functions in later plans.

## Google API Billing — Hard Rule

**No non-free tier usage allowed for any Google API in any project under ~/Code.**
Applies to: Gemini models, Firebase, Firestore, Cloud Functions, Cloud Storage, Cloud Run, Vertex AI, and all other Google/GCP services.

- Always use free-tier models (e.g., `gemini-2.0-flash` — never `gemini-2.5-flash` or any paid Gemini variant)
- If free quota is exhausted, stop and surface the issue — do NOT switch to a paid model or tier
- Never enable billing for a new API without explicit approval from Mo
