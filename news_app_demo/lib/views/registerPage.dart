// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app_demo/controllers/registerPageController.dart';
import 'package:intl/intl.dart';
import 'package:news_app_demo/helpers/size.dart';
import 'package:news_app_demo/theme/colors.dart';

class RegisterPage extends StatefulWidget {
  final Function press;
  final bool isWithGoogle;
  RegisterPage({
    Key? key,
    required this.press,
    required this.isWithGoogle,
  }) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final registerPageController = Get.put(RegisterPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: white,
        body: SingleChildScrollView(
          child: Form(
            key: registerPageController.formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: SafeArea(
                child: Column(
                  children: [
                    _buildBackIcon(),
                    _buildAnimation(),
                    _buildText(text: "İletişim Bilgileri"),
                    _buildTextField(
                        labelText: "İsminiz",
                        controller: registerPageController.nameController,
                        press: () {}),
                    _buildTextField(
                        labelText: "Soyadınız",
                        controller: registerPageController.surnameController,
                        press: () {}),
                    _buildTextField(
                        controller: registerPageController.birthdayController,
                        labelText: "Doğum Tarihinizi Giriniz",
                        readOnly: true,
                        press: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (_) => Container(
                              height: 30.h,
                              color: white,
                              child: CupertinoDatePicker(
                                maximumDate: DateTime.now(),
                                initialDateTime: DateTime(2000),
                                mode: CupertinoDatePickerMode.date,
                                onDateTimeChanged: (DateTime newDate) {
                                  setState(() {
                                    registerPageController
                                            .birthdayController.text =
                                        DateFormat('dd/MM/yyyy')
                                            .format(newDate);
                                  });
                                },
                              ),
                            ),
                          );
                        }),
                    if (!widget.isWithGoogle) ...[
                      _buildText(text: "Uygulama Bilgileri"),
                      _buildTextField(
                          controller: registerPageController.emailController,
                          labelText: "Email",
                          press: () {}),
                      _buildTextField(
                          controller: registerPageController.passwordController,
                          labelText: "Şifreniz",
                          isObscureText: true,
                          press: () {}),
                      _buildTextField(
                          controller:
                              registerPageController.againPasswordController,
                          labelText: "Şifrenizi Tekrar Giriniz",
                          isObscureText: true,
                          press: () {}),
                    ],
                    _buildSaveButton()
                  ],
                ),
              ),
            ),
          ),
        ));
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

  SizedBox _buildAnimation() {
    return SizedBox(
        height: 30.h,
        child: Center(
            child: LottieBuilder.asset(
                "assets/animations/registerAnimation.json")));
  }

  Widget _buildText({required String text}) {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16.sp, color: black),
          ),
          const Divider(
            color: gray,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String labelText,
      bool isObscureText = false,
      required Function press,
      bool readOnly = false}) {
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
            style: TextStyle(color: black),
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
            onTap: () {
              press();
            },
            readOnly: readOnly,
            decoration: InputDecoration(
                labelText: labelText,
                border: InputBorder.none,
                labelStyle: TextStyle(
                    color: blue, fontWeight: FontWeight.bold, fontSize: 15.sp)),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 4.h, 0, 6.h),
      child: SizedBox(
        width: double.infinity,
        height: 6.h,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 1,
                backgroundColor: blue,
                side: const BorderSide(color: black, width: 2)),
            onPressed: () {
              widget.press();
            },
            child: Text(
              "Kaydet",
              style: TextStyle(
                  color: white, fontWeight: FontWeight.bold, fontSize: 17.sp),
            )),
      ),
    );
  }
}
