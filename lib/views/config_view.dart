import 'package:face_detector_app/getx/controller.dart';
import 'package:face_detector_app/getx/middleware.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigView extends StatefulWidget {
  const ConfigView({super.key});

  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {

  final Controller controller = Get.find();
  final Middleware middleware = Get.find();

  String? imageType="portrait";
  String? action;
  final pathInput = TextEditingController();
  double confidence = 0.5;
  int thickness = 5;

  Future<void> pickTargetDirectory() async {
    String? selectedDirectory = await FilePicker.getDirectoryPath();
    if (selectedDirectory != null) {
      setState(() {
        pathInput.text = selectedDirectory;
      });
    }
  }

  void nextHandler(BuildContext context){
    if(!disabled()){
      middleware.processArg.value = ProcessArg(
        ImageTypes.values.asNameMap()[imageType]!,
        ImageAction.values.asNameMap()[action]!,
        confidence,
        pathInput.text,
        thickness
      );
      Get.toNamed("/process", id: 1);
    }
  }

  bool disabled(){
    if(imageType == null || action == null){
      return true;
    }
    if(action != "delete" && pathInput.text.isEmpty){
      return true;
    }
    return false;
  }

  String outputLabel(){
    if(action == "delete"){
      return "";
    }else if(action=="draw"){
      return "output".tr;
    }else{
      return action?.tr ?? "";
    }
  }

  @override
  void dispose() {
    pathInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 10,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Text(
                "config".tr,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness==Brightness.light? Colors.white : Colors.grey[900],
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    spacing: 20,
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Expanded(
                            child: Column(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "select".tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                DropdownButtonFormField<String>(
                                  initialValue: imageType,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  items: [
                                    DropdownMenuItem(value: 'portrait', child: Text('portraitPhotos'.tr)),
                                    DropdownMenuItem(value: 'other', child: Text('otherPhotos'.tr)),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      action = null;
                                      imageType = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              spacing: 10,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "actions".tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                DropdownButtonFormField<String>(
                                  initialValue: action,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                  ),
                                  items: [
                                    DropdownMenuItem(value: 'delete', child: Text('delete'.tr)),
                                    DropdownMenuItem(value: 'copyTo', child: Text('copy'.tr)),
                                    DropdownMenuItem(value: 'moveTo', child: Text('move'.tr)),
                                    if(imageType == 'portrait') DropdownMenuItem(value: 'draw', child: Text('draw'.tr)),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      action = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Column(
                        mainAxisSize: .min,
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            "confidence".tr,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            "confidenceTip".tr,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Row(
                            spacing: 20,
                            children: [
                              Expanded(
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    overlayColor: Colors.transparent,
                                  ),
                                  child: Slider(
                                    min: 0,
                                    max: 1,
                                    divisions: 20,
                                    value: confidence, 
                                    onChanged: (val){
                                      setState(() {
                                        confidence = val;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 30,
                                child: Text(
                                  confidence.toStringAsFixed(2),
                                  textAlign: TextAlign.end,
                                )
                              )
                            ],
                          ),
                        ],
                      ),
                      if(action=="draw") Column(
                        mainAxisSize: .min,
                        crossAxisAlignment: .start,
                        spacing: 10,
                        children: [
                          Text(
                            "thickness".tr,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          SliderTheme(
                            data: SliderThemeData(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              overlayColor: Colors.transparent,
                            ), 
                            child: Row(
                              spacing: 20,
                              children: [
                                Expanded(
                                  child: Slider(
                                    value: thickness.toDouble(), 
                                    min: 1,
                                    max: 30,
                                    divisions: 29,
                                    onChanged: (val){
                                      setState(() {
                                        thickness = val.toInt();
                                      });
                                    }
                                  ),
                                ),
                                SizedBox(
                                  width: 30,
                                  child: Text(
                                    thickness.toString(),
                                    textAlign: TextAlign.end,
                                  )
                                )
                              ],
                            )
                          ),
                        ],
                      ),
                      if(action!="delete" && action!=null) Column(
                        mainAxisSize: .min,
                        crossAxisAlignment: .start,
                        spacing: 10,
                        children: [
                          Text(
                            outputLabel(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: pathInput,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    isCollapsed: true,
                                    contentPadding: .symmetric(vertical: 10, horizontal: 7)
                                  ),
                                )
                              ),
                              FilledButton(
                                onPressed: pickTargetDirectory, 
                                child: Text("select".tr)
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ),
            ),
            SizedBox(
              height: 50, 
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Row(
                    mainAxisSize: .min,
                    children: [
                      TextButton(
                        onPressed: (){
                          Get.until((route) => route.isFirst, id: 1);
                          controller.files.clear();
                        }, 
                        child: Row(
                          mainAxisSize: .min,
                          spacing: 5,
                          children: [
                            Icon(Icons.close_rounded),
                            Text("cancel".tr),
                          ],
                        )
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: disabled() ? null : ()=>nextHandler(context), 
                    child: Row(
                      spacing: 5,
                      mainAxisSize: .min,
                      children: [
                        Text("next".tr),
                        Icon(Icons.arrow_forward_rounded)
                      ],
                    )
                  )
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}