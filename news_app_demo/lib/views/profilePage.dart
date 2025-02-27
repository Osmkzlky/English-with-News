// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:news_app_demo/controllers/profilePageController.dart';
import 'package:news_app_demo/helpers/size.dart';

import 'package:news_app_demo/model/UserData.dart';
import 'package:news_app_demo/services/auth.dart';
import 'package:news_app_demo/theme/colors.dart';
import 'package:news_app_demo/views/forgetPasswordPage.dart';

class ProfilePage extends StatefulWidget {
  final UserData userData;
  ProfilePage({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final profilePageController = Get.put(ProfilePageController());
  @override
  void initState() {
    profilePageController.updateGenderIndex(int.parse(widget.userData.gender));
    profilePageController.phoneController.text = widget.userData.phone;
    profilePageController.nameController.text = widget.userData.name;
    profilePageController.surnameController.text = widget.userData.surname;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildBackIcon(),
              _buildUpdateProfile(),
              _buildContactInformation(),
              _buildPassword()
            ],
          ),
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
            icon: Icon(Icons.arrow_back_ios)));
  }

  Widget _buildUpdateProfile() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      height: 40.h,
      decoration: BoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Profil Bilgileri",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
          ),
          Text(
            "English with News deneyiminizi en iyi seviyede tutuabilmemiz için gereken bilgilerinizi buradan düzenleyebilirsiniz",
            style: TextStyle(fontSize: 15.sp),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: _buildTextField(
                      text: "Ad:",
                      controller: profilePageController.nameController)),
              Expanded(
                  child: _buildTextField(
                      text: "Soyad:",
                      controller: profilePageController.surnameController)),
            ],
          ),
          Text(
            "Cinsiyet:",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildGender(
                  key: 0,
                  text: "Kadın",
                  press: () {
                    profilePageController.updateGenderIndex(0);
                  }),
              _buildGender(
                  key: 1,
                  text: "Erkek",
                  press: () {
                    profilePageController.updateGenderIndex(1);
                  }),
              _buildGender(
                  key: 2,
                  text: "Belirtilmemiş",
                  press: () {
                    profilePageController.updateGenderIndex(2);
                  }),
            ],
          ),
          _buildElevatedButton(press: () async {
            final result = await Auth().updateNameSurnameandGender(
                name: profilePageController.nameController.text,
                surname: profilePageController.surnameController.text,
                gender: profilePageController.genderIndex.value.toString());
            if (result == "success") {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Kişisel Bilgiler Değiştirildi"),
                  backgroundColor: Colors.green,
                ),
              );
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
          })
        ],
      ),
    );
  }

  Widget _buildContactInformation() {
    return Container(
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "İletişim Bilgileri",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
          ),
          Text(
            "Telefon numarasını değiştirmek için numaranızı doğrulamanızı isteyeceğiz.",
            style: TextStyle(fontSize: 15.sp),
          ),
          _buildTextField(
            text: "Cep Telefonu Numarası ",
            controller: profilePageController.phoneController,
            textInputFormatter: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10)
            ],
          ),
          _buildElevatedButton(press: () async {
            final result = await Auth()
                .updatePhone(phone: profilePageController.phoneController.text);
            if (result == "success") {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Cep telefon numarası değiştirildi"),
                  backgroundColor: Colors.green,
                ),
              );
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
          })
        ],
      ),
    );
  }

  Widget _buildElevatedButton({required Function press}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          onPressed: () {
            press();
          },
          child: const Text(
            "Güncelle",
            style: TextStyle(color: blue, fontWeight: FontWeight.bold),
          )),
    );
  }

  Widget _buildGender(
      {required String text, required Function press, required int key}) {
    return GestureDetector(
      onTap: () {
        press();
      },
      child: Obx(() => Row(
            children: [
              Container(
                height: 24,
                width: 24,
                decoration: BoxDecoration(
                    color: profilePageController.genderIndex.value == key
                        ? blue
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: gray)),
              ),
              Text(text),
            ],
          )),
    );
  }

  Widget _buildTextField(
      {required String text,
      required TextEditingController controller,
      TextInputType keyboardType = TextInputType.text,
      bool obscureText = false,
      List<TextInputFormatter>? textInputFormatter}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 1.w),
      child: DecoratedBox(
        decoration: BoxDecoration(
            border: Border.all(color: gray, width: 2),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: TextField(
            inputFormatters: textInputFormatter,
            obscureText: obscureText,
            keyboardType: keyboardType,
            controller: controller,
            style: TextStyle(fontSize: 15.sp),
            decoration:
                InputDecoration(border: InputBorder.none, labelText: text),
          ),
        ),
      ),
    );
  }

  Widget _buildPassword() {
    return Container(
      height: 40.h,
      margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Şifre Bilgileri",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.sp),
          ),
          const Text(
              "Şifreniz en az bir harf, rakam veya özel karakter içermeli. Ayrıca şifreniniz en az 6 karakterden oluşmalı"),
          _buildTextField(
              obscureText: true,
              text: "Yeni Şifre",
              controller: profilePageController.passwordController),
          _buildTextField(
              obscureText: true,
              text: "Yeni Şifre Tekrar",
              controller: profilePageController.passwordAgainController),
          TextButton(
              onPressed: () {
                Get.to(ForgetPasswordPage());
              },
              child: Text("Şifremi Unuttum")),
          _buildElevatedButton(press: () async {
            if (profilePageController.passwordControllerFun()) {
              final result = await Auth().changePassword(
                  profilePageController.passwordAgainController.text);
              if (result == "success") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Şifre başarılı bir şekilde değiştirildi"),
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
                      content: Text(result ?? " "),
                    );
                  },
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Şifreler Uyuşmuyor"),
                  backgroundColor: Colors.red,
                ),
              );
            }
          })
        ],
      ),
    );
  }
}
