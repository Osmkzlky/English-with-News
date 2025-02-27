import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:news_app_demo/components/customContainer.dart';
import 'package:news_app_demo/controllers/homePageController.dart';
import 'package:news_app_demo/controllers/profilePhotoPageController.dart';
import 'dart:math';
import 'package:news_app_demo/helpers/size.dart';
import 'package:news_app_demo/model/Advertisement.dart';
import 'package:news_app_demo/model/BannerData.dart';
import 'package:news_app_demo/model/News.dart';
import 'package:news_app_demo/model/UserData.dart';
import 'package:news_app_demo/services/auth.dart';
import 'package:news_app_demo/services/firebase_service.dart';
import 'package:news_app_demo/theme/colors.dart';
import 'package:news_app_demo/views/newsContentPage.dart';
import 'package:news_app_demo/views/settingPage.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homePageController = Get.put(Homepagecontroller());
  final profilePhotoPageController = Get.put(ProfilePhotoPageController());
  @override
  void initState() {
    homePageController.bannerAnimation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text(
          "English with News",
          style: TextStyle(color: white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              FontAwesomeIcons.list,
              color: white,
            )),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(SettingPage());
            },
            child: StreamBuilder<UserData?>(
                stream: Auth().getUserData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    UserData userData = snapshot.data!;
                    return Container(
                        padding: const EdgeInsets.all(1),
                        margin: EdgeInsets.symmetric(horizontal: 2.w),
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: profilePhotoPageController
                                      .colorList[userData.profileColorIndex],
                                  blurRadius: 3)
                            ],
                            color: white,
                            border: Border.all(color: white, width: 1),
                            shape: BoxShape.circle),
                        height: 5.h,
                        width: 5.h,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: profilePhotoPageController
                                  .colorList[userData.profileColorIndex]),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Image.asset(profilePhotoPageController
                                .imageList[userData.profileImageIndex]),
                          ),
                        ));
                  } else {
                    return const Text("Veri Bulunamadı");
                  }
                }),
          )
        ],
      ),
      body: Column(
        children: [
          _buildCategoryNames(),
          Expanded(
            child: PageView.builder(
              itemCount: 5,
              controller: homePageController.pageController,
              onPageChanged: (value) =>
                  homePageController.updatePageIndex(value),
              itemBuilder: (context, indexP) => StreamBuilder<List<News>>(
                  stream: FirebaseService().getAllNews(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasData) {
                      List<News> newsList = snapshot.data!;
                      List<News> categoryNewsList = [];
                      for (int i = 0; i < newsList.length; i++) {
                        if (indexP == 0) {
                          categoryNewsList.add(newsList[i]);
                        }
                        if (indexP == 1 &&
                            newsList[i].news_category == "science&technology") {
                          categoryNewsList.add(newsList[i]);
                        }
                        if (indexP == 2 &&
                            newsList[i].news_category == "healty") {
                          categoryNewsList.add(newsList[i]);
                        }
                        if (indexP == 3 &&
                            newsList[i].news_category == "economy&business") {
                          categoryNewsList.add(newsList[i]);
                        }
                        if (indexP == 4 &&
                            newsList[i].news_category == "travel&lifestyle") {
                          categoryNewsList.add(newsList[i]);
                        }
                        final DateFormat dateFormat =
                            DateFormat("dd/MM/yyyy HH:mm");

                        categoryNewsList.sort((a, b) {
                          final String dateTimeAString =
                              "${a.news_date} ${a.news_time}";
                          final String dateTimeBString =
                              "${b.news_date} ${b.news_time}";

                          final DateTime dateTimeA =
                              dateFormat.parse(dateTimeAString);
                          final DateTime dateTimeB =
                              dateFormat.parse(dateTimeBString);

                          // Yeni haberi üste koymak için azalan sırada sıralayın
                          return dateTimeB.compareTo(dateTimeA);
                        });
                      }
                      return SingleChildScrollView(
                        child: Column(
                          children:
                              // Uzun Veri Olacağında ListView.buildera çevir
                              List.generate(categoryNewsList.length, (index) {
                            News news = categoryNewsList[index];
                            return Column(
                              children: [
                                if (index != 0 && index % 2 == 0) ...[
                                  _buildAdvertisement()
                                ],
                                if (indexP == 0 && index == 0) ...[
                                  _buildBanner(newsList),
                                ],
                                CustomContainer(news: news),
                              ],
                            );
                          }),
                        ),
                      );
                    } else {
                      return const Text("Veri Bulunamadı");
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildBanner(List<News> newsList) {
    return SizedBox(
      height: 25.h,
      child: StreamBuilder<List<BannerData>>(
          stream: FirebaseService().getBanners(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              List<BannerData> bannerList = snapshot.data!;
              homePageController.numberOfBanner = bannerList.length;
              return PageView.builder(
                  controller: homePageController.pageControllerBanner,
                  scrollDirection: Axis.horizontal,
                  itemCount: bannerList.length,
                  itemBuilder: (context, index) {
                    BannerData bannerData = bannerList[index];

                    return GestureDetector(
                      onTap: () {
                        Get.to(NewsContentPage(
                            news: newsList[int.parse(bannerData.news_id)]));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 1.h),
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            SizedBox(
                                height: 25.h,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: Image.network(
                                    newsList[int.parse(bannerData.news_id)]
                                        .news_image,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                width: double.infinity,
                                height: 5.h,
                                child: DecoratedBox(
                                    decoration: const BoxDecoration(
                                        color: Colors.black45,
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(12),
                                            bottomRight: Radius.circular(12))),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 1.w),
                                      child: Text(
                                        newsList[int.parse(bannerData.news_id)]
                                            .news_titleEng,
                                        style: const TextStyle(color: white),
                                      ),
                                    )),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return const Text("Veri Bulunamadı");
            }
          }),
    );
  }

  StreamBuilder<List<Advertisement>> _buildAdvertisement() {
    return StreamBuilder<List<Advertisement>>(
        stream: FirebaseService().getAdvertisement(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            List<Advertisement> advertisementList = snapshot.data!;
            Random random = Random();
            int randomIndex = random.nextInt(advertisementList.length);
            Advertisement advertisement = advertisementList[randomIndex];
            return GestureDetector(
              onTap: () {
                homePageController.launchURL(advertisement.advertisement_link);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                height: 30.h,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12)),
                          child:
                              Image.network(advertisement.advertisement_image),
                        ),
                        const Text(
                          "Reklam",
                          style: TextStyle(
                            backgroundColor: gray,
                          ),
                        )
                      ],
                    ),
                    Text(
                      advertisement.advertisement_title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Text("Veri Bulunamadı");
          }
        });
  }

  Widget _buildCategoryNames() {
    return Column(
      children: [
        SizedBox(
            height: 6.h,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: homePageController.categoryNames.length,
                itemBuilder: (context, index) => Obx(
                      () => GestureDetector(
                        onTap: () async {
                          homePageController.changePageIndex(index);
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 1.w, vertical: 1.h),
                            padding: EdgeInsets.symmetric(horizontal: 2.w),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      offset: const Offset(2, 2))
                                ],
                                color:
                                    homePageController.pageIndex.value == index
                                        ? Theme.of(context).colorScheme.primary
                                        : white,
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    width: 1),
                                borderRadius: BorderRadius.circular(12)),
                            child: Center(
                                child: Text(
                              homePageController.categoryNames[index],
                              style: TextStyle(
                                  color: homePageController.pageIndex.value ==
                                          index
                                      ? white
                                      : black,
                                  fontWeight: FontWeight.bold),
                            ))),
                      ),
                    ))),
        SizedBox(
            height: 0.1.h,
            child: const Divider(
              color: gray,
              thickness: 2,
            )),
      ],
    );
  }
}
