import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app_demo/services/auth.dart';
import 'package:news_app_demo/theme/colors.dart';
import 'package:news_app_demo/views/homePage.dart';

class RegisterPageController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController againPasswordController = TextEditingController();
  bool checkPassword() {
    if (passwordController.text == againPasswordController.text) {
      return true;
    } else {
      return false;
    }
  }

  final formKey = GlobalKey<FormState>();
  Future<void> signUp(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (checkPassword()) {
        //counter
        final result = await Auth().signUp(
            id: "0",
            email: emailController.text,
            password: passwordController.text,
            name: nameController.text,
            surname: surnameController.text,
            birhtday: birthdayController.text,
            phone: "",
            gender: "2",
            profileImageIndex: 0,
            profileColorIndex: 0,
            favoriteNewsId: []);

        if (result == "success") {
          Future.delayed(const Duration(milliseconds: 500))
              .then((value) => Get.back());
          await ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: white,
              content: Text(
                "Kayıt Tamamlandı, Giriş Ekranına Yönlendiriliyor...",
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  color: blue,
                ),
              )));
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text("Hata"),
                content: Text(result ?? " "),
              );
            },
          );
        }
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const CupertinoAlertDialog(
              title: Text("Hata"),
              content: Text("Şifreler Uyuşmuyor. Kontrol et!"),
            );
          },
        );
      }
    }
  }

  Future<void> signUpWithGoogle(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      // counter
      final result = await Auth().singUpWithGoogle(
          id: "0",
          name: nameController.text,
          surname: surnameController.text,
          birhtday: birthdayController.text,
          phone: "",
          gender: "2",
          profileImageIndex: 0,
          profileColorIndex: 0,
          favoriteNewsId: []);
      if (result == "success") {
        Future.delayed(const Duration(milliseconds: 500))
            .then((value) => Get.to(HomePage()));
        await ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: white,
            content: Text(
              "Kayıt Tamamlandı, Anasayfaya Yönlendiriliyor...",
              style: TextStyle(fontWeight: FontWeight.bold, color: blue),
            )));
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text("Hata"),
              content: Text(result ?? " "),
            );
          },
        );
      }
    }
  }
}
