import 'dart:convert';

/// Metadata extracted from a web page.
///
/// Every field is optional because websites are not required to publish rich
/// preview metadata. [link] normally contains the canonical URL, falling back
/// to the URL that was fetched.
class ElementModel {
  /// Creates metadata with any combination of available fields.
  ElementModel({
    this.title,
    this.description,
    this.image,
    this.appleIcon,
    this.favIcon,
    this.link,
  });

  /// Page title.
  ///
  /// Mutable for compatibility with versions through 1.0.8. Prefer [copyWith]
  /// in new code.
  String? title;

  /// Page summary or description.
  String? description;

  /// Absolute preview-image URL.
  String? image;

  /// Absolute Apple touch-icon URL.
  String? appleIcon;

  /// Absolute favicon URL.
  String? favIcon;

  /// Canonical URL, or the final fetched URL when no canonical URL exists.
  String? link;

  /// Creates a model from a JSON string.
  ///
  /// This instance method is retained for backward compatibility.
  ElementModel elementModelFromJson(String str) =>
      ElementModel.fromJson(json.decode(str));

  /// Encodes [data] as a JSON string.
  static String elementModelToJson(ElementModel data) =>
      json.encode(data.toJson());

  /// Creates metadata from a decoded JSON map.
  factory ElementModel.fromJson(Map<String, dynamic> json) => ElementModel(
        title: json["title"] as String?,
        description: json["description"] as String?,
        image: json["image"] as String?,
        appleIcon: json["appleIcon"] as String?,
        favIcon: json["favIcon"] as String?,
        link: json["link"] as String?,
      );

  /// Converts this model to a JSON-compatible map.
  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "image": image,
        "appleIcon": appleIcon,
        "favIcon": favIcon,
        "link": link,
      };

  /// Creates a model with every field set to null.
  static ElementModel empty() => ElementModel(
      title: null,
      description: null,
      appleIcon: null,
      favIcon: null,
      image: null,
      link: null);

  /// Whether this model contains no usable preview information.
  bool isEmpty() => [title, description, image, link]
      .every((value) => value == null || value.trim().isEmpty);

  /// Whether this model has content that can be displayed in a preview.
  ///
  /// A launch URL by itself is not preview content. Keeping this separate from
  /// [isEmpty] preserves the behavior of the existing public method while
  /// preventing blank pages from being cached and rendered as valid cards.
  bool get hasPreviewData => [title, description, image]
      .any((value) => value != null && value.trim().isNotEmpty);

  /// Returns a model with selected non-null values replaced.
  ///
  /// This compatibility method cannot clear an existing field to null.
  ElementModel copyWith({
    String? title,
    String? description,
    String? image,
    String? appleIcon,
    String? favIcon,
    String? link,
  }) {
    return ElementModel(
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      appleIcon: appleIcon ?? this.appleIcon,
      favIcon: favIcon ?? this.favIcon,
      link: link ?? this.link,
    );
  }
}
