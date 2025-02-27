import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:news_app_demo/model/UserData.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signIn(
      {required String email, required String password}) async {
    String? res;
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        res = "Hesap bulunamadı";
      } else if (e.code == "wrong-password") {
        res = "Şifre yanlış";
      } else if (e.code == "invalid-email") {
        res = "Geçersiz e-posta adresi";
      } else if (e.code == "user-disabled") {
        res = "Kullanıcı hesabı devre dışı bırakılmış";
      } else if (e.code == "too-many-requests") {
        res = "Çok fazla istek yapıldı. Lütfen daha sonra tekrar deneyin.";
      } else if (e.code == "operation-not-allowed") {
        res = "E-posta/şifre girişi etkinleştirilmemiş";
      } else if (e.code == "network-request-failed") {
        res = "Ağ bağlantısı hatası";
      } else if (e.code == "weak-password") {
        res = "Şifre çok zayıf, en az 6 karakter olmalı";
      } else if (e.code == "invalid-credential") {
        res = "Geçersiz kimlik bilgileri";
      } else {
        res = "Bilinmeyen hata: ${e.message}";
      }
    } catch (e) {
      res = "Beklenmeyen bir hata oluştu";
    }
    return res;
  }

  Future<String?> signUp({
    required String id,
    required String email,
    required password,
    required String name,
    required String surname,
    required String birhtday,
    required String gender,
    required String phone,
    required int profileImageIndex,
    required int profileColorIndex,
    required List favoriteNewsId,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user!.uid;
      try {
        await _firestore.collection("users").doc(uid).set({
          "id": id,
          "name": name,
          "surname": surname,
          "birhtday": birhtday.toString(),
          "email": email,
          "gender": gender,
          "phone": phone,
          "profileImageIndex": profileImageIndex,
          "profileColorIndex": profileColorIndex,
          "favoriteNewsId": favoriteNewsId
        });
        print("Kullanıcı kaydı başarılı");
      } catch (e) {
        print(e);
      }
      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return "Bu e-posta adresi zaten kullanımda";
      } else if (e.code == "invalid-email") {
        return "Geçersiz e-posta adresi";
      } else if (e.code == "weak-password") {
        return "Şifre çok zayıf. En az 6 karakter kullanın";
      } else if (e.code == "operation-not-allowed") {
        return "E-posta/şifre kaydı etkinleştirilmemiş";
      } else if (e.code == "network-request-failed") {
        return "Ağ bağlantısı hatası";
      } else {
        return "Kayıt olurken bir hata oluştu: ${e.message}";
      }
    } catch (e) {
      return "Beklenmeyen bir hata oluştu:$e";
    }
  }

  Future<String?> singUpWithGoogle({
    required String id,
    required String name,
    required String surname,
    required String birhtday,
    required String gender,
    required String phone,
    required int profileImageIndex,
    required int profileColorIndex,
    required List favoriteNewsId,
  }) async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
      final userCredential = await _firebaseAuth.signInWithCredential(cred);
      final user = userCredential.user!;
      try {
        await _firestore.collection("users").doc(user.uid).set({
          "id": id,
          "name": name,
          "surname": surname,
          "birhtday": birhtday.toString(),
          "email": user.email,
          "gender": gender,
          "phone": phone,
          "profileImageIndex": profileImageIndex,
          "profileColorIndex": profileColorIndex,
          "favoriteNewsId": favoriteNewsId
        });
        print("Kayıt Başarılı");
      } catch (e) {
        print(e);
      }
      return "success";
    } catch (e) {
      "Beklenmeyen bir hata oldu ${e}";
    }
  }

  Future<bool?> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
      final userCredential = await _firebaseAuth.signInWithCredential(cred);
      final user = userCredential.user;
      if (user != null) {
        final userData =
            await _firestore.collection("users").doc(user.uid).get();
        if (userData.exists) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Stream<UserData?> getUserData() {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      String uid = currentUser.uid;
      return _firestore
          .collection("users")
          .doc(uid)
          .snapshots()
          .map((snapshot) {
        return UserData.fromJson(snapshot.data() as Map<String, dynamic>);
      });
    } else {
      return Stream.value(null);
    }
  }

  Stream<List<UserData?>> getAllUserData() {
    return _firestore.collection("users").snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return UserData.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<String?> changePassword(String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await user.updatePassword(newPassword);
      }
      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        return "Şifre çok zayıf. En az 6 karakter kullanın";
      } else if (e.code == "requires-recent-login") {
        return "Oturum süreniz dolmuş. Lütfen yeniden giriş yapın.";
      } else if (e.code == "network-request-failed") {
        return "Ağ bağlantısı hatası";
      } else {
        return "Şifre değiştirilirken bir hata oluştu: ${e.message}";
      }
    } catch (e) {
      return "Beklenmeyen bir hata oluştu: $e";
    }
  }

  Future<String?> updatePhone({required String phone}) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        String uid = user.uid;

        // Geçerli telefon numarası doğrulaması
        if (phone.isEmpty ||
            phone.length < 10 ||
            phone[0] != "5" ||
            !RegExp(r'^\d+$').hasMatch(phone)) {
          return "Geçersiz telefon numarası";
        }

        // Firestore'da aynı telefon numarası zaten var mı kontrolü
        var existingPhoneCheck = await _firestore
            .collection("users")
            .where("phone", isEqualTo: phone)
            .get();

        if (existingPhoneCheck.docs.isNotEmpty) {
          return "Bu telefon numarası zaten kullanımda";
        }

        // Telefon numarasını güncelleme
        await _firestore.collection("users").doc(uid).update({
          "phone": phone,
        });

        return "success";
      } else {
        return "Kullanıcı oturum açmamış";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "network-request-failed") {
        return "Ağ bağlantısı hatası";
      } else {
        return "Kayıt olurken bir hata oluştu: ${e.message}";
      }
    } catch (e) {
      return "Beklenmeyen bir hata oluştu: $e";
    }
  }

  Future<String> updateNameSurnameandGender(
      {required String name,
      required String surname,
      required String gender}) async {
    try {
      if (name.isEmpty || surname.isEmpty || gender.isEmpty) {
        return "Tüm alanlar doldurulmalıdır.";
      }
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        String uid = user.uid;
        Map<String, dynamic> newData = {};
        newData["name"] = name;
        newData["surname"] = surname;
        newData["gender"] = gender;
        await _firestore.collection("users").doc(uid).update(newData);
      }
      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == "permission-denied") {
        return "Veritabanına erişim izni reddedildi.";
      } else if (e.code == "network-request-failed") {
        return "Ağ bağlantısı hatası.";
      } else {
        return "Firebase doğrulama hatası: ${e.message}";
      }
    } on FirebaseException catch (e) {
      return "Firebase işlemi sırasında hata oluştu: ${e.message}";
    } catch (e) {
      return "Beklenmeyen bir hata oluştu: $e";
    }
  }

  Future<String> resetPasswordLink({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return "success";
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        return "Bu e-posta adresiyle kayıtlı bir kullanıcı bulunamadı.";
      } else if (e.code == "invalid-email") {
        return "Geçersiz e-posta adresi.";
      } else if (e.code == "network-request-failed") {
        return "Ağ bağlantısı hatası. Lütfen tekrar deneyin.";
      } else {
        return "Şifre sıfırlama işlemi sırasında bir hata oluştu: ${e.message}";
      }
    } catch (e) {
      return "Beklenmeyen bir hata oluştu: $e";
    }
  }

  Future<void> changeProfileCharacterColor(
      {required int colorIndex, required int imageIndex}) async {
    try {
      User? user = _firebaseAuth.currentUser;

      if (user != null) {
        String uid = user.uid;
        Map<String, dynamic> newData = {};
        newData["profileColorIndex"] = colorIndex;
        newData["profileImageIndex"] = imageIndex;
        await _firestore.collection("users").doc(uid).update(newData);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> addFavoriteNewsId({required String news_id}) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        String uid = user.uid;
        await _firestore.collection("users").doc(uid).update({
          "favoriteNewsId": FieldValue.arrayUnion([news_id])
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> removeFavoriteNewsId({required String news_id}) async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        String uid = user.uid;
        await _firestore.collection("users").doc(uid).update({
          "favoriteNewsId": FieldValue.arrayRemove([news_id])
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
