import 'package:face_detector_app/getx/controller.dart';
import 'package:face_detector_app/getx/middleware.dart';
import 'package:get/get.dart';
import 'package:process_run/process_run.dart';

class Detector {
  var shell = Shell();

  final Controller controller = Get.find();
  final Middleware middleware = Get.find();

  void run(){
    print("?!");
  }

  void stop(){
    controller.running.value=false;
  }
}