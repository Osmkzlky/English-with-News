import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app_demo/controllers/loginPageController.dart';
import 'package:news_app_demo/controllers/registerPageController.dart';
import 'package:news_app_demo/helpers/size.dart';
import 'package:news_app_demo/services/auth.dart';
import 'package:news_app_demo/theme/colors.dart';
import 'package:news_app_demo/views/forgetPasswordPage.dart';
import 'package:news_app_demo/views/homePage.dart';
import 'package:news_app_demo/views/registerPage.dart';

class LoginPage extends StatelessWidget {
  final loginPageController = Get.put(LoginPageController());
  final registerPageController = Get.put(RegisterPageController());
  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: Form(
        key: loginPageController.formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAnimation(),
              _buildTextField(
                controller: loginPageController.emailController,
                hintText: "Email",
              ),
              _buildTextField(
                  controller: loginPageController.passwordController,
                  hintText: "Şifre",
                  isObscureText: true),
              _buildRememberMeandForgetPassword(),
              _customButton(
                  press: () {
                    loginPageController.rememberMe();
                    loginPageController.signIn(context);
                  },
                  text: "Giriş Yap",
                  backgroundColor: blue,
                  borderSideColor: black,
                  textColor: white,
                  fontSize: 17.sp),
              _buildText(),
              _customButton(
                  press: () async {
                    bool? isSaved = await Auth().loginWithGoogle();
                    if (isSaved != null) {
                      if (isSaved) {
                        Get.to(HomePage());
                      } else {
                        Get.to(RegisterPage(
                          press: () {
                            registerPageController.signUpWithGoogle(context);
                          },
                          isWithGoogle: true,
                        ));
                      }
                    }
                  },
                  text: "Google ile Giriş",
                  backgroundColor: darkWhite,
                  borderSideColor: blue,
                  textColor: blue,
                  icon: FontAwesomeIcons.google,
                  fontSize: 15.sp),
              _buildRegisterText(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimation() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: SizedBox(
          height: 20.h,
          child: LottieBuilder.asset("assets/animations/loginAnimation.json")),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isObscureText = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: white,
            border: Border.all(color: gray, width: 2),
            borderRadius: BorderRadius.circular(25),
            boxShadow: const [BoxShadow(color: black, offset: Offset(4, 4))]),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: TextFormField(
            style: TextStyle(
                color: black, fontWeight: FontWeight.bold, fontSize: 15.sp),
            controller: controller,
            validator: (value) {
              if (value!.isEmpty) {
                return "Bilgilerinizi Eksizsiz Giriniz";
              } else {
                return null;
              }
            },
            onSaved: (newValue) {
              controller.text = newValue!;
            },
            textInputAction: TextInputAction.next,
            obscureText: isObscureText,
            decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                hintStyle: TextStyle(
                    color: blue, fontWeight: FontWeight.bold, fontSize: 15.sp)),
          ),
        ),
      ),
    );
  }

  Widget _buildRememberMeandForgetPassword() {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              loginPageController.updateCheck();
            },
            child: Obx(() => Row(
                  children: [
                    Container(
                        height: 24,
                        width: 24,
                        decoration: BoxDecoration(
                            border: Border.all(color: gray),
                            shape: BoxShape.circle,
                            color: loginPageController.isCheck.value
                                ? blue
                                : white),
                        child: loginPageController.isCheck.value
                            ? const Icon(
                                Icons.check,
                                size: 15,
                                color: white,
                              )
                            : null),
                    const Text(
                      "  Beni Hatırla",
                      style: TextStyle(color: black),
                    )
                  ],
                )),
          ),
          TextButton(
              onPressed: () {
                Get.to(ForgetPasswordPage());
              },
              child: const Text(
                "Şifremi Unuttum",
                style: TextStyle(
                    color: blue,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ))
        ],
      ),
    );
  }

  Widget _customButton(
      {required Function press,
      required String text,
      required Color backgroundColor,
      required Color borderSideColor,
      required Color textColor,
      IconData? icon,
      required double fontSize}) {
    return SizedBox(
      height: 5.5.h,
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              elevation: 2,
              backgroundColor: backgroundColor,
              side: BorderSide(color: borderSideColor, width: 2)),
          onPressed: () {
            press();
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon),
              Text(
                text,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontSize: fontSize),
              ),
            ],
          )),
    );
  }

  SizedBox _buildText() {
    return SizedBox(
      height: 4.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Expanded(
                child: Divider(
              color: gray,
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: const Text(
                "ya da",
                style: TextStyle(color: black),
              ),
            ),
            const Expanded(
                child: Divider(
              color: gray,
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: RichText(
          text: TextSpan(children: [
        const TextSpan(text: "Hesabın yok mu?", style: TextStyle(color: black)),
        TextSpan(
            text: "Kayıt Ol!",
            style: const TextStyle(color: black, fontWeight: FontWeight.bold),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.to(RegisterPage(
                  press: () {
                    registerPageController.signUp(context);
                  },
                  isWithGoogle: false,
                ));
              })
      ])),
    );
  }
}
