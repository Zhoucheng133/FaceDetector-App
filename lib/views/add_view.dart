import 'package:face_detector_app/getx/controller.dart';
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: .min,
        spacing: 10,
        children: [
          Row(
            spacing: 5,
            mainAxisSize: .min,
            children: [
              TextButton(
                onPressed: (){}, 
                child: Text("selectImage".tr)
              ),
              ElevatedButton(
                onPressed: (){}, 
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
    );
  }
}