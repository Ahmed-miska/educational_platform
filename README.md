# Thaheen · ذهين

An offline mini learning platform built with Flutter. Arabic is the default language, and English is also supported. Courses, lessons and videos ship inside the app, so it runs without a network connection.

You can browse and search courses and watch lessons in order: each lesson unlocks once playback of the previous one reaches 90%. Playback resumes where you left off, and a *Continue watching* card on the home screen opens your last unfinished lesson. The app also has Arabic/English and light/dark mode.

## How to run

Requirements: Dart SDK 3.13.1 or later (built with Flutter 3.47.1), and an Android or iOS device or emulator.

```bash
flutter pub get
flutter run        # add -d <device id> to pick a device
flutter test
```

Content lives in [assets/data/courses.json](assets/data/courses.json) (format [below](#content-format)). The sample data includes two demo cases on purpose. *Principles of Pharmacology* has no sections, so it shows the empty state. Lesson `physiology-101-l4` points to a video that doesn't exist, so it shows the player's error state with *Try again*.

## Architecture and state management

```
lib/
├── core/            theme, colors, routes, translations, shared helpers
├── data/            models, local data sources, repositories
├── domain/          progress_rules.dart: the business rules as pure functions
├── presentations/   screens, view models and shared widgets
├── injection.dart   get_it registrations
└── main.dart
```

- **Courses:** `courses.json` → `CoursesLocalDataSource` → `CoursesRepository` → `CoursesViewModel`
- **Progress:** `SharedPreferences` ↔ `ProgressLocalData` ↔ `ProgressRepository` ↔ `ProgressViewModel`
- **Player:** a `LessonPlayerViewModel` for each lesson screen

### Choices and why

- **Provider with `ChangeNotifier` view models.** The app has a little shared state (the course list and lesson progress) and one screen with complex local state (the player). Provider handles both with very little setup. It's the approach the Flutter docs use for simple app state, and the view models are plain Dart classes that are easy to test. Screens listen through `Consumer`. Widgets only render and forward events, and logic, navigation and messages stay in the view models.
- **One `ProgressViewModel` for the whole app.** Home, course details and the player all show the same progress. With a single source of truth, finishing a lesson updates the lock icons, the course percentage and the *Continue watching* card everywhere, with no extra syncing.
- **One `LessonPlayerViewModel` per screen.** It owns the `VideoPlayerController`, the timer that hides the controls, the seek-drag state and full-screen mode. It's disposed with the screen, so the controller's lifecycle follows the route, and it saves the final position when it goes.
- **Business rules in `domain/progress_rules.dart`.** The 90% completion rule, unlocking in order, resume position, course percentage and *continue watching* are pure functions with no Flutter dependency. Fast unit tests cover them, and the view models stay thin.
- **Repositories on top of local data sources.** Only the data sources know about the JSON asset and SharedPreferences, and the view models only talk to repositories. Swapping the bundled JSON for an API later would only touch the data layer. `CoursesRepository` also turns exceptions into an error result that the UI shows with a retry button.
- **get_it for dependency injection.** Constructors take their dependencies as optional parameters that default to get_it. The app wires itself up, and tests pass fakes straight into the constructor without any DI setup.
- **go_router** gives path-based routes such as `/courses/:courseId/lessons/:lessonId` and a not-found page for unknown routes. Each screen looks up its course and lesson from the ids, so it handles missing or locked content itself.
- **easy_localization** for JSON translation files, with Arabic plural forms (zero, one, two, few, many, other) and a remembered language choice.
- **shared_preferences** because the stored data is small: the progress map, the theme and the playback speed.

## Trade-offs and known issues

- **Completion is based on the position reached, not on time watched.** Seeking past 90% completes a lesson and unlocks the next one. The logic stays simple, but it doesn't prove the lesson was watched.
- **Progress is keyed by lesson id only.** Lesson ids must be unique across all courses. A test checks this for the bundled `courses.json`, but the app doesn't validate it at runtime.
- **The whole progress map is saved as one JSON string in SharedPreferences.** This happens every 5 seconds of playback, and on pause, seek and exit. That's fine for a few dozen lessons, but it wouldn't scale to a large catalogue.
- **Course percentage is rounded.** In a course with 200 or more lessons, 199 of 200 rounds to 100%, and the course would show as completed.
- **Videos are bundled in the app.** This keeps it fully offline, but the app grows with every lesson.
- **`durationSec` in the JSON is only for display.** The lesson list shows it, the player uses the real video length, and nothing checks that they match.
- **Translations are read through a stored `BuildContext` (`AppTranslate`).** It keeps call sites short, but widgets don't rebuild on a language change by themselves. That works here only because the language can be changed from the home screen alone.
- **After the dark mode switch is used, the app no longer follows the system theme.** There's no option to go back to it.
- **The player has no automated tests.** `LessonPlayerViewModel` uses the `video_player` plugin directly, so it isn't covered by unit or widget tests.

## What I'd do with more time

- Track the parts of a video that were actually watched, and complete a lesson at 90% of watched time instead of 90% position.
- Key progress by course and lesson, validate ids when loading, and move storage to a small database (for example Drift or Hive) that saves only the lesson that changed.
- Put the video controller behind an interface, so `LessonPlayerViewModel` can be unit tested with a fake, and add integration tests on a real device.
- Load courses from an API and download videos for offline use, instead of bundling them.
- Add a three-way theme setting (system, light, dark), do an accessibility pass (screen reader labels, large text) and build a tablet layout.
- Set up CI that runs `flutter analyze` and `flutter test` on every push.

## Time spent

Roughly 4–6 hours.

---

## Features

**Courses (home)**
- Search by course title or instructor. Matching is Arabic-aware: it ignores diacritics and treats أ/إ/آ as ا, ة as ه and ى as ي.
- Every course shows its progress. The *Continue watching* card opens the most recent unfinished lesson.

**Course details**
- Lessons are grouped by section. Each one shows its duration and status: not started, in progress, completed or locked.
- Lessons unlock in order, across sections too. Tapping a locked lesson tells you which lesson to finish first.

**Lesson player**
- Play/pause, ±10 seconds, a seek bar, playback speed (1x, 1.25x, 1.5x, 2x, remembered between sessions), landscape full screen and controls that hide on their own.
- Resumes from the saved position, or restarts if that position is in the last 3 seconds.
- The *Next lesson* button unlocks as soon as the current lesson reaches 90%.

**Settings**
- Arabic or English (RTL/LTR), dark mode, and reset progress.


## Content format

```json
{
  "courses": [
    {
      "id": "anatomy-101",
      "title": { "ar": "مقدمة في التشريح", "en": "Introduction to Anatomy" },
      "instructor": { "ar": "د. سارة", "en": "Dr. Sarah" },
      "thumbnail": "assets/images/anatomy.png",
      "sections": [
        {
          "title": { "ar": "الجهاز الهيكلي", "en": "The Skeletal System" },
          "lessons": [
            { "id": "anatomy-101-l1", "title": { "ar": "العظام", "en": "Bones" }, "durationSec": 30, "video": "assets/videos/lesson1.mp4" }
          ]
        }
      ]
    }
  ]
}
```

- Courses and lessons need an `id`. Lesson ids must be unique across all courses.
- `title` and `instructor` can be a plain string or an `{ "ar", "en" }` object. If the English text is missing, the Arabic is shown.

## Tests

- `test/domain`: the 90% rule, unlocking in order across sections, course percentage, lesson status, resume position and continue watching.
- `test/data`: the bundled `courses.json` parses, its lesson ids are unique, and every asset it references exists. Also covers edge cases in model parsing.
- `test/presentations`: `ProgressViewModel` (saving, surviving a restart, corrupt data, reset), plus widget tests for the courses and course details screens.
- `test/core`: duration formatting and Arabic search normalization.
