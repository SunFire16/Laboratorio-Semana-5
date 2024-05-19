// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

List<Post> postFromJson(String str) => List<Post>.from(json.decode(str).map((x) => Post.fromJson(x)));

String postToJson(List<Post> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Post {
    String name;
    DateTime dateUtc;
    bool success;
    Links links;

    Post({
        required this.name,
        required this.dateUtc,
        required this.success,
        required this.links,
    });

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        name: json["name"],
        dateUtc: DateTime.parse(json["date_utc"]),
        success: json["success"] == null ? false : json["success"],
        links: Links.fromJson(json["links"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "date_utc": dateUtc.toIso8601String(),
        "success": success,
        "links": links.toJson(),
    };
}

class Links {
    Patch patch;

    Links({
        required this.patch,
    });

    factory Links.fromJson(Map<String, dynamic> json) => Links(
        patch: Patch.fromJson(json["patch"]),
    );

    Map<String, dynamic> toJson() => {
        "patch": patch.toJson(),
    };
}

class Patch {
    String? small;

    Patch({
        required this.small,
    });

    factory Patch.fromJson(Map<String, dynamic> json) => Patch(
        small: json["small"],
    );

    Map<String, dynamic> toJson() => {
        "small": small,
    };
}
