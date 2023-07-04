import 'dart:convert';

/// ElementModel for Neplox Link Previewer  to map the link metadata
/// <summary>
/// [title] the title from the metadata
/// [description] the description from the metadata
/// [image] the image from the metadata
/// [appleIcon] the icon from the metadata
/// [favIcon] the icon from the metadata
/// [link] the url from the metadata
/// Are Accepted by ElementModel
ElementModel elementModelFromJson(String str) =>
    ElementModel.fromJson(json.decode(str));

///  Element Model to Json
String elementModelToJson(ElementModel data) => json.encode(data.toJson());

/// Element Model Cunstructor
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

  factory ElementModel.fromJson(Map<String, dynamic> json) => ElementModel(
        title: json["title"],
        description: json["description'"],
        image: json["image"],
        appleIcon: json["appleIcon"],
        favIcon: json["favIcon"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description'": description,
        "image": image,
        "appleIcon": appleIcon,
        "favIcon": favIcon,
        "link": link,
      };
}
