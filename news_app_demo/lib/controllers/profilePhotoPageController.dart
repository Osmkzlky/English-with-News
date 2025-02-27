import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePhotoPageController extends GetxController {
  List<String> imageList = [
    "assets/ai/ai_bear.png",
    "assets/ai/ai_donkey.png",
    "assets/ai/ai_rabbit.png",
    "assets/ai/ai_snake.png",
    "assets/ai/eagle.png",
    "assets/ai/tiger2.png",
    "assets/ai/tiger3.png",
    "assets/ai/tiger4.png",
    "assets/ai/tiger5.png",
    "assets/ai/tiger6.png",
    "assets/ai/tiger7.png",
    "assets/ai/tiger8.png",
    "assets/ai/tiger9.png",
    "assets/ai/tiger10.png",
    "assets/ai/tiger11.png",
    "assets/ai/tiger12.png",
    "assets/ai/tiger13.png",
    "assets/ai/tiger14.png",
    "assets/ai/tiger15.png",
    "assets/ai/tiger16.png",
    "assets/ai/tiger17.png",
    "assets/ai/tiger18.png",
    "assets/ai/tiger19.png",
  ];
  RxInt imageIndex = 0.obs;
  void updateImageIndex(int index) {
    imageIndex.value = index;
  }

  List<Color> colorList = [
    Color(0xFF3D82AE), // Mavi ton
    Color(0xFF942903), // Kırmızı ton

    Color(0xFF16A085), // Turkuaz ton
    Color(0xFF2ECC71), // Yeşil ton
    Color(0xFF3498DB), // Açık mavi ton
    Color(0xFFE74C3C), // Canlı kırmızı ton
    Color(0xFFF1C40F), // Sarı ton
    Color(0xFF8E44AD), // Mor ton
    Color(0xFF34495E), // Koyu gri-mavi ton
  ];
  RxInt colorIndex = 0.obs;
  void updateColorIndex(int index) {
    colorIndex.value = index;
  }
}
