// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app_demo/controllers/newsContentPageController.dart';
import 'package:news_app_demo/helpers/size.dart';
import 'package:news_app_demo/theme/colors.dart';

class CustomTextField extends StatelessWidget {
  final newsContentPageController = Get.put(NewsContentPageController());
  final TextEditingController controller;
  final TextEditingController otherController;
  final String labelText;
  final IconData iconData;
  final bool readOnly;
  final Color activeColor;
  CustomTextField({
    Key? key,
    required this.controller,
    required this.otherController,
    required this.labelText,
    required this.iconData,
    required this.readOnly,
    required this.activeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.secondary, width: 1),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.secondary,
                offset: Offset(2, 2))
          ],
          color: activeColor,
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              style: TextStyle(color: white),
              readOnly: readOnly,
              maxLines: 2,
              controller: controller,
              decoration: InputDecoration(
                  labelStyle:
                      TextStyle(color: white, fontWeight: FontWeight.bold),
                  border: InputBorder.none,
                  labelText: labelText),
            ),
          ),
          IconButton(
              onPressed: () async {
                if (iconData == Icons.volume_up) {
                  newsContentPageController.speakEnglish(controller.text);
                } else {
                  await newsContentPageController.speakTurkish(controller.text);

                  await newsContentPageController
                      .speakEnglish(otherController.text);
                }
              },
              icon: Icon(
                iconData,
                color: white,
              ))
        ],
      ),
    );
  }
}
