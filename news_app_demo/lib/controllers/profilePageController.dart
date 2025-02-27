import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfilePageController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();
  bool passwordControllerFun() {
    if (passwordController.text == passwordAgainController.text) {
      return true;
    }

    return false;
  }

  RxInt genderIndex = 2.obs;
  void updateGenderIndex(int value) {
    genderIndex.value = value;
  }
}
