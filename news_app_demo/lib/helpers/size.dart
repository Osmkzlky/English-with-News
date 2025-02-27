import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension SizerExtension on num {
  double get h => this * MediaQuery.of(Get.context!).size.height / 100;
  double get w => this * MediaQuery.of(Get.context!).size.width / 100;
  double get sp =>
      this *
      (((h + w) +
              (MediaQuery.of(Get.context!).devicePixelRatio *
                  MediaQuery.of(Get.context!).size.aspectRatio)) /
          2.08) /
      100;
  double ch(BuildContext context) =>
      this * MediaQuery.of(context).size.height / 100;
  double cw(BuildContext context) =>
      this * MediaQuery.of(context).size.width / 100;
  double csp(BuildContext context) =>
      this *
      (((ch(context) + cw(context)) +
              (MediaQuery.of(context).devicePixelRatio *
                  MediaQuery.of(context).size.aspectRatio)) /
          2.08) /
      100;
}
