import 'dart:io';

import 'package:face_detector_app/getx/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Preview extends StatefulWidget {
  const Preview({super.key});

  @override
  State<Preview> createState() => _PreviewState();
}

class _PreviewState extends State<Preview> {

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
                child: Obx(() {
                  final files = controller.files;
                  if (files.isEmpty) {
                    return const Center(child: Text("No images"));
                  }
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = (constraints.maxWidth / 140).floor().clamp(1, 10);
                      return GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onSecondaryTapDown: (details) {
                              final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
                              final Offset position = overlay.localToGlobal(details.globalPosition);
                              showMenu(
                                context: context,
                                position: RelativeRect.fromLTRB(
                                  position.dx,
                                  position.dy,
                                  position.dx + 50,
                                  position.dy + 50,
                                ),
                                items: [
                                  PopupMenuItem(
                                    height: 35,
                                    value: 'delete',
                                    child: Row(
                                      spacing: 5,
                                      children: [
                                        Icon(Icons.delete_rounded),
                                        Text("delete".tr),
                                      ],
                                    ),
                                  ),
                                ],
                              ).then((value) {
                                if (value == 'delete') {
                                  controller.files.removeAt(index);
                                }
                              });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.file(
                                File(files[index]),
                                fit: BoxFit.cover,
                                cacheWidth: 200,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ),
            SizedBox(
              height: 50, 
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  TextButton(
                    onPressed: (){
                      Get.back(id: 1);
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
                  ElevatedButton(
                    onPressed: (){
                      Get.toNamed("/config", id: 1);
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