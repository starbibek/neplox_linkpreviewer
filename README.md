# neplox_linkpreviewer

[![pub package](https://img.shields.io/pub/v/neplox_linkpreviewer.svg)](https://pub.dev/packages/neplox_linkpreviewer)

A Flutter package for fetching and displaying rich link previews with customizable styling and behavior. 

## Features

- **Automatic Metadata Extraction:** Easily fetch title, description, images, and icons from URLs.
- **Built-in Preview Widget:** `NeploxLinkPreviewer` provides a pre-styled link preview.
- **Customizable:**
    - Control thumbnail positioning (`NThumbnailPreviewDirection`).
    - Style text and background colors.
    - Choose whether to launch URLs in-app or in an external browser (`NURLLaunch`, `NURLLaunchIn`).
- **Flexible Metadata Access:** Use `NeploxMetaDataFetcher` to get metadata for your own custom UI implementations.
- **Caching:** Improves performance by caching fetched metadata.
- **Extensible:** Supports custom widget builders for full control over the preview layout.
- **Error Handling:** Gracefully handles invalid URLs and network issues.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  neplox_linkpreviewer: ^1.0.6

``````
## Usage
### 1. Using the Built-in Preview Widget

```dart
NeploxLinkPreviewer(
  url: '[https://example.com](https://example.com)',
  linkPreviewOptions: NLinkPreviewOptions(
    thumbnailPreviewDirection: NThumbnailPreviewDirection.bottom, 
    urlLaunch: NURLLaunch.enable,
    urlLaunchIn: NURLLaunchIn.browser,  // Or NURLLaunchIn.app
  ),
  // Customize styles here (titleColor, subtitleColor, etc.)
)

``````
### 2. Fetching Meta Data For Custom Widgets

```dart
final metaDataFetcher = NeploxMetaDataFetcher.instance;
final elementModel = await metaDataFetcher.fetchData('[https://example.com](https://example.com)');

// Use elementModel.title, elementModel.description, etc. to build your own UI.