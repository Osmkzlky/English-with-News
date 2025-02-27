import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app_demo/services/auth.dart';
import 'package:news_app_demo/views/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPageController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isCheck = false.obs;
  void updateCheck() {
    isCheck.value = !isCheck.value;
  }

  void rememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("rememberMe", isCheck.value);
    print(prefs.getBool("rememberMe"));
  }

  void saveUserToDevice() async {
    final pref = await SharedPreferences.getInstance();
    if (pref.getBool("rememberMe") == true) {
      pref.setString("email", emailController.text);
      pref.setString("password", passwordController.text);
      print("mail ve şifre cihaz hafızasına kayıt edildi");
    } else {
      print("cihaz kayıt hatası");
    }
  }

  @override
  void onInit() async {
    final prefs = await SharedPreferences.getInstance();
    isCheck.value = prefs.getBool("rememberMe") ?? false;
    if (isCheck.value) {
      emailController.text = prefs.getString("email") ?? "";
      passwordController.text = prefs.getString("password") ?? "";
    }
    super.onInit();
  }

  final formKey = GlobalKey<FormState>();
  Future<void> signIn(BuildContext context) async {
    if (formKey.currentState!.validate()) ;
    formKey.currentState!.save();
    final result = await Auth()
        .signIn(email: emailController.text, password: passwordController.text);
    if (result == "success") {
      Future.delayed(const Duration(microseconds: 500))
          .then((value) => Get.to(HomePage()));
      saveUserToDevice();
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
