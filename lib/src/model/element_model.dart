import 'dart:convert';

/// Public ElementModel class for Neplox Link Previewer to map the link metadata
/// <summary>
/// [title] the title from the metadata
/// [description] the description from the metadata
/// [image] the image from the metadata
/// [appleIcon] the icon from the metadata
/// [favIcon] the icon from the metadata
/// [link] the url from the metadata
/// This data is accepted by ElementModel

class ElementModel {
  ElementModel({
    this.title,
    this.description,
    this.image,
    this.appleIcon,
    this.favIcon,
    this.link,
  });

  String? title;
  String? description;
  String? image;
  String? appleIcon;
  String? favIcon;
  String? link;

  /// Create an instance of ElementModel from JSON string
  ElementModel elementModelFromJson(String str) =>
      ElementModel.fromJson(json.decode(str));

  /// Convert ElementModel to JSON string
  static String elementModelToJson(ElementModel data) =>
      json.encode(data.toJson());

  /// Factory constructor to create ElementModel from JSON map
  factory ElementModel.fromJson(Map<String, dynamic> json) => ElementModel(
        title: json["title"] as String?,
        description: json["description"] as String?,
        image: json["image"] as String?,
        appleIcon: json["appleIcon"] as String?,
        favIcon: json["favIcon"] as String?,
        link: json["link"] as String?,
      );

  /// Convert ElementModel instance to JSON map
  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "image": image,
        "appleIcon": appleIcon,
        "favIcon": favIcon,
        "link": link,
      };

  /// Empty Data object
  static ElementModel empty() => ElementModel(
      title: null,
      description: null,
      appleIcon: null,
      favIcon: null,
      image: null,
      link: null);

  // Empty Object validation
  bool isEmpty() {
    return [
      title == null,
      description == null,
      image == null,
      link == null,
    ].every((e) => e);
  }

  /// CopyWith method to create a new instance with some updated fields
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
