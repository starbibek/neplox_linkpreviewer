# Contributing

Thank you for improving Neplox Link Previewer. Bug reports, documentation
corrections, tests, and focused implementation changes are welcome.

## Development setup

The repository uses FVM. Install FVM, then run:

```shell
fvm flutter pub get
fvm dart format --output=none --set-exit-if-changed lib test example/lib example/test
fvm flutter analyze
fvm flutter test
cd example
fvm flutter test
```

Do not submit generated platform-file changes unless the change requires them.

## Architecture

- `lib/src/fetch_elements/` validates URLs, performs HTTP requests, and parses
  metadata. Fetch failures return `ElementModel.empty()` to preserve the public
  API.
- `lib/src/cache/` owns SharedPreferences initialization and cache keys. Always
  use the normalized requested URL as the key; canonical metadata is optional.
- `lib/src/link_previewer/` owns asynchronous widget state and must refresh the
  future when a URL changes.
- `lib/src/helper/ncard_view.dart` renders bounded layouts and handles launching.
- `lib/src/model/` contains metadata values and JSON serialization. Fields stay
  mutable for compatibility with versions through 1.0.8; prefer `copyWith` in
  new code.

## Change guidelines

1. Preserve public API compatibility unless the change is intentionally marked
   as breaking and documented in the changelog.
2. Treat every metadata field as optional. Never display the string `null`.
3. Accept only HTTP and HTTPS links. Resolve relative page assets against the
   final page URI.
4. Check HTTP status codes and keep network operations bounded by a timeout.
5. Do not cache empty or failed responses.
6. Await asynchronous cache and URL-launch operations so errors are observable.
7. Add a regression test for every bug fix. Use `MockClient` rather than making
   live network requests in tests.
8. Use `metadataLoader` only in widget tests; production code should use the
   package's normal fetcher and cache pipeline.

## Pull requests

Keep pull requests focused and explain the user-visible behavior being changed.
Before opening one, ensure formatting, analysis, and tests all pass. Update the
README or API documentation whenever behavior or public configuration changes.
