import 'package:desktop_drop/desktop_drop.dart';
import 'package:face_detector_app/getx/controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddView extends StatefulWidget {
  const AddView({super.key});

  @override
  State<AddView> createState() => _AddViewState();
}

class _AddViewState extends State<AddView> {

  final Controller controller = Get.find();

  bool loading = false;

  void pickImage() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result != null) {

    }
  }

  Future<void> pickDir() async {
    String? selectedDirectory = await FilePicker.getDirectoryPath();
    if (selectedDirectory != null) {
      
    }
  }

  void dropHandler(DropDoneDetails details) {
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragDone: (details)=>dropHandler(details),
      child: Center(
        child: Column(
          mainAxisSize: .min,
          spacing: 10,
          children: [
            Row(
              spacing: 5,
              mainAxisSize: .min,
              children: [
                TextButton(
                  onPressed: ()=>pickImage(), 
                  child: Text("selectImage".tr)
                ),
                ElevatedButton(
                  onPressed: ()=>pickDir(), 
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
    );
  }
}