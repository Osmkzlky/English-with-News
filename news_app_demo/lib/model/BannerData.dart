// ignore_for_file: public_member_api_docs, sort_constructors_first
class BannerData {
  final String news_id;

  BannerData({
    required this.news_id,
  });
  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
      news_id: json["news_id"] ?? "",
    );
  }
}
