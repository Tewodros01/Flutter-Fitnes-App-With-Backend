import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project/logic/api/my_api.dart';
import 'package:project/logic/models/get_book_info.dart';
import 'package:project/logic/services/theme.dart';
import 'package:project/view/components/text_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'all_books.dart';

class DetailBookPage extends StatefulWidget {
  final BookInfo? bookInfo;
  final int? index;
  const DetailBookPage({super.key, this.bookInfo, this.index});

  @override
  State<DetailBookPage> createState() => _DetailBookPageState();
}

class _DetailBookPageState extends State<DetailBookPage> {
  String? _localPath;
  bool? _permissionReady;
  TargetPlatform? platform;
  int? userId;
  int? isLike;
  int downloadProgress = 0;

  bool isDownloadStarted = false;

  bool isDownloadFinish = false;

  @override
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
      var userInfo = jsonDecode(user);
      userId = userInfo['id'];
    } else {
      debugPrint("no info");
    }
    await _getLikeBook();
  }

  _getLikeBook() async {
    var data = {
      'user_id': '$userId',
      'book_id': '${widget.bookInfo?.id}',
    };
    var res = await CallApi().getPublicDataByRequest('alllikebook', data);
    var body = json.decode(res.body);
    print("Respons Body = ${body['is_liked']}");
    setState(() {
      isLike = body['is_liked'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Material(
      child: Container(
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        padding: const EdgeInsets.only(top: 60, left: 20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 0, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              child: Row(
                children: [
                  Material(
                    elevation: 0.0,
                    child: Container(
                      height: 180,
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Get.isDarkMode
                                ? darkGreyClr.withOpacity(0.9)
                                : darkGreyClr.withOpacity(0.3),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          )
                        ],
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            "http://10.0.2.2:8000/uploads/${widget.bookInfo!.book_thumbnail}",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: screenWidth - 30 - 180 - 20,
                    margin: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          widget.bookInfo!.book_title!,
                          style: TextStyle(
                            fontSize: 30,
                            fontFamily: "Avenir",
                            fontWeight: FontWeight.w900,
                            color:
                                Get.isDarkMode ? Colors.white : Colors.black54,
                          ),
                        ),
                        Text(
                          "Author: ${widget.bookInfo!.book_author!}",
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Avenir",
                            fontWeight: FontWeight.w900,
                            color: Get.isDarkMode
                                ? Colors.white38
                                : Colors.black54,
                          ),
                        ),
                        const Divider(color: Colors.black26),
                        TextWidget(
                          text: widget.bookInfo!.book_title,
                          fontSize: 16,
                          color: Colors.white24,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Divider(color: Colors.black26),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _likePost();
                          });
                        },
                        child: Icon(
                          Icons.favorite,
                          color: isLike == 1
                              ? const Color.fromARGB(255, 226, 25, 25)
                              : const Color(0xFF7b8ea3),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                  Column(
                    children: [
                      Visibility(
                          visible: isDownloadStarted,
                          child: CircularPercentIndicator(
                            radius: 20.0,
                            lineWidth: 3.0,
                            percent: (downloadProgress / 100),
                            center: Text(
                              "$downloadProgress%",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.blue),
                            ),
                            progressColor: Colors.blue,
                          )),
                      Visibility(
                        visible: !isDownloadStarted,
                        child: IconButton(
                          icon: const Icon(Icons.download),
                          color: isDownloadFinish ? Colors.green : Colors.grey,
                          onPressed: downloadFile,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                TextWidget(
                  text: "details".tr,
                  fontSize: 30,
                ),
                Expanded(child: Container())
              ],
            ),
            const SizedBox(height: 30),
            Container(
              height: 210,
              child: Text(
                widget.bookInfo!.book_description!,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Avenir",
                  fontWeight: FontWeight.w900,
                  color: Get.isDarkMode ? Colors.white24 : Colors.black54,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50),
              child: GestureDetector(
                onTap: () {
                  Get.to(() => const AllBooks());
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: Row(
                    children: [
                      TextWidget(
                        text: "check_directory".tr,
                        fontSize: 20,
                      ),
                      Expanded(child: Container()),
                      const IconButton(
                        icon: Icon(Icons.arrow_forward_ios),
                        onPressed: null,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showMsg(msg) {
    Get.snackbar(
      "Token has Refresh ",
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: greenClr,
    );
  }

  _likePost() async {
    if (isLike == 0) {
      _postlike('likebook');
    } else if (isLike == 1) {
      _postlike('disLikebook');
    }
  }

  _postlike(endPoint) async {
    var data = {
      'user_id': '$userId',
      'post_id': '${widget.bookInfo!.id}',
    };
    try {
      var responses = await CallApi().postLike(data, endPoint);
      var body = json.decode(responses.body);
      if (body['success'] != 'expired') {
        print("Respons Body = ${body}");
        setState(() {
          _likeGet();
        });
      } else {
        var res = await CallApi().getData('refresh');
        var body = json.decode(res.body);
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', body['token']);
        _showMsg("Your sesion is referesh ");
      }
    } catch (e) {
      print("Respons Body Fail $e");
    }
  }

  _likeGet() async {
    var data = {
      'user_id': '$userId',
      'book_id': '${widget.bookInfo?.id}',
    };
    var res = await CallApi().getPublicDataByRequest('alllikebook', data);
    var body = json.decode(res.body);
    print("Respons Body = ${body['is_liked']}");
    setState(() {
      isLike = body['is_liked'];
    });
  }

  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath());
    print(_localPath);
    final saveDir = Directory(_localPath!);
    bool hasExited = await saveDir.exists();
    if (!hasExited) {
      saveDir.create();
    }
  }

  Future<String> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/sdcard/download/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }

  void downloadFile() async {
    isDownloadStarted = true;
    isDownloadFinish = false;
    downloadProgress = 0;
    _permissionReady = await _checkPermission();
    if (_permissionReady!) {
      await _prepareSaveDir();
      print("Dawnloading");
      try {
        await Dio().download(
          "http://10.0.2.2:8000/uploads/${widget.bookInfo!.book_content}",
          "${_localPath}new_fitness_file.pdf",
          onReceiveProgress: (received, total) {
            setState(() {
              downloadProgress = ((received / total) * 100).floor();
            });
          },
          deleteOnError: true,
        );
      } catch (e) {
        print("Dawnload Faild " + e.toString());
      }
    }
    if (downloadProgress == 100) {
      setState(() {
        if (downloadProgress == 100) {
          isDownloadFinish = true;
          isDownloadStarted = false;
        }
      });
    }
  }
}
