import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:news_app_demo/controllers/profilePhotoPageController.dart';
import 'package:news_app_demo/helpers/size.dart';
import 'package:news_app_demo/model/UserData.dart';
import 'package:news_app_demo/services/auth.dart';
import 'package:news_app_demo/theme/colors.dart';
import 'package:news_app_demo/views/myFavoritePage.dart';
import 'package:news_app_demo/views/profilePage.dart';
import 'package:news_app_demo/views/profilePhotoPage.dart';

class SettingPage extends StatelessWidget {
  final profilePhotoPageController = Get.put(ProfilePhotoPageController());
  SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<UserData?>(
          stream: Auth().getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              UserData userData = snapshot.data!;
              return SafeArea(
                child: Column(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Get.to(ProfilePhotoPage(
                            userData: userData,
                          ));
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(vertical: 1.h),
                            padding: EdgeInsets.all(1.w),
                            height: 15.h,
                            width: 15.h,
                            decoration: BoxDecoration(
                                color: white,
                                border: Border.all(color: white, width: 1),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color:
                                          profilePhotoPageController.colorList[
                                              userData.profileColorIndex],
                                      blurRadius: 4)
                                ]),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: profilePhotoPageController
                                    .colorList[userData.profileColorIndex],
                                border: Border.all(color: white, width: 2),
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Image.asset(
                                  profilePhotoPageController
                                      .imageList[userData.profileImageIndex],
                                  fit: BoxFit.contain,
                                  height: double.infinity,
                                ),
                              ),
                            ))),
                    Text(
                      "${userData.name} ${userData.surname}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    _buildCustomButton(
                        text: "My Information",
                        icon: FontAwesomeIcons.circleInfo,
                        press: () {
                          Get.to(ProfilePage(userData: userData));
                        }),
                    _buildCustomButton(
                      text: "Night Mode",
                      icon: FontAwesomeIcons.solidMoon,
                      press: () {
                        Get.isDarkMode
                            ? Get.changeTheme(ThemeData.light())
                            : Get.changeTheme(ThemeData.dark());
                      },
                    ),
                    _buildCustomButton(
                      text: "My Favorites",
                      icon: FontAwesomeIcons.solidHeart,
                      press: () {
                        Get.to(MyFavoritePage(
                          myFavoriteList: userData.favoriteNewsId,
                        ));
                      },
                    ),
                    _buildCustomButton(
                        text: "Font Size",
                        press: () {},
                        icon: FontAwesomeIcons.font),
                    _buildCustomButton(
                        text: "Language",
                        press: () {},
                        icon: FontAwesomeIcons.language),
                  ],
                ),
              );
            } else {
              return const Text("Veri Bulunamadı");
            }
          }),
    );
  }

  Widget _buildCustomButton(
      {required String text, required Function press, required IconData icon}) {
    return GestureDetector(
      onTap: () {
        press();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.5.h),
        height: 7.h,
        decoration: BoxDecoration(
            border: Border.all(color: blue, width: 2),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(
              icon,
              color: blue,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              color: blue,
            )
          ],
        ),
      ),
    );
  }
}
