import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class Homepagecontroller extends GetxController {
  List<String> categoryNames = [
    "All",
    "Science & Technology",
    "Healty",
    "Economy & Business",
    "Travel & Lifestyle",
  ];
  RxInt pageIndex = 0.obs;
  void updatePageIndex(int index) {
    pageIndex.value = index;
  }

  PageController pageController = PageController(initialPage: 0);
  void changePageIndex(int index) {
    pageController.animateToPage(index,
        duration: const Duration(seconds: 1),
        curve: Curves.fastEaseInToSlowEaseOut);
  }

  PageController pageControllerBanner = PageController(initialPage: 0);
  Timer? timer;
  int _currentPage = 1;
  int numberOfBanner = 0;
  int bannerPageIndex = 0;
  void bannerAnimation() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_currentPage < numberOfBanner - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (pageControllerBanner.hasClients) {
        pageControllerBanner.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<String> launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      return "success";
    } else {
      return "Siteye Ulaşılımıyor";
    }
  }
}
