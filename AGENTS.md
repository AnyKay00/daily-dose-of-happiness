# Repository Guidelines

## Project Structure & Module Organization
- `lib/` holds application code. Feature logic sits under `lib/bloc/` (e.g., `wish_bloc`, `motivation_bloc`), shared models under `lib/model/`, service integrations such as Supabase auth in `lib/service/`, and composable UI in `lib/ui/` and `lib/widgets/`.
- Assets referenced from `pubspec.yaml` live in `assets/` plus nested folders like `assets/feelings/`; fonts are under `fonts/` with the Tomorrow family registered already.
- Platform shells stay in `android/` and `ios/`, so limit platform-specific tweaks to those folders. Tests belong in `test/`; mirror the lib structure when adding new suites (e.g., `test/repository/wish_repository_test.dart`).

## Build, Test, and Development Commands
- `flutter pub get` – sync package graph after changing `pubspec.yaml`.
- `flutter run --flavor development -d chrome` – fastest feedback loop for UI work; swap device/target as needed.
- `flutter analyze` – runs the analyzer with the rules from `analysis_options.yaml`.
- `flutter test` / `flutter test --coverage` – execute widget/unit tests and emit `coverage/lcov.info` for CI checks.
- `flutter build apk --release` or `flutter build ios --no-codesign` – create distributable artifacts without altering source.

## Coding Style & Naming Conventions
- Follow the default Flutter formatter: run `dart format .` before committing; keep Dart files in lower_snake_case (`wish_list_bloc.dart`).
- Prefer immutable `const` widgets where possible, extract repeated UI into `lib/widgets/`, and keep BLoC states/events in separate files named `<feature>_state.dart` / `<feature>_event.dart`.
- Use dependency injection through constructors for repositories/services; avoid storing secrets directly in source beyond placeholders.

## Testing Guidelines
- Extend `flutter_test` for widget verification and mock Supabase interactions at the repository layer.
- Name tests descriptively (`wish_repository_test.dart` with `group('fetchWishList', ...)`).
- Target at least one positive and one failure case per public repository/service method; update golden or screenshot assets when UI changes.

## Commit & Pull Request Guidelines
- Recent history uses short, lower-case subjects (e.g., `wip wishbox`). Keep messages under 72 chars, prefer imperative verbs, and add a blank line before details describing rationale.
- Each pull request should summarize scope, list impacted screens, link Supabase ticket/Jira, and attach screenshots for UI-visible adjustments.
- Ensure CI steps (`flutter analyze`, `flutter test`) pass locally before requesting review; note any follow-up tasks explicitly.

## Security & Configuration Tips
- API hosts/keys currently live in `lib/service/bloc_handler.dart`; migrate sensitive values into runtime config (e.g., `.env` consumed via `flutter_dotenv`) before shipping releases.
- Never commit personal Supabase credentials or Firebase profiles—use sample placeholders and document override steps in the PR description.
