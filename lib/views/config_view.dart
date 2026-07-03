import 'package:face_detector_app/getx/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfigView extends StatefulWidget {
  const ConfigView({super.key});

  @override
  State<ConfigView> createState() => _ConfigViewState();
}

class _ConfigViewState extends State<ConfigView> {

  final Controller controller = Get.find();
    
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
                child: Placeholder()
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
                          // Get.until((route)=>route.settings.name == '/add', id: 1);
                          // Get.offNamedUntil('/preview', (route) => route.settings.name == '/add', id: 1);
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