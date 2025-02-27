import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsContentPageController extends GetxController {
  FlutterTts flutterTts = FlutterTts();

  Future speakEnglish(String text) async {
    await flutterTts.setLanguage("en-Us"); // İngilizce dil desteği
    await flutterTts.setSpeechRate(0.52); // Konuşma hızı
    await flutterTts.setVolume(1.0); // Ses seviyesi
    await flutterTts.setPitch(1.0); // Ses tonu
    await flutterTts.speak(text); // Metni seslendirme
  }

  Future<void> speakTurkish(String text) async {
    await flutterTts.stop(); // Önceki konuşmayı durdur
    await flutterTts.setLanguage("tr-TR");
    await flutterTts.setSpeechRate(0.60);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await Future.delayed(
        const Duration(milliseconds: 200)); // Kısa bir gecikme ekle
    await flutterTts.speak(text);
    await flutterTts.awaitSpeakCompletion(true); // Konuşmanın bitmesini bekle
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0'); // Sıfır doldurma
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  final player = AudioPlayer();
  RxBool isPlaying = false.obs;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  RxDouble speed = 1.0.obs;

  TextEditingController englishController = TextEditingController();
  TextEditingController turkishController = TextEditingController();
  RxBool isEnglish = false.obs;
  void updateIsEnglish() {
    isEnglish.value = !isEnglish.value;
  }

  final translator = GoogleTranslator();
  void translateText(String text, String type) async {
    var translatedWord = await translator.translate(text, to: type);
    if (type == "tr") {
      turkishController.text = translatedWord.text;
    } else {
      englishController.text = translatedWord.text;
    }
  }

  RxInt pageIndex = 0.obs;

  PageController pageController = PageController(initialPage: 0);
  void updatePageIndex(int index) {
    pageIndex.value = index;
    pageController.animateToPage(index,
        duration: Duration(seconds: 1), curve: Curves.fastEaseInToSlowEaseOut);
  }

  String maskName(String text) {
    if (text.isEmpty) return "";
    return text[0] + '*' * (text.length - 1);
  }

  TextEditingController commentController = TextEditingController();

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
