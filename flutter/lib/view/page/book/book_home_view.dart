import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/logic/api/my_api.dart';
import 'package:project/logic/models/get_book_info.dart';
import 'package:project/logic/services/notification_services.dart';
import 'package:project/view/components/text_tab.dart';
import 'package:project/view/page/book/searched_book.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project/logic/services/theme.dart';
import 'package:project/view/page/book/book_category.dart';

class ArticleHomeView extends StatefulWidget {
  const ArticleHomeView({super.key});

  @override
  State<ArticleHomeView> createState() => _ArticleHomeViewState();
}

class _ArticleHomeViewState extends State<ArticleHomeView> {
  int slectedItem = 1;
  int selectedTab = 1;
  bool selectedTab1 = true;
  bool selectedTab2 = false;
  bool selectedTab3 = false;
  bool selectedTab4 = false;
  var philosophiBooks = <BookInfo>[];
  var novelBooks = <BookInfo>[];
  var motivationBooks = <BookInfo>[];
  var boxingBooks = <BookInfo>[];
  var allBooks = <BookInfo>[];
  var passBook = <BookInfo>[];
  var notifiyHelper = NotifiyHelper();
  TextEditingController textController = TextEditingController();
  String currentUser = "";
  String book_category = "popular_books".tr;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    _getUsers();
    super.initState();
  }

  _getUsers() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString("user");
    if (user != null) {
      setState(() {
        var userInfo = jsonDecode(user);
        currentUser = userInfo['name'];
      });
    } else {
      debugPrint("no info");
    }
    await _initData();
  }

  _initData() async {
    try {
      await CallApi().getPublicData("allbook").then((response) {
        setState(() {
          Iterable list = json.decode(response.body);
          allBooks = list.map((model) => BookInfo.fromJson(model)).toList();
          passBook = allBooks;
        });
      });
      _getDataRequested(1);
      _getDataRequested(3);
      _getDataRequested(4);
    } catch (e) {
      print(e);
    }
  }

  _getDataRequested(typeId) async {
    try {
      var data = {
        'type_id': '$typeId',
      };
      await CallApi()
          .getPublicDataByRequest("allbookbycategory", data)
          .then((response) {
        setState(() {
          Iterable list = json.decode(response.body);
          if (typeId == 1) {
            philosophiBooks =
                list.map((model) => BookInfo.fromJson(model)).toList();
          } else if (typeId == 3) {
            motivationBooks =
                list.map((model) => BookInfo.fromJson(model)).toList();
          } else if (typeId == 4) {
            boxingBooks =
                list.map((model) => BookInfo.fromJson(model)).toList();
          }
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Material(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Get.isDarkMode ? darkGreyClr : Colors.white,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0, left: 20.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "hey".tr,
                            style: GoogleFonts.bebasNeue(
                              fontSize: 32,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Colors.black38,
                              letterSpacing: 1.8,
                            ),
                          ),
                          Text(
                            currentUser,
                            style: GoogleFonts.bebasNeue(
                              fontSize: 32,
                              color: const Color(0XFF40D876),
                              letterSpacing: 1.8,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          borderRadius: BorderRadius.circular(40.0),
                          border: Border.all(
                            width: 3,
                            color: const Color(0xFF40D876),
                          ),
                          image: const DecorationImage(
                            image: AssetImage(
                              "assets/images/logo_2.png",
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white54.withOpacity(.1),
                      borderRadius: BorderRadius.circular(40.0),
                    ),
                    child: Center(
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF40D876),
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.book_outlined,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, top: 50.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "find_book".tr,
                            style: GoogleFonts.lato(
                              fontSize: 24,
                              color: const Color(0xFF40D876),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "your_book".tr,
                            style: GoogleFonts.lato(
                              fontSize: 24,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Colors.black38,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.filter_alt_outlined,
                        size: 40,
                        color: Get.isDarkMode ? Colors.white : Colors.black38,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    width: 353,
                    height: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xFF232441),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: "search_book".tr,
                          hintStyle: const TextStyle(
                            color: Colors.white54,
                          ),
                          border: InputBorder.none,
                          icon: GestureDetector(
                            onTap: () {
                              _searchBook();
                            },
                            child: const Icon(
                              Icons.search,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  child: ListView(
                    padding: const EdgeInsets.only(top: 20),
                    scrollDirection: Axis.horizontal,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTab = 1;
                                passBook = allBooks;
                                book_category = "popular_book".tr;
                                _slectedTab();
                              });
                            },
                            child: TextTab(
                                selectedTab: selectedTab1,
                                name: "popular_book".tr),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTab = 2;
                                book_category = "Philosophy_book".tr;
                                passBook = philosophiBooks;
                                _slectedTab();
                              });
                            },
                            child: TextTab(
                                selectedTab: selectedTab2,
                                name: "Philosophy_book".tr),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTab = 3;
                                book_category = "motivation_book".tr;
                                passBook = motivationBooks;
                                _slectedTab();
                              });
                            },
                            child: TextTab(
                                selectedTab: selectedTab3,
                                name: "motivation_book".tr),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedTab = 4;
                                book_category = "boxing_book".tr;
                                passBook = boxingBooks;
                                _slectedTab();
                              });
                            },
                            child: TextTab(
                                selectedTab: selectedTab4,
                                name: "boxing_book".tr),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                ),
                passBook.length == 0
                    ? Container(
                        margin: const EdgeInsets.only(top: 70),
                        child: const CircularProgressIndicator(),
                      )
                    : BookCategory(category: book_category, book: passBook),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _searchBook() async {
    print(textController.text);
    var searchBook = <BookInfo>[];
    var datas = {
      'book_title': '${textController.text}',
    };
    await CallApi()
        .getPublicDataByRequest('allsearchbook', datas)
        .then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        searchBook = list.map((model) => BookInfo.fromJson(model)).toList();
        Get.to(() => SearchedBook(books: searchBook));
      });
    });
  }

  _slectedTab() {
    if (selectedTab == 1) {
      selectedTab1 = true;
      selectedTab2 = false;
      selectedTab3 = false;
      selectedTab4 = false;
    } else if (selectedTab == 2) {
      selectedTab1 = false;
      selectedTab2 = true;
      selectedTab3 = false;
      selectedTab4 = false;
    } else if (selectedTab == 3) {
      selectedTab1 = false;
      selectedTab2 = false;
      selectedTab3 = true;
      selectedTab4 = false;
    } else if (selectedTab == 4) {
      selectedTab1 = false;
      selectedTab2 = false;
      selectedTab3 = false;
      selectedTab4 = true;
    }
  }
}
