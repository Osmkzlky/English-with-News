// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:news_app_demo/components/customContainer.dart';
import 'package:news_app_demo/model/News.dart';
import 'package:news_app_demo/services/firebase_service.dart';

import 'package:news_app_demo/theme/colors.dart';

class MyFavoritePage extends StatelessWidget {
  final List myFavoriteList;
  const MyFavoritePage({
    Key? key,
    required this.myFavoriteList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Beğendiğim Haberler",
              style: TextStyle(color: white, fontWeight: FontWeight.bold)),
        ),
        body: StreamBuilder<List<News>>(
            stream: FirebaseService().getAllNews(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData) {
                List<News> newsList = snapshot.data!;

                return ListView.builder(
                    itemCount: myFavoriteList.length,
                    itemBuilder: (context, index) {
                      return Container(
                          decoration: const BoxDecoration(),
                          child: CustomContainer(news: newsList[index]));
                    });
              } else {
                return Text("Veri Bulunamadı");
              }
            }));
  }
}
