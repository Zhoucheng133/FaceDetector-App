import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:face_detector_app/getx/controller.dart';
import 'package:face_detector_app/utils/dialogs.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {

  final Controller controller = Get.find();

  bool loading = false;

  static const _imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp', '.tiff', '.tif'];

  void pickImage(BuildContext context) async {
    FilePickerResult? result = await FilePicker.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result != null) {
      for (var file in result.files) {
        if (file.path != null) {
          controller.files.add(file.path!);
        }
      }
      if(controller.files.isEmpty && context.mounted){
        showOkDialog(context, "addFailed".tr, "noImageFiles".tr);
      }
    }
    if(controller.files.isNotEmpty){
      Get.toNamed("/preview", id: 1);
    }
  }

  Future<void> pickDir(BuildContext context) async {
    String? selectedDirectory = await FilePicker.getDirectoryPath();
    if (selectedDirectory != null) {
      final dir = Directory(selectedDirectory);
      final entities = dir.listSync(recursive: true);
      for (var entity in entities) {
        if (entity is File) {
          final ext = p.extension(entity.path).toLowerCase();
          if (_imageExtensions.contains(ext)) {
            controller.files.add(entity.path);
          }
        }
      }
      if(controller.files.isEmpty && context.mounted){
        showOkDialog(context, "addFailed".tr, "noImageFiles".tr);
      }
    }

    if(controller.files.isNotEmpty){
      Get.toNamed("/preview", id: 1);
    }
  }

  void dropHandler(DropDoneDetails details, BuildContext context) {
    List<DropItem> files = [];
    List<DropItem> dirs = [];

    for (var item in details.files) {
      final path=item.path;
      if (item is DropItemDirectory || Directory(path).existsSync()) {
        dirs.add(item);
      } else {
        files.add(item);
      }
    }

    for (var file in files) {
      final ext = p.extension(file.path).toLowerCase();
      if (_imageExtensions.contains(ext)) {
        controller.files.add(file.path);
      }
    }

    if (dirs.isNotEmpty) {
      final dir = Directory(dirs.first.path);
      final entities = dir.listSync(recursive: true);
      for (var entity in entities) {
        if (entity is File) {
          final ext = p.extension(entity.path).toLowerCase();
          if (_imageExtensions.contains(ext)) {
            controller.files.add(entity.path);
          }
        }
      }
    }

    if(controller.files.isEmpty){
      showOkDialog(context, "addFailed".tr, "noImageFiles".tr);
    }else{
      Get.toNamed("/preview", id: 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (details)=>dropHandler(details, context),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: .min,
              spacing: 10,
              children: [
                Row(
                  spacing: 5,
                  mainAxisSize: .min,
                  children: [
                    TextButton(
                      onPressed: ()=>pickImage(context), 
                      child: Text("selectImage".tr)
                    ),
                    ElevatedButton(
                      onPressed: ()=>pickDir(context), 
                      child: Text("selectDir".tr)
                    )
                  ],
                ),
                Text(
                  "dropTip".tr,
                  style: TextStyle(
                    color: Colors.grey[400]
                  ),
                )
              ],
            ),
          ),
          Positioned(
            right: 30,
            bottom: 30,
            child: Row(
              mainAxisSize: .min,
              mainAxisAlignment: .center,
              crossAxisAlignment: .center,
              children: [
                FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)
                      )
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  ),
                  onPressed: ()=>selectLanguage(context), 
                  child: Row(
                    mainAxisSize: .min,
                    children: [
                      Icon(Icons.translate_rounded),
                      SizedBox(width: 5,),
                      Text("language".tr),
                    ],
                  )
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                      )
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  ),
                  onPressed: ()=>showAbout(context), 
                  child: Row(
                    mainAxisSize: .min,
                    children: [
                      Icon(Icons.info_rounded),
                      SizedBox(width: 5,),
                      Text("about".tr),
                    ],
                  )
                ),
              ],
            )
          )
        ],
      ),
    );
  }
}