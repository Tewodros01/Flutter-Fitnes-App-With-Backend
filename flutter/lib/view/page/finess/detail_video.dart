import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/logic/api/my_api.dart';
import 'package:project/logic/models/workout_info.dart';
import 'package:project/logic/services/theme.dart';
import 'package:project/view/components/text_widget.dart';
import 'package:project/view/page/book/all_books.dart';
import 'package:project/view/page/finess/all_videos.dart';
import 'package:project/view/page/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class DetailVideo extends StatefulWidget {
  final WorkoutInfo? videoInfo;
  final int? index;
  const DetailVideo({super.key, this.videoInfo, this.index});

  @override
  State<DetailVideo> createState() => _DetailVideoState();
}

class _DetailVideoState extends State<DetailVideo> {
  bool _isPlaying = false;
  bool _disPosed = false;
  Duration? _duration;
  Duration? _position;
  var _onUpdateControllerTime = 0;
  var _progress = 0.0;
  int? isLike;
  int? userId;

  VideoPlayerController? _controller;

  @override
  void dispose() {
    _disPosed = true;
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
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
    await _getLikeVideo();
  }

  _getLikeVideo() async {
    var data = {
      'user_id': '$userId',
      'workout_id': '${widget.videoInfo!.id}',
    };
    var res = await CallApi().getPublicDataByRequest('alllikeworkout', data);
    var body = json.decode(res.body);
    setState(() {
      isLike = body['is_liked'];
      print("Is Like = $isLike");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        child: Container(
          decoration: BoxDecoration(
            color: Get.isDarkMode ? darkGreyClr : Colors.white,
          ),
          child: Column(
            children: [
              Container(
                height: 80,
                margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
                color: Get.isDarkMode ? darkGreyClr : Colors.white,
                child: Row(
                  children: [
                    InkWell(
                      child: Icon(
                        Icons.home,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                      ),
                      onTap: () {
                        Get.to(() => const Home());
                      },
                    ),
                    Expanded(child: Container()),
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Get.isDarkMode ? Colors.white : Colors.black,
                    )
                  ],
                ),
              ),
              _playView(context),
              _controllerView(context),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.only(left: 30, right: 30),
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => const AllVideos());
                          },
                          child: const Icon(
                            Icons.video_file_outlined,
                            color: Color(0xFF7b8ea3),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: TextWidget(
                            text: "detaile".tr,
                            fontSize: 26,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        Expanded(child: Container())
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: 200,
                      margin: const EdgeInsets.only(left: 20),
                      child: Text(
                        widget.videoInfo!.workout_description!,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Avenir",
                          fontWeight: FontWeight.w900,
                          color: Get.isDarkMode ? Colors.grey : Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
      _postLike('likeworkout');
    } else if (isLike == 1) {
      _postLike('dislikeworkout');
    }
  }

  _postLike(endPoint) async {
    try {
      var data = {
        'user_id': '$userId',
        'post_id': '${widget.videoInfo!.id}',
      };
      var responses = await CallApi().postLike(data, endPoint);
      var body = json.decode(responses.body);
      print("Respons Body = ${body}");
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
      print(e);
    }
  }

  _likeGet() async {
    try {
      var data = {
        'user_id': '$userId',
        'workout_id': '${widget.videoInfo!.id}',
      };
      var res = await CallApi().getPublicDataByRequest('alllikeworkout', data);
      var body = json.decode(res.body);
      print("Respons Body = ${body['is_liked']}");
      isLike = body['is_liked'];
    } catch (e) {
      print(e);
    }
  }

  String convertTwo(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  Widget _controllerView(BuildContext context) {
    final noMute = (_controller?.value.volume ?? 0) > 0;
    final duration = _duration?.inSeconds ?? 0;
    final head = _position?.inSeconds ?? 0;
    final remained = max(0, duration - head);
    final mins = convertTwo(remained ~/ 60.0);
    final secs = convertTwo(remained % 60);
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.grey[400],
                inactiveTrackColor: Colors.blue[100],
                trackShape: const RoundedRectSliderTrackShape(),
                trackHeight: 2.0,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                thumbColor: Colors.grey[200],
                overlayColor: Colors.blue[70],
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 28.0),
                tickMarkShape: const RoundSliderTickMarkShape(),
                activeTickMarkColor: Colors.blue[70],
                inactiveTickMarkColor: Colors.grey[200],
                valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
                valueIndicatorColor: Colors.grey[200],
                valueIndicatorTextStyle: TextStyle(
                  color: Colors.grey[200],
                ),
              ),
              child: Slider(
                value: max(0, min(_progress * 100, 100)),
                min: 0,
                max: 100,
                divisions: 100,
                label: _position?.toString().split(".")[0],
                onChanged: (value) {
                  setState(
                    () {
                      _progress = value * 0.01;
                    },
                  );
                },
                onChangeStart: (value) {
                  _controller?.pause();
                },
                onChangeEnd: (value) {
                  final duration = _controller?.value.duration;
                  if (duration != null) {
                    var newValue = max(0, min(value, 99)) * 0.01;
                    var millis = (duration.inMilliseconds * newValue).toInt();
                    _controller?.seekTo(Duration(milliseconds: millis));
                    _controller?.play();
                  }
                },
              ),
            ),
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(bottom: 5),
              color: Get.isDarkMode ? darkGreyClr : Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      if (noMute) {
                        // Get.toNamed(RouteHelper.getIntial());
                        _controller?.setVolume(0);
                      } else {
                        _controller?.setVolume(1.0);
                      }
                      setState(() {});
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0.0, 0.0),
                              blurRadius: 4.0,
                              color: Color.fromARGB(50, 0, 0, 0),
                            ),
                          ],
                        ),
                        child: Icon(
                          noMute ? Icons.volume_up : Icons.volume_off,
                          color: Get.isDarkMode ? Colors.white : Colors.black38,
                        ),
                      ),
                    ),
                  ),
                  FloatingActionButton(
                    onPressed: () async {
                      if (_isPlaying) {
                        setState(() {
                          _isPlaying = false;
                        });
                        _controller?.pause();
                      } else {
                        setState(() {
                          _isPlaying = true;
                        });
                        _controller?.play();
                      }
                    },
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "$mins:$secs",
                    style: const TextStyle(
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(0.0, 1.0),
                          blurRadius: 4.0,
                          color: Color.fromARGB(150, 0, 0, 0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _playView(BuildContext context) {
    var _onUpdateControllerTime;
    Duration? _duration;
    Duration _position;
    var _progress = 0.0;
    final controller = _controller;
    if (controller == null) {
      _initializedVideo();
    }
    void _onControllerUpdate() async {
      if (_disPosed) {
        return;
      }
      _onUpdateControllerTime = 0;
      final now = DateTime.now().millisecondsSinceEpoch;
      if (_onUpdateControllerTime > now) {
        return;
      }
      _onUpdateControllerTime = now + 500;
      final controller = _controller;
      if (controller == null) {
        debugPrint("controller ca not be initialized");
        return;
      }
      _duration = _controller?.value.duration;

      var duration = _duration;
      if (duration == null) return;
      var position = await controller.position;
      _position = position!;
      final playing = controller.value.isPlaying;
      if (playing) {
        if (_disPosed) return;
        setState(() {
          _progress = position.inMilliseconds.ceilToDouble() /
              duration.inMilliseconds.ceilToDouble();
        });
      }
      _isPlaying = playing;
    }

    if (controller != null && controller.value.isInitialized) {
      return AspectRatio(
        aspectRatio: 16 / 13,
        child: VideoPlayer(_controller!),
      );
    } else {
      return AspectRatio(
        aspectRatio: 16 / 13,
        child: Center(
          child: Text(
            "preparing".tr,
            style: TextStyle(
              fontSize: 20,
              color: Get.isDarkMode ? Colors.white60 : Colors.black26,
            ),
          ),
        ),
      );
    }
  }

  void _onControllerUpdated() async {
    if (_disPosed) {
      return;
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    if (_onUpdateControllerTime > now) {
      return;
    }
    _onUpdateControllerTime = now + 500;
    final controller = _controller;
    if (controller == null) {
      debugPrint("controller is null");
      return;
    }
    if (!controller.value.isInitialized) {
      debugPrint("controller can not be initialized");
      return;
    }
    _duration ??= _controller?.value.duration;
    var duration = _duration;
    if (duration == null) return;
    var position = await controller.position;
    _position = position;
    final playing = controller.value.isPlaying;
    if (playing) {
      if (_disPosed) return;
      setState(() {
        _progress = position!.inMilliseconds.ceilToDouble() /
            duration.inMilliseconds.ceilToDouble();
      });
    }
    _isPlaying = playing;
  }

  _initializedVideo() async {
    try {
      final controller = VideoPlayerController.network(
        "http://10.0.2.2:8000/uploads/${widget.videoInfo?.workout_content!}",
      );

      final old = _controller;
      _controller = controller;
      if (old != null) {
        old.removeListener(_onControllerUpdated);
        old.pause();
      }
      setState(() {
        // ignore: avoid_single_cascade_in_expression_statements
        controller
          ..initialize().then((_) {
            old?.dispose();
            controller.addListener(_onControllerUpdated);
            controller.play();
            setState(() {});
          });
      });
    } catch (e) {
      _initializedVideo();
      print("Error $e");
    }
  }
}
