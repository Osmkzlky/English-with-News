// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:news_app_demo/controllers/customContainerController.dart';
import 'package:news_app_demo/helpers/size.dart';
import 'package:news_app_demo/model/News.dart';
import 'package:news_app_demo/model/UserData.dart';
import 'package:news_app_demo/services/auth.dart';
import 'package:news_app_demo/views/newsContentPage.dart';

class CustomContainer extends StatelessWidget {
  final customContainerController = Get.put(CustomContainerController());
  final News news;
  CustomContainer({
    Key? key,
    required this.news,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String differanceDate = customContainerController.calculateTimeDifference(
        dbDate: news.news_date, dbTime: news.news_time);
    return GestureDetector(
      onTap: () {
        Get.to(NewsContentPage(news: news));
      },
      child: StreamBuilder<UserData?>(
          stream: Auth().getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              UserData userData = snapshot.data!;
              for (int i = 0; i < userData.favoriteNewsId.length; i++) {
                customContainerController.isFavorite.value = false;

                if (news.news_id == userData.favoriteNewsId[i]) {
                  customContainerController.isFavorite.value = true;
                  break;
                }
              }
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                height: 32.h,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    SizedBox(
                        height: 20.h,
                        width: 90.w,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)),
                          child: Hero(
                            tag: news.news_image,
                            child: Image.network(
                              news.news_image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        )),
                    Text(
                        maxLines: 2,
                        news.news_titleEng,
                        style: Theme.of(context).textTheme.titleMedium),
                    Row(
                      children: [
                        Text(
                          "${news.news_source}﹒",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(differanceDate),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              customContainerController.changeFavotire();
                              if (customContainerController.isFavorite.value) {
                                Auth().removeFavoriteNewsId(
                                    news_id: news.news_id);
                              } else {
                                Auth().addFavoriteNewsId(news_id: news.news_id);
                              }
                            },
                            icon: Icon(
                              customContainerController.isFavorite.value
                                  ? FontAwesomeIcons.solidHeart
                                  : FontAwesomeIcons.heart,
                              size: 17.sp,
                              color: Colors.red,
                            ))
                      ],
                    ),
                  ],
                ),
              );
            } else {
              return Text("Veri Bulunamadı");
            }
          }),
    );
  }
}
