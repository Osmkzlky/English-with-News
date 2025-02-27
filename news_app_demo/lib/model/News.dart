// ignore_for_file: public_member_api_docs, sort_constructors_first
class News {
  final String news_id;
  final String news_titleEng;
  final String news_titleTur;
  final String news_contentEng;
  final String news_contentTur;
  final String news_date;
  final String news_image;
  final String news_source;
  final String news_time;
  final List news_words;
  final String news_sound;
  final String news_category;
  final List news_comments;
  final String news_url;
  News({
    required this.news_id,
    required this.news_titleEng,
    required this.news_titleTur,
    required this.news_contentEng,
    required this.news_contentTur,
    required this.news_date,
    required this.news_image,
    required this.news_source,
    required this.news_time,
    required this.news_words,
    required this.news_sound,
    required this.news_category,
    required this.news_comments,
    required this.news_url,
  });
  factory News.fromJson(Map<String, dynamic> json) {
    return News(
        news_id: json["news_id"] ?? "",
        news_titleEng: json["news_titleEng"] ?? "",
        news_titleTur: json["news_titleTur"] ?? "",
        news_contentEng: json["news_contentEng"] ?? "",
        news_contentTur: json["news_contentTur"] ?? "",
        news_date: json["news_date"] ?? "",
        news_image: json["news_image"] ?? "",
        news_source: json["news_source"] ?? "",
        news_time: json["news_time"] ?? "",
        news_sound: json["news_sound"] ?? "",
        news_category: json["news_category"] ?? "",
        news_url: json["news_url"] ?? "",
        news_words: json["news_words"] ?? [],
        news_comments: json["news_comments"] ?? []);
  }
}
