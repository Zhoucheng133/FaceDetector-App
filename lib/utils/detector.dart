import 'dart:convert';
import 'dart:io';

import 'package:face_detector_app/getx/controller.dart';
import 'package:face_detector_app/getx/middleware.dart';
import 'package:face_detector_app/utils/handler.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

class Detector {

  final Controller controller = Get.find();
  final Middleware middleware = Get.find();

  Future<void> run() async {
    final env = Map<String, String>.from(Platform.environment);
    env['PYTHONUNBUFFERED'] = '1';
    env['PYTHONUTF8']='1';

    for (var el in controller.files) {
      try {
        final args = [
          middleware.processArg.value!.action==ImageAction.draw? "draw" : "count",
          el,
          "--model", getModelPath(),
          "--confidence", middleware.processArg.value!.confidence.toString(),
          "--output", p.join(middleware.processArg.value!.path, "${p.basenameWithoutExtension(el)}_detected.jpg"),
        ];
        final rlt=await Process.run(getDetectorPath(), args, environment: env);
        final data=json.decode(rlt.stdout);
        controller.faces.add(data['data']);
      } catch (_) {
        controller.faces.add(0);
      }
    }
    controller.running.value=false;
  }

  void stop(){
    controller.running.value=false;
  }
}