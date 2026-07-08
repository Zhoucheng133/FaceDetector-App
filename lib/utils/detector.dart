import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:face_detector_app/getx/controller.dart';
import 'package:face_detector_app/getx/middleware.dart';
import 'package:face_detector_app/utils/handler.dart';
import 'package:get/get.dart';

class Detector {

  final Controller controller = Get.find();
  final Middleware middleware = Get.find();

  Future<void> run(VoidCallback func) async {
    final env = Map<String, String>.from(Platform.environment);
    env['PYTHONUNBUFFERED'] = '1';
    env['PYTHONUTF8']='1';
    try {
      final args = [
        middleware.processArg.value!.action==ImageAction.draw? "draw" : "count",
        ...controller.files,
        "--model", getModelPath(),
        "--confidence", middleware.processArg.value!.confidence.toString(),
        "--output", middleware.processArg.value!.path,
        "--thickness", middleware.processArg.value!.thickness.toString(),
      ];
      // print(el);
      final Process process=await Process.start(getDetectorPath(), args, environment: env);
      process.stdout
      .listen((data) {
        final text = utf8.decode(data, allowMalformed: true);
        final count = jsonDecode(text)["data"];
        controller.faces.add(count);
      });
      process.exitCode.then((val){
        controller.running.value=false;
        func();
      });
    } catch (_) {}
  }

  void stop(){
    controller.running.value=false;
  }
}