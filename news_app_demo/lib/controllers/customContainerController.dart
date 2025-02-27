import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CustomContainerController extends GetxController {
  /// Tarih ve saat farkını hesaplayan fonksiyon
  String calculateTimeDifference(
      {required String dbDate, required String dbTime}) {
    // Şu anki tarih ve saat
    DateTime now = DateTime.now();

    // Veritabanındaki tarih ve saat ile birleştirilmiş tam tarih oluşturma
    DateTime dbDateTime =
        DateFormat("dd/MM/yyyy HH:mm").parse("$dbDate $dbTime");

    // İki tarih arasındaki farkı hesaplama
    Duration difference = now.difference(dbDateTime);

    // Farkı uygun formatta döndürme
    if (difference.isNegative) {
      // Gelecekteki tarih için
      return "Bu tarih ${difference.abs().inDays} gün sonra.";
    } else {
      // Geçmiş tarih için
      if (difference.inDays > 0) {
        return "${difference.inDays} days ago";
      } else if (difference.inHours > 0) {
        return "${difference.inHours} hours ago";
      } else if (difference.inMinutes > 0) {
        return "${difference.inMinutes} minutes ago";
      } else {
        return "Just now";
      }
    }
  }

  RxBool isFavorite = false.obs;
  void changeFavotire() {
    isFavorite.value = !isFavorite.value;
  }
}
