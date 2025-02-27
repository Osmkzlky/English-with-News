// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app_demo/controllers/newsContentPageController.dart';
import 'package:news_app_demo/helpers/size.dart';
import 'package:news_app_demo/model/News.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:news_app_demo/model/UserData.dart';
import 'package:news_app_demo/services/auth.dart';
import 'package:news_app_demo/services/firebase_service.dart';

import 'package:news_app_demo/theme/colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:news_app_demo/widgets/customTextField.dart';

class NewsContentPage extends StatefulWidget {
  final News news;

  NewsContentPage({
    Key? key,
    required this.news,
  }) : super(key: key);

  @override
  State<NewsContentPage> createState() => _NewsContentPageState();
}

class _NewsContentPageState extends State<NewsContentPage> {
  final newsContentPageController = Get.put(NewsContentPageController());

  StreamSubscription? stateSubscription;
  StreamSubscription? durationSubscription;
  StreamSubscription? positionSubscription;

  @override
  void initState() {
    super.initState();

    setupAudioPlayer();
  }

  void setupAudioPlayer() {
    // Ses çalar başlatma
    newsContentPageController.player.play(UrlSource(widget.news.news_sound));
    newsContentPageController.player.pause();

    // Player State dinleyici
    stateSubscription =
        newsContentPageController.player.onPlayerStateChanged.listen((state) {
      newsContentPageController.isPlaying.value = state == PlayerState.playing;
    });

    // Duration dinleyici
    durationSubscription = newsContentPageController.player.onDurationChanged
        .listen((newDuration) {
      if (mounted) {
        setState(() {
          newsContentPageController.duration = newDuration;
        });
      }
    });

    // Position dinleyici
    positionSubscription = newsContentPageController.player.onPositionChanged
        .listen((newPosition) {
      if (mounted) {
        setState(() {
          newsContentPageController.position = newPosition;
        });
      }
    });
  }

  @override
  void dispose() {
    // Dinleyici aboneliklerini iptal et
    stateSubscription?.cancel();
    durationSubscription?.cancel();
    positionSubscription?.cancel();

    // Ses çaları temizle
    newsContentPageController.player.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String firebaseTextTur =
        widget.news.news_contentTur; // Firebase'den gelen veri
    String formattedTextTur = firebaseTextTur.replaceAll(
        "\\", "\n\n"); // Çift ters çizgiyi yeni satıra dönüştürüyoruz
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverToBoxAdapter(
          child: Column(
            children: [
              Hero(
                  tag: widget.news.news_image,
                  child: Image.network(widget.news.news_image)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() => _buildCustomButton(
                      color: newsContentPageController.pageIndex.value == 0
                          ? Theme.of(context).colorScheme.primary
                          : white,
                      textColor: newsContentPageController.pageIndex.value == 0
                          ? white
                          : Colors.black54,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15)),
                      text: "Tur",
                      press: () {
                        newsContentPageController.updatePageIndex(0);
                      })),
                  SizedBox(
                      width: 40.w,
                      child: const Divider(
                        color: gray,
                      )),
                  Obx(() => _buildCustomButton(
                      color: newsContentPageController.pageIndex.value == 1
                          ? Theme.of(context).colorScheme.primary
                          : white,
                      textColor: newsContentPageController.pageIndex.value == 1
                          ? white
                          : Colors.black54,
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(15)),
                      text: "Eng",
                      press: () {
                        newsContentPageController.updatePageIndex(1);
                      })),
                ],
              ),
            ],
          ),
        ),
      ],
      body: PageView.builder(
          controller: newsContentPageController.pageController,
          itemCount: 2,
          onPageChanged: (value) {
            newsContentPageController.pageIndex.value = value;
          },
          itemBuilder: (context, index) => Container(
                margin: EdgeInsets.only(top: 1.h, left: 2.w, right: 2.w),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (index == 1) ...[
                        _buildTitleandDescription(
                            title: widget.news.news_titleEng,
                            sourceName: widget.news.news_source,
                            time: widget.news.news_time,
                            date: widget.news.news_date),
                        _buildWords(),
                        _buildListenNewsContent(context),
                        _buildTextNewsContent(
                            newsTitle: widget.news.news_titleEng,
                            newsContent: widget.news.news_contentEng),
                        _buildTranslate(),
                      ] else ...[
                        _buildTitleandDescription(
                            title: widget.news.news_titleTur,
                            sourceName: widget.news.news_source,
                            time: widget.news.news_time,
                            date: widget.news.news_date),
                        _buildTextNewsContent(
                            newsContent: widget.news.news_contentTur),
                        TextButton(
                            onPressed: () async {
                              String result = await newsContentPageController
                                  .launchURL(widget.news.news_url);
                              if (result != "success") {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(result),
                                    );
                                  },
                                );
                              }
                            },
                            child:
                                Text("Siteye Git (${widget.news.news_source})"))
                      ],
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Haber Hakkında Yorumlar",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Divider(
                              color: gray,
                            ),
                            SizedBox(
                                height: 30.h,
                                child: ListView.builder(
                                    padding: EdgeInsets.all(0),
                                    itemCount: widget.news.news_comments.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 1.h),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.w),
                                          decoration: BoxDecoration(
                                              border: Border.all(color: gray),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                          height: 12.h,
                                          child: Column(
                                            children: [
                                              Row(children: [
                                                Text(newsContentPageController
                                                    .maskName(widget.news
                                                            .news_comments[index]
                                                        ["comment_userName"])),
                                                Text(newsContentPageController
                                                    .maskName(widget.news
                                                            .news_comments[index]
                                                        [
                                                        "comment_userSurname"])),
                                                Spacer(),
                                                Text(widget.news
                                                        .news_comments[index]
                                                    ["comment_date"])
                                              ]),
                                              Text(widget
                                                      .news.news_comments[index]
                                                  ["comment_content"]),
                                            ],
                                          ));
                                    })),
                            const Divider(
                              color: gray,
                            ),
                          ],
                        ),
                      ),
                      StreamBuilder<UserData?>(
                          stream: Auth().getUserData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasData) {
                              UserData userData = snapshot.data!;
                              return Padding(
                                padding: EdgeInsets.only(bottom: 5.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Haber Hakkındaki Düşüncen Nedir?",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const Divider(
                                      color: gray,
                                    ),
                                    TextField(
                                      maxLength: 200,
                                      controller: newsContentPageController
                                          .commentController,
                                      maxLines: 5,
                                      decoration: const InputDecoration(
                                          hintText: "Yorum...",
                                          hintStyle: TextStyle(
                                              fontWeight: FontWeight.normal),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(12)),
                                              borderSide:
                                                  BorderSide(color: gray))),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: TextButton(
                                          onPressed: () async {
                                            final result = await FirebaseService()
                                                .addNewsCommmet(
                                                    news_id:
                                                        widget.news.news_id,
                                                    comment_userName:
                                                        userData.name,
                                                    comment_userSurname:
                                                        userData.surname,
                                                    comment_content:
                                                        newsContentPageController
                                                            .commentController
                                                            .text);
                                            if (result == "success") {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      "Yorum Başarılı Bir Şekilde Eklendi"),
                                                  backgroundColor: Colors.green,
                                                ),
                                              );
                                              newsContentPageController
                                                  .commentController.text = "";
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
                                          },
                                          child: Text("Gönder")),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Text("Veri Bulunamadı");
                            }
                          }),
                    ],
                  ),
                ),
              )),
    ));
  }

  Widget _buildTitleandDescription(
      {required String title,
      required String sourceName,
      required String time,
      required String date}) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19.sp),
        ),
        Row(
          children: [
            Text(sourceName),
            const Spacer(),
            Text(time),
            const Text("-"),
            Text(date),
          ],
        ),
        SizedBox(height: 0.h),
      ],
    );
  }

  SizedBox _buildCustomDivider({required double width}) {
    return SizedBox(
      width: width,
      child: const Divider(
        color: black,
        thickness: 1.5,
      ),
    );
  }

  Widget _buildCustomButton(
      {required Color color,
      required String text,
      required Function press,
      required BorderRadiusGeometry borderRadius,
      required Color textColor}) {
    return GestureDetector(
      onTap: () {
        press();
      },
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 1.h),
          width: 5.h,
          height: 5.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).colorScheme.secondary,
                  offset: Offset(0, 2)),
            ],
            border: Border.all(
                color: Theme.of(context).colorScheme.secondary, width: 1.2),
            color: color,
          ),
          child: Center(
              child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ))),
    );
  }

  Widget _buildWords() {
    return Padding(
      padding: EdgeInsets.only(top: 5.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildCustomTextandDivider(
              title: "Vocabulary",
              rightText: "${widget.news.news_words.length.toString()} words",
              press: () {}),
          SizedBox(
              height: widget.news.news_words.length * 30.h,
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  itemCount: widget.news.news_words.length,
                  itemBuilder: (context, index) {
                    Map newsWord = widget.news.news_words[index];
                    return Container(
                      height: 30.h,
                      decoration: const BoxDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                newsWord["word_name"],
                                style: TextStyle(
                                    color: blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17.sp),
                              ),
                              IconButton(
                                  onPressed: () {
                                    newsContentPageController
                                        .speakEnglish(newsWord["word_name"]);
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.volumeHigh,
                                    size: 15.sp,
                                  )),
                              const Spacer(),
                              Text(
                                newsWord["word_type"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                          Text(newsWord["word_dictionary"]),
                          if (newsWord["word_example_sentences"].length >
                              1) ...[
                            const Align(
                                alignment: Alignment.center,
                                child: Icon(Icons.keyboard_arrow_up))
                          ],
                          SizedBox(
                            height: 14.h,
                            child: PageView.builder(
                                scrollDirection: Axis.vertical,
                                physics:
                                    newsWord["word_example_sentences"].length >
                                            1
                                        ? null
                                        : const NeverScrollableScrollPhysics(),
                                itemCount:
                                    newsWord["word_example_sentences"].length,
                                itemBuilder: (context, index) {
                                  String sentence =
                                      newsWord["word_example_sentences"][index]
                                          ["sentence_sentence"];
                                  String sentence_image =
                                      newsWord["word_example_sentences"][index]
                                          ["sentence_image"];
                                  return Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 1.w),
                                      height: 12.h,
                                      margin:
                                          EdgeInsets.symmetric(vertical: 1.h),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius:
                                              BorderRadius.circular(12)),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 60.w,
                                            child: Text(
                                              maxLines: 3,
                                              sentence,
                                              style: TextStyle(color: white),
                                            ),
                                          ),
                                          IconButton(
                                              onPressed: () {
                                                newsContentPageController
                                                    .speakEnglish(sentence);
                                              },
                                              icon: Icon(
                                                FontAwesomeIcons.volumeHigh,
                                                size: 15.sp,
                                                color: white,
                                              )),
                                          SizedBox(
                                            width: 20.w,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child:
                                                  Image.network(sentence_image),
                                            ),
                                          )
                                        ],
                                      ));
                                }),
                          ),
                          if (newsWord["word_example_sentences"].length >
                              1) ...[
                            const Align(
                                alignment: Alignment.center,
                                child: Icon(Icons.keyboard_arrow_down))
                          ],
                          const Divider(
                            color: gray,
                          )
                        ],
                      ),
                    );
                  })),
        ],
      ),
    );
  }

  Container _buildListenNewsContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          border: Border.all(
              color: Theme.of(context).colorScheme.secondary, width: 2),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.secondary,
                offset: Offset(2, 2))
          ],
          borderRadius: BorderRadius.circular(12)),
      height: 12.h,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(1.w, 0.w, 5.w, 0.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () async {
                      if (newsContentPageController.isPlaying.value)
                        await newsContentPageController.player.pause();
                      else {
                        await newsContentPageController.player
                            .play(UrlSource(widget.news.news_sound));
                      }
                    },
                    icon: FaIcon(newsContentPageController.isPlaying.value
                        ? FontAwesomeIcons.stop
                        : FontAwesomeIcons.play)),
                Column(
                  children: [
                    Text(
                      "Ai Generated Audio",
                      style: TextStyle(fontSize: 14.sp),
                    ),
                    RichText(
                        text:
                            TextSpan(style: TextStyle(color: black), children: [
                      TextSpan(
                          text: newsContentPageController.formatDuration(
                              newsContentPageController.position)),
                      TextSpan(
                          text:
                              " / ${newsContentPageController.formatDuration(newsContentPageController.duration)}")
                    ]))
                  ],
                ),
                IconButton(
                    onPressed: () async {
                      final position = newsContentPageController.position -
                          const Duration(seconds: 10);
                      await newsContentPageController.player.seek(position);
                    },
                    icon: const Icon(Icons.replay_10)),
                IconButton(
                    onPressed: () async {
                      final position = newsContentPageController.position +
                          const Duration(seconds: 10);
                      await newsContentPageController.player.seek(position);
                    },
                    icon: const Icon(Icons.forward_10)),
                GestureDetector(
                    onTap: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (_) => Container(
                          height: 30.h,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Expanded(
                                child: CupertinoPicker(
                                  scrollController: FixedExtentScrollController(
                                    initialItem:
                                        (newsContentPageController.speed.value *
                                                    10 -
                                                5)
                                            .toInt(),
                                  ),
                                  itemExtent: 35,
                                  onSelectedItemChanged: (index) {
                                    setState(() {
                                      newsContentPageController
                                          .speed.value = (index +
                                              5) /
                                          10; // 0.5x ile 2.0x arasında ayarlama.
                                      newsContentPageController.player
                                          .setPlaybackRate(
                                              newsContentPageController
                                                  .speed.value);
                                    });
                                  },
                                  children: List.generate(16, (index) {
                                    double speed =
                                        (index + 5) / 10; // 0.5x - 2.0x.
                                    return Center(
                                      child: Text(
                                        "${speed.toStringAsFixed(1)}x",
                                        style: const TextStyle(fontSize: 18),
                                      ),
                                    );
                                  }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Text("${newsContentPageController.speed.value}x"))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            child: Slider(
              activeColor: blue,
              inactiveColor: gray,
              thumbColor: blue,
              min: 0.0,
              max: newsContentPageController.duration.inSeconds.toDouble(),
              value: (newsContentPageController.position.inSeconds.toDouble())
                  .clamp(0.0,
                      newsContentPageController.duration.inSeconds.toDouble()),
              onChanged: (value) async {
                final position = Duration(seconds: value.toInt());
                await newsContentPageController.player.seek(position);
                await newsContentPageController.player.resume();
              },
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildTextNewsContent(
      {String? newsTitle, required String newsContent}) {
    String formattedText = newsContent.replaceAll(
        "\\", "\n\n"); // Çift ters çizgiyi yeni satıra dönüştür

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.h),
      child: RichText(
          text: TextSpan(style: const TextStyle(color: black), children: [
        TextSpan(
            text: "${newsTitle ?? ""} \n\n",
            style: Theme.of(context).textTheme.titleMedium),
        TextSpan(
            text: formattedText, style: Theme.of(context).textTheme.titleSmall)
      ])),
    );
  }

  Widget _buildTranslate() {
    return Padding(
      padding: EdgeInsets.only(top: 2.h),
      child: Column(
        children: [
          Obx(() => _buildCustomTextandDivider(
              title: "Translate",
              rightText: newsContentPageController.isEnglish.value
                  ? "Eng/Tur"
                  : "Tur/Eng",
              press: () {
                newsContentPageController.updateIsEnglish();
              })),
          Obx(() => CustomTextField(
                controller: newsContentPageController.isEnglish.value
                    ? newsContentPageController.englishController
                    : newsContentPageController.turkishController,
                otherController: newsContentPageController.isEnglish.value
                    ? newsContentPageController.turkishController
                    : newsContentPageController.englishController,
                readOnly: false,
                activeColor: Theme.of(context).colorScheme.secondaryContainer,
                labelText:
                    newsContentPageController.isEnglish.value ? "Eng" : "Tur",
                iconData: newsContentPageController.isEnglish.value
                    ? Icons.volume_up
                    : Icons.headphones,
              )),
          Obx(() => CustomTextField(
              controller: newsContentPageController.isEnglish.value
                  ? newsContentPageController.turkishController
                  : newsContentPageController.englishController,
              otherController: newsContentPageController.isEnglish.value
                  ? newsContentPageController.englishController
                  : newsContentPageController.turkishController,
              activeColor: Theme.of(context).colorScheme.secondaryContainer,
              readOnly: true,
              labelText:
                  newsContentPageController.isEnglish.value ? "Tur" : "Eng",
              iconData: newsContentPageController.isEnglish.value
                  ? Icons.headphones
                  : Icons.volume_up)),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 1.h),
              child: SizedBox(
                height: 5.h,
                width: 50.w,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(
                          color:
                              Theme.of(context).colorScheme.secondaryContainer,
                          width: 3),
                      backgroundColor: Theme.of(context).colorScheme.background,
                    ),
                    onPressed: () {
                      newsContentPageController.isEnglish.value
                          ? newsContentPageController.translateText(
                              newsContentPageController.englishController.text,
                              "tr")
                          : newsContentPageController.translateText(
                              newsContentPageController.turkishController.text,
                              "en");
                    },
                    child: Text(
                      "Çevir",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTextandDivider(
      {required String title,
      required String rightText,
      required Function press}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            GestureDetector(
                onTap: () {
                  press();
                },
                child: Text(
                  textAlign: TextAlign.center,
                  rightText,
                  style: TextStyle(
                    color: const Color(0xFF536E91),
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                  ),
                ))
          ],
        ),
        const Divider()
      ],
    );
  }
}
