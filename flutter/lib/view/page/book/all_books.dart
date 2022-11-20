import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project/logic/api/my_api.dart';
import 'package:project/logic/models/get_book_info.dart';
import 'package:project/logic/services/theme.dart';
import 'package:project/view/components/text_widget.dart';
import 'package:project/view/page/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'detail_book.dart';

class AllBooks extends StatefulWidget {
  const AllBooks({super.key});

  @override
  State<AllBooks> createState() => _AllBooksState();
}

class _AllBooksState extends State<AllBooks> {
  var articles = <BookInfo>[];

  @override
  void initState() {
    _getArticles();
    super.initState();
  }

  _getArticles() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString("user");

    if (user != null) {
      var userInfo = jsonDecode(user);
      // debugPrint(userInfo);
    } else {
      debugPrint("no info");
    }
    await _initData();
  }

  _initData() async {
    await CallApi().getPublicData("allbook").then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        articles = list.map((model) => BookInfo.fromJson(model)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Material(
      child: Container(
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.02,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Get.isDarkMode ? Colors.white : Colors.black87,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.home_outlined,
                        color: Get.isDarkMode ? Colors.white : Colors.black87,
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Home()),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: SingleChildScrollView(
                  child: articles.isEmpty
                      ? const CircularProgressIndicator()
                      : Column(
                          children: articles.map(
                            (article) {
                              debugPrint(article.book_thumbnail.toString());
                              return GestureDetector(
                                onTap: () {
                                  Get.to(() => DetailBookPage(
                                      bookInfo: article, index: 0));
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  height: 250,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 35,
                                        child: Material(
                                          elevation: 0.0,
                                          child: Container(
                                            height: 180.0,
                                            width: width * 0.9,
                                            decoration: BoxDecoration(
                                              color: Get.isDarkMode
                                                  ? Colors.black12
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(0.0),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Get.isDarkMode
                                                      ? Colors.black
                                                          .withOpacity(0.4)
                                                      : Colors.grey
                                                          .withOpacity(0.5),
                                                  offset:
                                                      const Offset(0.0, 0.0),
                                                  blurRadius: 20.0,
                                                  spreadRadius: 4.0,
                                                )
                                              ],
                                            ),
                                            // child: Text("This is where your content goes")
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        left: 10,
                                        child: Card(
                                          elevation: 10.0,
                                          shadowColor: Get.isDarkMode
                                              ? darkGreyClr.withOpacity(0.3)
                                              : Colors.grey.withOpacity(0.8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: Container(
                                            height: 200,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image:
                                                    CachedNetworkImageProvider(
                                                  "http://10.0.2.2:8000/uploads/${article.book_thumbnail}",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 45,
                                        left: width * 0.4,
                                        child: Container(
                                          height: 200,
                                          width: 200,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                " ${article.book_title!}",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontFamily: "Avenir",
                                                  fontWeight: FontWeight.w900,
                                                  color: Get.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black54,
                                                ),
                                              ),
                                              Text(
                                                " Author: ${article.book_author!}",
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Avenir",
                                                  fontWeight: FontWeight.w900,
                                                  color: Get.isDarkMode
                                                      ? Colors.grey
                                                      : Colors.black54,
                                                ),
                                              ),
                                              const Divider(
                                                  color: Colors.black),
                                              TextWidget(
                                                  text:
                                                      article.book_description,
                                                  fontSize: 16,
                                                  color: Colors.grey),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
