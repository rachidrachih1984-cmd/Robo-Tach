# Robo-Tach Engineering Rules

## Product goal
Build a real Android English-speaking AI coach, not a UI prototype.

## Definition of done
A feature is NOT done because it compiles. It is done only when its user-visible acceptance checks pass.

## Required workflow
1. Work one vertical feature at a time.
2. Run `flutter analyze lib` before accepting a change.
3. Add automated tests where the behavior can be tested without a physical phone.
4. Build the Android APK after each accepted vertical slice.
5. Never disable a button for a promised core feature in a release candidate.
6. Never hard-code API secrets in the APK. AI provider secrets must live on a backend/proxy.
7. Keep failures visible to the user with a useful error message; do not silently fail.

## Voice milestone acceptance
- Android requests microphone permission.
- User can tap the microphone and start/stop listening.
- Recognized English appears in the input/transcript.
- The app can speak a response using TTS.
- Permission denial and unavailable speech recognition do not crash the app.

## AI conversation milestone acceptance
- Friend Mode and Teacher Mode have distinct prompts/behavior.
- Replies are dynamic, not hard-coded scripts.
- Teacher Mode waits for the learner's thought, then gives a short gentle correction.
- Darija may be used to explain confusion or mistakes.
- Replies stay beginner-friendly and end with one clear question.
- Conversation context is preserved during the session.
- API/network failure produces a retryable UI state.

## Memory milestone acceptance
- Remember the learner name, level, recurring mistakes, saved vocabulary and progress.
- Persist appropriate non-secret profile/progress data across restarts.

## Release rule
Do not describe an APK as finished/final until all milestones targeted for that release have passed their acceptance checks on Android.