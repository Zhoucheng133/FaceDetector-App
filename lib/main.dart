import 'package:face_detector_app/getx/controller.dart';
import 'package:face_detector_app/lang/zh_cn.dart';
import 'package:face_detector_app/main_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  final Controller controller = Get.put(Controller());
  await controller.init();
  WindowOptions windowOptions = WindowOptions(
    size: Size(500, 600),
    minimumSize: Size(500, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    title: "FaceDetector"
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class MainTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    // 'en_US': enUS,
    'zh_CN': zhCN,
    // 'zh_TW': zhTW,
  };
}


class _MainAppState extends State<MainApp> {

  final Controller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: MainTranslations(), 
      debugShowCheckedModeBanner: false,
      locale: controller.lang.value.locale, 
      fallbackLocale: supportedLocales[0].locale,
      supportedLocales: supportedLocales.map((item)=>item.locale).toList(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      theme: ThemeData(
        brightness: Theme.of(context).brightness,
        fontFamily: 'PuHui', 
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Theme.of(context).brightness,
        ),
        textTheme: Theme.of(context).brightness==Brightness.dark ? ThemeData.dark().textTheme.apply(
          fontFamily: 'PuHui',
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ) : ThemeData.light().textTheme.apply(
          fontFamily: 'PuHui',
        ),
      ),
      home: Scaffold(
        body: MainWindow()
      ),
    );
  }
}