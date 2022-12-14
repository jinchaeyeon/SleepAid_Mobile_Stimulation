import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sleepaid/data/local/app_dao.dart';
import 'package:sleepaid/provider/bluetooth_provider.dart';
import 'package:sleepaid/provider/data_provider.dart';
import 'package:sleepaid/util/app_colors.dart';
import 'package:sleepaid/util/app_images.dart';
import 'package:sleepaid/util/functions.dart';
import 'package:sleepaid/widget/base_stateful_widget.dart';
import 'package:provider/provider.dart';
import 'package:surround_sound/surround_sound.dart';
import '../app_routes.dart';
import '../provider/main_provider.dart';

///연결중인 장치 있을때와 없을때 구분
class HomePage extends BaseStatefulWidget {
  static const ROUTE = "/Home";

  const HomePage({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<HomePage> with WidgetsBindingObserver {
  Size? size;
  bool isInit = true;

  SoundController controllerLeft = SoundController();
  SoundController controllerRight = SoundController();

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    checkBluetoothState();
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    log("didChangeAppLifecycleState: $state");
    switch (state) {
      case AppLifecycleState.resumed:
        await startEveryStateChecker();
        break;
      case AppLifecycleState.paused:
        await stopEveryStateChecker();
        break;
    }
  }

  @override
  void dispose() {
    stopEveryStateChecker();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size ??= MediaQuery.of(context).size;
    checkNextDay(context);

    return Scaffold(
        extendBody: true,
        body: SafeArea(
            child: getBaseWillScope(context, mainContent(), onWillScope: () {
          showExitDialog(context);
        })));
  }

  Widget mainContent() {
    return Container(
        width: double.maxFinite,
        height: double.maxFinite,
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              Theme.of(context).colorScheme.primaryVariant,
              Theme.of(context).colorScheme.secondaryVariant
            ],
          ),
        ),
        child: AspectRatio(
            aspectRatio: getAspectRatio(context),
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                    child: SizedBox(
                        width: double.maxFinite,
                        height: geteDeviceHeight(context) - 150,
                        child: homeContent(context))))));
  }

  // 데이터 수집/비수집 변환
  Future<void> toggleCollectingData() async {
    await context.read<BluetoothProvider>().toggleDataCollecting();
  }

  Widget homeContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: SizedBox.shrink(),
        ),
        Stack(
          children: [
            Container(
                child: Column(children: [
              SoundWidget(
                soundController: controllerLeft,
              ),
              SoundWidget(
                soundController: controllerRight,
              ),
            ])),
            Container(
                height: 70,
                width: double.maxFinite,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 70,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      alignment: Alignment.center,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Sleep Aid',
                            style: TextStyle(
                              color: AppColors.mainBlue,
                              fontSize: 30,
                              // // fontFamily: Util.roboto,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                              width: 80,
                              height: 80,
                              child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, Routes.menu);
                                  },
                                  child: Container(
                                      width: double.maxFinite,
                                      height: double.maxFinite,
                                      // color: Colors.red,
                                      padding: const EdgeInsets.only(
                                          left: 40,
                                          right: 0,
                                          top: 25,
                                          bottom: 25),
                                      child: Image.asset(
                                        AppImages.menu,
                                        fit: BoxFit.contain,
                                        width: 20,
                                        height: 20,
                                      ))))
                        ],
                      ),
                    )
                  ],
                ))
          ],
        ),
        const Expanded(
          child: SizedBox.shrink(),
        ),
        SizedBox(
          width: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              context
                          .watch<BluetoothProvider>()
                          .connectorNeck
                          .connectedDeviceId !=
                      ""
                  ? contentButton(context, AppImages.electricalStimulation,
                      '전기자극설정', true, '전기 자극 출력증', '', onTap: (context) {
                      Navigator.pushNamed(context, Routes.settingRecipe);
                    })
                  : contentButton(context, AppImages.electricalStimulation,
                      '전기자극설정', false, '전기 자극 출력증지', '', onTap: (context) {
                      Navigator.pushNamed(context, Routes.settingRecipe);
                    }),
            ],
          ),
        ),
        const Expanded(
          child: SizedBox.shrink(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            context
                        .watch<BluetoothProvider>()
                        .connectorNeck
                        .connectedDeviceId !=
                    ""
                ? contentButton(context, AppImages.bluetoothConnect,
                    '기기 연결 (목)', true, '배터리 잔량 ${"90"}%', '', onTap: (context) {
                    //todo
                    // Navigator.pushNamed(context, routeSleepAnalysis);
                  })
                : contentButton(context, AppImages.bluetoothConnect,
                    '기기 연결 (목)', false, '배터리 잔량 -', '', onTap: (context) {
                    //todo
                    // Navigator.pushNamed(context, routeSleepAnalysis);
                  })
          ],
        ),
      ],
    );
  }

  Widget contentButton(BuildContext context, String image, String title,
      bool isOn, String state, String route,
      {required Null Function(BuildContext context) onTap}) {
    return Expanded(
      flex: 1,
      child: InkWell(
          onTap: () {
            onTap(context);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: _getItemWidth(context),
            height: _getItemHeight(context),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(26),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  width: 38,
                  height: 38,
                  child: Image.asset(image, fit: BoxFit.contain),
                ),
                Text(
                  title,
                  style: TextStyle(
                    overflow: TextOverflow.clip,
                    color: Theme.of(context).textSelectionTheme.selectionColor,
                    fontSize: getFontSize(context, 13),
                    // fontFamily: Util.notoSans,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                stateContainer(state, isOn),
              ],
            ),
          )),
    );
  }

  Widget stateContainer(String state, bool isOn) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      height: 22,
      decoration: BoxDecoration(
        color: isOn ? AppColors.mainYellow : Colors.transparent,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(width: 1.5, color: AppColors.mainYellow),
      ),
      child: Center(
        child: Text(
          state,
          style: TextStyle(
            color: isOn ? Colors.white : AppColors.mainYellow,
            fontSize: 10,
            // fontFamily: Util.notoSans,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  double getDeviceWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  getAspectRatio(BuildContext context) {
    var portrait = MediaQuery.of(context).orientation;
    if (portrait == Orientation.portrait) {
      return 280 / 560;
    }
    return 560 / 280;
  }

  double geteDeviceHeight(BuildContext context) {
    var portrait = MediaQuery.of(context).orientation;
    if (portrait == Orientation.portrait) {
      return MediaQuery.of(context).size.height;
    }
    return MediaQuery.of(context).size.height * 2;
  }

  ///화면이 불려왔을 때 날짜가 변경되면 데이터 갱신 요청
  void checkNextDay(BuildContext context) {}

  double _getItemWidth(BuildContext context) {
    if (size == null) return 130;
    if (size!.width > 300) return (size!.width / 2) - 60;
    return 130;
  }

  double _getItemHeight(BuildContext context) {
    if (size == null) return 130;
    if (size!.height / 4 > 130) return (size!.height / 4) - 60;
    return 130;
  }

  /// 플레이 중이라면 일시정지 또는 일시정지 해제
  Future<void> pauseBinauralBeatState(bool pause) async {
    await context.read<DataProvider>().pauseBinauralBeatState(pause);
  }

  /// 1. 블루투스 권한 확인
  /// todo 2. 블루투스 기연결 기기 있는지 확인
  /// todo 3. 블뤁스 연결 상태에 따라 출력중 상태 확인
  Future<void> checkBluetoothState() async {
    //블루투스 권한 상태 체크
    await checkBluetoothPermission();
  }

  Future<void> checkBluetoothPermission() async {
    await Future.delayed(const Duration(milliseconds: 200), () async {
      if (mounted) {
        await context.read<BluetoothProvider>().checkBluetoothPermission();
      }
    });
  }

  /// todo 블루투스, 비트등을 일시정지 처리
  Future<void> stopEveryStateChecker() async {
    log("stopEveryStateChecker");
    context.read<DataProvider>().setLoading(true);
    await pauseBinauralBeatState(true);
    await context.read<BluetoothProvider>().pauseParse();
    context.read<DataProvider>().setLoading(false);
  }

  Future<void> startEveryStateChecker() async {
    log("startEveryStateChecker");
    context.read<DataProvider>().setLoading(true);
    await context.read<DataProvider>().loadParameters();
    await checkBluetoothState();
    await pauseBinauralBeatState(false);
    await context.read<BluetoothProvider>().resumeParse();
    context.read<DataProvider>().setLoading(false);
  }

  Future checkParameters() async {
    bool isValidParameters = true;
    if (AppDAO.baseData.electroStimulationParameters.isEmpty)
      isValidParameters = false;
    if (!isValidParameters) {
      context.read<DataProvider>().setLoading(true);
      await context.read<DataProvider>().loadParameters();
      context.read<DataProvider>().setLoading(false);
    }
  }

  double getFontSize(BuildContext context, double i) {
    return i;
  }

  Future<void> checkPlayBeat() async {
    await context
        .read<MainProvider>()
        .updateSoundControllers(controllerLeft, controllerRight);
    if (context.read<MainProvider>().isPlayingBeatMode) {
      setState(() {});
      Future.delayed(const Duration(milliseconds: 800), () async {
        await context.read<MainProvider>().playingBeatMode();
      });
    }
  }

  Future<void> stopBeat() async {
    await context.read<MainProvider>().stopBeatMode();
  }
}
