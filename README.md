# Neplox Link Previewer

[![pub package](https://img.shields.io/pub/v/neplox_linkpreviewer.svg)](https://pub.dev/packages/neplox_linkpreviewer)

A Flutter package for fetching web-page metadata and displaying responsive,
customizable link-preview cards.

## Features

- Extracts Open Graph, Twitter Card, HTML title, description, images, and icons
- Resolves relative metadata URLs against the final response URL
- Caches successful previews for 24 hours
- Supports fixed-height and content-wrapping cards
- Places thumbnails above, below, left, right, or hides them
- Opens links in-app, externally, or not at all
- Exposes metadata for fully custom interfaces
- Handles invalid URLs, timeouts, HTTP errors, and missing images

## Installation

```yaml
dependencies:
  neplox_linkpreviewer: ^1.1.0
```

Then import the public library:

```dart
import 'package:neplox_linkpreviewer/neplox_linkpreviewer.dart';
```

## Basic usage

```dart
NeploxLinkPreviewer(
  url: 'https://example.com/article',
)
```

The URL may omit its scheme; HTTPS is assumed. Only HTTP and HTTPS URLs are
fetched and launched. Changing `url` on an existing widget automatically loads
the new preview.

## Height modes

### Fixed height

Use fixed height for uniform cards in lists and grids:

```dart
NeploxLinkPreviewer(
  url: 'https://example.com/article',
  cardStyle: NCardStyle(
    heightMode: NCardHeightMode.fixed,
    height: 140,
  ),
)
```

When `height` is omitted, the package calculates a default based on the screen
size and thumbnail direction.

### Content-wrap height

Use content-wrap when the card should grow as text wraps:

```dart
NeploxLinkPreviewer(
  url: 'https://example.com/article',
  cardStyle: NCardStyle(
    heightMode: NCardHeightMode.contentWrap,
    minHeight: 100,
    contentPadding: const EdgeInsets.all(14),
    textSpacing: 8,
  ),
  typographyStyle: NTypographyStyle(
    titleMaxLine: 3,
    bodyMaxLine: 6,
  ),
)
```

`height` is ignored in content-wrap mode. Growth is limited by
`titleMaxLine` and `bodyMaxLine`. Top and bottom thumbnails use
`thumbnailAspectRatio` instead of a fixed height.

## Responsive card example

```dart
NeploxLinkPreviewer(
  url: 'https://example.com/article',
  linkPreviewOptions: NLinkPreviewOptions(
    thumbnailPreviewDirection: NThumbnailPreviewDirection.ltr,
    urlLaunch: NURLLaunch.enable,
    urlLaunchIn: NURLLaunchIn.browser,
  ),
  cardStyle: NCardStyle(
    width: double.infinity,
    heightMode: NCardHeightMode.contentWrap,
    minHeight: 110,
    horizontalThumbnailFraction: 0.32,
    verticalThumbnailFraction: 0.5,
    thumbnailAspectRatio: 16 / 9,
    contentPadding: const EdgeInsets.all(12),
    textSpacing: 6,
  ),
  typographyStyle: NTypographyStyle(
    titleFontSize: 17,
    titleMaxLine: 3,
    bodyFontSize: 13,
    bodyMaxLine: 5,
  ),
)
```

Side-thumbnail layouts switch to a top thumbnail below 240 logical pixels.
Short vertical layouts switch to a side or text-only layout to keep text
readable.

## Fetch metadata for custom UI

```dart
final metadata = await NeploxMetaDataFetcher.instance.fetchData(
  'https://example.com/article',
);

if (metadata.hasPreviewData) {
  print(metadata.title);
  print(metadata.description);
  print(metadata.image);
  print(metadata.link);
}
```

Every metadata field is nullable because websites may omit it. `link` uses the
canonical `og:url` when available and otherwise falls back to the final fetched
URL. Use `hasPreviewData` to determine whether the model contains a title,
description, or image suitable for display.

## Configuration reference

### `NLinkPreviewOptions`

| Property | Default | Purpose |
| --- | --- | --- |
| `thumbnailPreviewDirection` | `ltr` | Thumbnail placement: `normal`, `top`, `bottom`, `ltr`, or `rtl` |
| `urlLaunch` | `enable` | Enables or disables card taps |
| `urlLaunchIn` | `browser` | Opens externally, in-app, or nowhere with `none` |

### `NCardStyle`

| Property | Default | Purpose |
| --- | --- | --- |
| `heightMode` | `fixed` | Fixed or content-driven card height |
| `width` / `height` | `null` | Explicit card dimensions |
| `minHeight` | `0` | Minimum content-wrap height |
| `contentPadding` | `EdgeInsets.all(12)` | Padding around title and description |
| `textSpacing` | `6` | Gap between title and description |
| `horizontalThumbnailFraction` | `0.32` | Thumbnail width in side layouts |
| `verticalThumbnailFraction` | `0.5` | Thumbnail height in fixed top/bottom layouts |
| `thumbnailAspectRatio` | `16 / 9` | Top/bottom image ratio in content-wrap mode |
| `bgColor` | `Colors.white` | Card background |
| `elevation` | `2` | Material elevation |
| `borderRadius` | `BorderRadius.circular(12)` | Card and ink clipping radius |

### `NTypographyStyle`

Use the `title*` properties for the title and `body*` properties for the
description. Providing `titleTextStyle` or `bodyTextStyle` overrides the
individual font size, weight, and color values for that text.

## Platform notes

- Flutter Web requests are subject to the destination server's CORS policy.
- Android applications require internet access; standard Flutter templates
  normally include it.
- In-app and external launching require the platform setup documented by
  `url_launcher`.
- Some websites block automated requests or return pages without preview
  metadata. The widget displays a retry action in that case.

See the runnable [example](example/lib/main.dart) and
[CONTRIBUTING.md](CONTRIBUTING.md) for implementation and contribution details.
