// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:news_app_demo/controllers/profilePhotoPageController.dart';
import 'package:news_app_demo/helpers/size.dart';
import 'package:news_app_demo/model/UserData.dart';
import 'package:news_app_demo/services/auth.dart';
import 'package:news_app_demo/theme/colors.dart';

class ProfilePhotoPage extends StatefulWidget {
  final UserData userData;

  const ProfilePhotoPage({
    Key? key,
    required this.userData,
  }) : super(key: key);

  @override
  State<ProfilePhotoPage> createState() => _ProfilePhotoPageState();
}

class _ProfilePhotoPageState extends State<ProfilePhotoPage> {
  final profilePhotoPageController = Get.put(ProfilePhotoPageController());
  @override
  void initState() {
    profilePhotoPageController.colorIndex.value =
        widget.userData.profileColorIndex;
    profilePhotoPageController.imageIndex.value =
        widget.userData.profileImageIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Column(children: [
            Obx(() => Container(
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
                          color: profilePhotoPageController.colorList[
                              profilePhotoPageController.colorIndex.value],
                          blurRadius: 4)
                    ]),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: profilePhotoPageController
                        .colorList[profilePhotoPageController.colorIndex.value],
                    border: Border.all(color: white, width: 2),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Image.asset(
                      profilePhotoPageController.imageList[
                          profilePhotoPageController.imageIndex.value],
                      fit: BoxFit.contain,
                      height: double.infinity,
                    ),
                  ),
                ))),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: Text(
                widget.userData.name + " " + widget.userData.surname,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            const Text("Background Color"),
            SizedBox(width: 30.w, child: const Divider()),
            SizedBox(
                height: 10.h,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: profilePhotoPageController.colorList.length,
                    itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          profilePhotoPageController.updateColorIndex(index);
                        },
                        child: Obx(() => Container(
                              margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                              height: 5.h,
                              width: 5.h,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: profilePhotoPageController
                                                  .colorIndex.value ==
                                              index
                                          ? black
                                          : Colors.transparent,
                                      width: 4),
                                  shape: BoxShape.circle,
                                  color: profilePhotoPageController
                                      .colorList[index]),
                            ))))),
            const Text("Character"),
            SizedBox(width: 30.w, child: const Divider()),
            SizedBox(
              height: 40.h,
              child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: profilePhotoPageController.imageList.length,
                  itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        profilePhotoPageController.updateImageIndex(index);
                      },
                      child: Obx(
                        () => Container(
                            margin: EdgeInsets.all(4),
                            padding: EdgeInsets.all(10),
                            height: 2.h,
                            decoration: BoxDecoration(
                                border: Border.all(color: gray, width: 3),
                                shape: BoxShape.circle),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 15.h,
                                  child: Image.asset(profilePhotoPageController
                                      .imageList[index]),
                                ),
                                Center(
                                    child: profilePhotoPageController
                                                .imageIndex.value ==
                                            index
                                        ? Icon(
                                            FontAwesomeIcons.check,
                                            size: 30.sp,
                                            color: black,
                                          )
                                        : null)
                              ],
                            )),
                      ))),
            )
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back_ios)),
              IconButton(
                  onPressed: () {
                    Auth().changeProfileCharacterColor(
                        colorIndex: profilePhotoPageController.colorIndex.value,
                        imageIndex:
                            profilePhotoPageController.imageIndex.value);
                    Get.back();
                  },
                  icon: const Icon(Icons.check))
            ],
          ),
        ],
      ),
    ));
  }
}
