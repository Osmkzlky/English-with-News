// ignore_for_file: public_member_api_docs, sort_constructors_first
class Advertisement {
  final String advertisement_title;
  final String advertisement_image;
  final String advertisement_link;
  Advertisement({
    required this.advertisement_title,
    required this.advertisement_image,
    required this.advertisement_link,
  });
  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
        advertisement_title: json["advertisement_title"],
        advertisement_image: json["advertisement_image"],
        advertisement_link: json["advertisement_link"]);
  }
}
