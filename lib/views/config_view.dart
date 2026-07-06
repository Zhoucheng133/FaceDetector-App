import 'package:face_detector_app/getx/controller.dart';
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

  String? imageType="portrait";
  String? action;
  final pathInput = TextEditingController();
  double confidence = 0.5;

  Future<void> pickTargetDirectory() async {
    String? selectedDirectory = await FilePicker.getDirectoryPath();
    if (selectedDirectory != null) {
      setState(() {
        pathInput.text = selectedDirectory;
      });
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
          spacing: 10,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                                    DropdownMenuItem(value: 'copyTo', child: Text('copyTo'.tr)),
                                    DropdownMenuItem(value: 'moveTo', child: Text('moveTo'.tr)),
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
                              Text(confidence.toStringAsFixed(2))
                            ],
                          ),
                        ],
                      ),
                      if(action!="delete") Column(
                        mainAxisSize: .min,
                        crossAxisAlignment: .start,
                        spacing: 10,
                        children: [
                          Text(
                            "targetDir".tr,
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
                          controller.files.clear();
                          Get.until((route) => route.isFirst, id: 1);
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
                    onPressed: (){
                      // TODO
                    }, 
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