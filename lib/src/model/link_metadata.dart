import 'package:flutter/foundation.dart' show protected;

/// LinkMetadata represents the metadata information extracted from a URL.
///
/// This class provides a structured way to access webpage metadata such as
/// title, description, images, and icons. It is designed to be immutable
/// and can be created either through the protected constructor or factory methods.
class LinkMetadata {
  /// The title of the webpage, typically from meta tags or the <title> element
  final String? title;

  /// A brief description of the webpage content
  final String? description;

  /// URL of the main image associated with the webpage
  final String? image;

  /// URL of the Apple touch icon, used for iOS devices
  final String? appleIcon;

  /// URL of the webpage's favicon
  final String? favIcon;

  /// The canonical URL of the webpage
  final String? link;

  /// Creates a new LinkMetadata instance.
  ///
  /// This constructor is marked as [@protected] to ensure it's only used
  /// within the package while allowing for testing and internal usage.
  @protected
  const LinkMetadata({
    this.title,
    this.description,
    this.image,
    this.appleIcon,
    this.favIcon,
    this.link,
  });

  /// Creates an empty LinkMetadata instance.
  ///
  /// Useful when metadata extraction fails or for initialization.
  factory LinkMetadata.empty() => const LinkMetadata();

  /// Checks if the metadata is empty.
  ///
  /// Returns true if all main fields (title, description, image, link) are null.
  bool get isEmpty => [
        title == null,
        description == null,
        image == null,
        link == null,
      ].every((e) => e);

  /// Converts the metadata to a JSON-compatible map.
  ///
  /// Used for caching and serialization purposes.
  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'image': image,
        'appleIcon': appleIcon,
        'favIcon': favIcon,
        'link': link,
      };

  /// Creates a LinkMetadata instance from a JSON map.
  ///
  /// Used for deserializing cached metadata.
  factory LinkMetadata.fromJson(Map<String, dynamic> json) => LinkMetadata(
        title: json['title'] as String?,
        description: json['description'] as String?,
        image: json['image'] as String?,
        appleIcon: json['appleIcon'] as String?,
        favIcon: json['favIcon'] as String?,
        link: json['link'] as String?,
      );
}
