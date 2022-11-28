import 'dart:convert';

ElementModel elementModelFromJson(String str) => ElementModel.fromJson(json.decode(str));

String elementModelToJson(ElementModel data) => json.encode(data.toJson());

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
