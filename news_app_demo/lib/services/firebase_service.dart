import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:news_app_demo/model/Advertisement.dart';
import 'package:news_app_demo/model/BannerData.dart';
import 'package:news_app_demo/model/News.dart';

class FirebaseService {
  final newsCol = FirebaseFirestore.instance.collection("news");
  Stream<List<News>> getAllNews() {
    try {
      return newsCol.snapshots().map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return News.fromJson(data);
        }).toList();
      });
    } catch (e) {
      print(e);
      return Stream.value([]);
    }
  }

  final bannerCol = FirebaseFirestore.instance.collection("banners");
  Stream<List<BannerData>> getBanners() {
    return bannerCol.doc("4I8nO88JrKDJEwzxqNZK").snapshots().map((snapshot) {
      if (snapshot.exists) {
        final bannerDoc = snapshot.data();
        if (bannerDoc != null) {
          List bannersData = bannerDoc["bannerList"] ?? [];
          return bannersData.map<BannerData>((bannerData) {
            return BannerData.fromJson(bannerData);
          }).toList();
        }
      }
      return <BannerData>[];
    });
  }

  final advertisementCol =
      FirebaseFirestore.instance.collection("advertisements");
  Stream<List<Advertisement>> getAdvertisement() {
    return advertisementCol
        .doc("ly1UUOHlpMXg7ppIMGNr")
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final advertisementDoc = snapshot.data();
        if (advertisementDoc != null) {
          List advertisementList = advertisementDoc["advertisementList"] ?? [];
          return advertisementList.map<Advertisement>((advertisement) {
            return Advertisement.fromJson(advertisement);
          }).toList();
        }
      }
      return <Advertisement>[];
    });
  }

  Future<String> addNewsCommmet({
    required String news_id,
    required String comment_userName,
    required String comment_userSurname,
    required String comment_content,
  }) async {
    try {
      Map<String, dynamic> addCommentMap = {};
      if (comment_content.isEmpty) {
        return "Lütfen bir yorum yazınız";
      }
      addCommentMap["comment_userName"] = comment_userName;
      addCommentMap["comment_userSurname"] = comment_userSurname;
      addCommentMap["comment_content"] = comment_content;
      addCommentMap["comment_date"] =
          DateFormat("dd/MM/yyyy").format(DateTime.now());
      await newsCol.doc(news_id).update({
        "news_comments": FieldValue.arrayUnion([addCommentMap])
      });

      return "success";
    } catch (e) {
      return "Bir hata oluştu $e";
    }
  }
}
