import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app_demo/controllers/forgetPasswordPageController.dart';

import 'package:news_app_demo/helpers/size.dart';
import 'package:news_app_demo/services/auth.dart';
import 'package:news_app_demo/theme/colors.dart';

class ForgetPasswordPage extends StatelessWidget {
  final forgetPasswordPageController = Get.put(ForgetPasswordPageController());

  ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildBackIcon(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5.h),
              child: SizedBox(
                  height: 30.h,
                  child: LottieBuilder.asset(
                      "assets/animations/forgetAnimation.json")),
            ),
            const Text(
              "Şifrenizi resetlemek için email adresinizi giriniz:",
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    color: white,
                    border: Border.all(color: blue, width: 2),
                    boxShadow: const [
                      BoxShadow(color: blue, offset: Offset(2, 2))
                    ],
                    borderRadius: BorderRadius.circular(25)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller:
                        forgetPasswordPageController.forgetPasswordController,
                    decoration: const InputDecoration(
                        border: InputBorder.none, labelText: "Email"),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.h,
              width: 60.w,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 3,
                      backgroundColor: blue,
                      side: const BorderSide(color: black, width: 1)),
                  onPressed: () async {
                    final result = await Auth().resetPasswordLink(
                        email: forgetPasswordPageController
                            .forgetPasswordController.text);
                    if (result == "success") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Email gönderildi. Lütfen email adresinizi kontrol ediniz"),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Get.back();
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: const Text("Hata"),
                            content: Text(result),
                          );
                        },
                      );
                    }
                  },
                  child: const Text(
                    "Gönder",
                    style: TextStyle(color: white),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Align _buildBackIcon() {
    return Align(
      alignment: Alignment.centerLeft,
      child: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios)),
    );
  }
}
