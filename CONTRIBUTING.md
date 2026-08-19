# Contributing to Cadence

Thanks for your interest in improving Cadence. This guide covers how to get
set up and what's expected in a pull request.

## Development setup

Follow the [Getting started](README.md#getting-started) steps in the README.
You will need your own Firebase project — the committed configuration points at
the maintainer's and won't accept your writes.

## Before you open a pull request

Both of these must pass:

```bash
flutter analyze
flutter test
```

`flutter analyze` currently reports a number of pre-existing deprecation infos
(mostly `withOpacity` and `ColorScheme.background`). Please don't add new
warnings or errors; fixing existing ones in the area you're touching is welcome.

## Code style

- Follow standard Dart conventions and `dart format`.
- Match the surrounding code. The codebase mixes naming styles for historical
  reasons — new files should use `lower_snake_case.dart`.
- Prefer `const` constructors where the analyzer suggests them.
- Don't use `print()` for anything that ships. It leaks to production logs.

## Data model changes

The Firestore schema is documented in the [README](README.md#data-model). If you
change what a task document contains:

1. Update `TodoModel` (`toMap`, `fromFirestore`, `fromMap`, `copyWith`).
2. Update `firestore.rules` if the change affects validation or ownership.
3. Update the README's data model table.
4. Consider existing documents — reads should tolerate a missing field.

Field names must stay consistent between what's written and what's queried. A
past bug had the home page filtering on an `isCompleted` field that nothing
ever wrote.

## Commit messages

Write in the imperative mood and explain *why*, not just what:

```
Fix completed filter returning no results

The query filtered on `isCompleted`, but TodoModel persists `status`.
```

## Reporting bugs

Please include: what you expected, what happened, your Flutter version
(`flutter --version`), the platform, and any relevant console output.

## Security

Don't open a public issue for a security problem — especially anything
involving Firestore rules or authentication. Contact the maintainer directly.
