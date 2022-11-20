import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/logic/api/my_api.dart';
import 'package:project/logic/services/theme.dart';
import 'package:project/view/components/text_tab.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class LocalFitnessHome extends StatefulWidget {
  const LocalFitnessHome({super.key});

  @override
  State<LocalFitnessHome> createState() => _LocalFitnessHomeState();
}

class _LocalFitnessHomeState extends State<LocalFitnessHome> {
  List videoInfo = [];
  bool _playArea = false;
  bool _isPlaying = false;
  bool _disPosed = false;
  int _isPlayingIndex = -1;
  VideoPlayerController? _controller;
  Duration? _duration;
  Duration? _position;
  var _onUpdateControllerTime = 0;
  var _progress = 0.0;
  int selectedTab = 1;
  bool selectedTab1 = true;
  bool selectedTab2 = false;
  bool selectedTab3 = false;
  bool selectedTab4 = false;
  bool selectedTab5 = false;
  String category = "biceps_workout".tr;
  double? temp_max;
  double? temp_min;
  double? perception;
  double? predictionResult = 0.0;
  getTemprature() async {
    try {
      var res = await CallApi().getPublicData('gettemp');
      var body = json.decode(res.body);
      temp_max = body[0]['temp_max'];
      temp_min = body[0]['temp_min'];
      perception = body[0]['perception'];
      print(body);
    } catch (e) {
      print(e);
    }
  }

  getPrediction() async {
    try {
      await getTemprature();
      print("Request");
      final url = Uri.http("10.0.2.2:5000", "/getPrediction");
      final response = await http.post(
        url,
        body: json.encode(
          {
            'perception': perception,
            'temp_max': temp_max,
            'temp_min': temp_min,
          },
        ),
        headers: {'Content-Type': 'application/json; charset=utf-8'},
      );
      setState(() {
        print("Request ${response.statusCode}");
        if (response.statusCode == 200) {
          print("Request ${response.statusCode}");
          var result = json.decode(response.body);
          predictionResult = result['prediction'];
          print(predictionResult);
        } else {
          print("Request Faild");
        }
      });
    } catch (e) {
      print(e);
    }
  }

  _initData() async {
    await DefaultAssetBundle.of(context)
        .loadString("json/biceps_workout.json")
        .then((value) {
      setState(() {
        videoInfo = json.decode(value);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getPrediction();
    _initData();
  }

  @override
  void dispose() {
    _disPosed = true;
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: _playArea == false
            ? BoxDecoration(
                color: Get.isDarkMode ? darkGreyClr : Colors.white30,
              )
            : BoxDecoration(
                color: Get.isDarkMode ? darkGreyClr : Colors.white54,
              ),
        child: Column(
          children: [
            _playArea == false
                ? Container(
                    padding:
                        const EdgeInsets.only(top: 70, left: 30, right: 30),
                    width: MediaQuery.of(context).size.width,
                    height: 350,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            gradient: const RadialGradient(
                              colors: [
                                Colors.yellow,
                                Color.fromARGB(255, 155, 127, 199),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12.withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(4, 2),
                              ),
                            ],
                          ),
                          height: 175,
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 120,
                                    margin: const EdgeInsets.only(
                                        left: 20, top: 20),
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          "assets/images/cloudy.png",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(child: Container()),
                              Container(
                                margin:
                                    const EdgeInsets.only(right: 20, top: 20),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "today_temp".tr,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    temp_max == null
                                        ? const CircularProgressIndicator()
                                        : Text(
                                            "$temp_max°C",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                    Text(
                                      "tmorow_temp".tr,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    predictionResult == 0.0
                                        ? const CircularProgressIndicator()
                                        : Text(
                                            "${(predictionResult)?.toStringAsFixed(2)} °C",
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        Row(
                          children: [
                            Container(
                              width: 90,
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.8),
                                      Colors.black.withOpacity(0.5),
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    Icons.timer,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "68 min",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white60,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            Container(
                              width: 190,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(0.8),
                                    Colors.black.withOpacity(0.5),
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/images/cloudy.png"),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      "${"todays_date".tr}${"todays_condition_sunligth".tr}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white60,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        _playView(context),
                        _controllerView(context),
                      ],
                    ),
                  ),
            Container(
              height: 70,
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = 1;
                            _getVideoInfo("biceps_workout.json");
                            category = "biceps_workout".tr;
                            _slectedTab();
                          });
                        },
                        child: TextTab(
                          selectedTab: selectedTab1,
                          name: "biceps_workout".tr,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = 2;
                            category = "chest_workout".tr;
                            _getVideoInfo("chest_workout.json");
                            _slectedTab();
                          });
                        },
                        child: TextTab(
                          selectedTab: selectedTab2,
                          name: "chest_workout".tr,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = 3;
                            category = "back_workout".tr;
                            _getVideoInfo("back_workout.json");
                            _slectedTab();
                          });
                        },
                        child: TextTab(
                          selectedTab: selectedTab3,
                          name: "back_workout".tr,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = 4;
                            category = "shoulder_workout".tr;
                            _getVideoInfo("shoulder_workout.json");
                            _slectedTab();
                          });
                        },
                        child: TextTab(
                          selectedTab: selectedTab4,
                          name: "shoulder_workout".tr,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedTab = 5;
                            category = "leg_workout".tr;
                            _getVideoInfo("leg_workout.json");
                            _slectedTab();
                          });
                        },
                        child: TextTab(
                          selectedTab: selectedTab5,
                          name: "leg_workout".tr,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: _playArea == false
                    ? const EdgeInsets.only(top: 20)
                    : const EdgeInsets.only(top: 0),
                child: _buildCard(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getVideoInfo(String path) async {
    await DefaultAssetBundle.of(context).loadString("json/$path").then((value) {
      setState(() {
        videoInfo = json.decode(value);
      });
    });
  }

  String convertTwo(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  _slectedTab() {
    bool isSekected = false;
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
    } else if (selectedTab == 5) {
      selectedTab1 = false;
      selectedTab2 = false;
      selectedTab3 = false;
      selectedTab4 = false;
      selectedTab5 = true;
    }
  }

  Widget _controllerView(BuildContext context) {
    final noMute = (_controller?.value.volume ?? 0) > 0;
    final duration = _duration?.inSeconds ?? 0;
    final head = _position?.inSeconds ?? 0;
    final remained = max(0, duration - head);
    final mins = convertTwo(remained ~/ 60.0);
    final secs = convertTwo(remained % 60);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Colors.grey[850],
            inactiveTrackColor: Colors.grey[900],
            trackShape: const RoundedRectSliderTrackShape(),
            trackHeight: 2.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0),
            thumbColor: Colors.grey,
            overlayColor: Colors.blue[70],
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
            tickMarkShape: const RoundSliderTickMarkShape(),
            activeTickMarkColor: Colors.grey[900],
            inactiveTickMarkColor: Colors.grey[900],
            valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: Colors.grey[900],
            valueIndicatorTextStyle: const TextStyle(
              color: Colors.white54,
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
          height: 30,
          width: MediaQuery.of(context).size.width,
          color: Get.isDarkMode ? darkGreyClr : Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  if (noMute) {
                    //  Get.toNamed(RouteHelper.getIntial());
                    _controller?.setVolume(0);
                  } else {
                    _controller?.setVolume(1.0);
                  }
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
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
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              FloatingActionButton(
                onPressed: () async {
                  final index = _isPlayingIndex - 1;
                  if (index >= 0 && videoInfo.length >= 0) {
                    _initializedVideo(index);
                  } else {
                    Get.snackbar(
                      "video_list".tr,
                      "",
                      snackPosition: SnackPosition.BOTTOM,
                      icon: const Icon(
                        Icons.face,
                        size: 20,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.grey,
                      colorText: Colors.white,
                      messageText: Text(
                        "no_video_a_head".tr,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                },
                child: const Icon(
                  Icons.fast_rewind,
                  size: 20,
                  color: Colors.white,
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
              FloatingActionButton(
                onPressed: () async {
                  final index = _isPlayingIndex + 1;
                  if (index <= videoInfo.length - 1) {
                    _initializedVideo(index);
                  } else {
                    Get.snackbar(
                      "video_list".tr,
                      "",
                      snackPosition: SnackPosition.BOTTOM,
                      icon: const Icon(
                        Icons.face,
                        size: 16,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.grey[900],
                      colorText: Colors.white,
                      messageText: Text(
                        "no_mor_video".tr,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }
                },
                child: const Icon(
                  Icons.fast_forward,
                  size: 16,
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
    );
  }

  Widget _playView(BuildContext context) {
    var _onUpdateControllerTime;
    Duration? _duration;
    Duration _position;
    var _progress = 0.0;
    final controller = _controller;
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
        aspectRatio: 16 / 14,
        child: VideoPlayer(_controller!),
      );
    } else {
      return AspectRatio(
        aspectRatio: 16 / 14,
        child: Center(
          child: Text(
            "preparing".tr,
            style: TextStyle(
              fontSize: 20,
              color: Get.isDarkMode ? Colors.white60 : Colors.black54,
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

  _initializedVideo(int index) async {
    final controller =
        VideoPlayerController.asset(videoInfo[index]['videoUrl']);
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
          _isPlayingIndex = index;
          controller.addListener(_onControllerUpdated);
          controller.play();
          setState(() {});
        });
    });
  }

  _onTapVideo(int index) {
    _initializedVideo(index);
  }

  _buildCard() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                Text(
                  category,
                  style: GoogleFonts.lato(
                    fontSize: 30,
                    color: Get.isDarkMode ? Colors.white : Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
              width: double.infinity,
              height: 190,
              child: ListView.builder(
                itemCount: videoInfo.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _onTapVideo(index);
                            debugPrint(index.toString());
                            setState(() {
                              if (_playArea == false) {
                                _playArea = true;
                              }
                            });
                          },
                          child: videoInfo.length == 0
                              ? CircularProgressIndicator()
                              : Container(
                                  height: 160,
                                  width: 140,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    image: DecorationImage(
                                      image: AssetImage(
                                        videoInfo[index]['thumbnail'],
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 10),
                        videoInfo.length == 0
                            ? CircularProgressIndicator()
                            : Expanded(
                                child: Text(
                                  videoInfo[index]["title"],
                                  style: TextStyle(
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black54,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
