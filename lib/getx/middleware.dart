import 'package:get/get.dart';

enum ImageAction{
  delete,
  copyTo,
  moveTo,
  draw
}

enum ImageTypes{
  portrait,
  other,
}

class ProcessArg{
  ImageTypes imageType;
  ImageAction action;
  String path;
  double confidence;
  int thickness;
  ProcessArg(this.imageType, this.action, this.confidence, this.path, this.thickness);
}

class Middleware extends GetxController {
  Rx<ProcessArg?> processArg=Rx(null as ProcessArg?);
}