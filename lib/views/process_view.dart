import 'package:face_detector_app/getx/controller.dart';
import 'package:face_detector_app/getx/middleware.dart';
import 'package:face_detector_app/utils/detector.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

class ProcessView extends StatefulWidget {

  const ProcessView({super.key});

  @override
  State<ProcessView> createState() => _ProcessViewState();
}

class _ProcessViewState extends State<ProcessView> {

  final Controller controller = Get.find();
  final Middleware middleware = Get.find();
  late Map<String, dynamic> args;

  final Detector detector = Detector();

  @override
  void initState() {
    super.initState();
    controller.running.value=true;
    detector.run();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
      child: Material(
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.files.length,
                  itemBuilder: (BuildContext context, int index)=>ListTile(
                    title: Text(p.basename(controller.files[index])),
                  )
                ),
              )
            ),
            Obx(
              () => SizedBox(
                  height: 50, 
                  child: Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: .min,
                        children: [
                          TextButton(
                            onPressed: controller.running.value ? null : (){
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
                        onPressed: controller.running.value ? ()=>detector.stop() : null, 
                        child: Row(
                          spacing: 5,
                          mainAxisSize: .min,
                          children: [
                            Icon(Icons.stop_rounded),
                            Text("stop".tr),
                          ],
                        )
                      )
                    ],
                  )
                ),
            ),
          ],
        ),
      ),
    );
  }
}