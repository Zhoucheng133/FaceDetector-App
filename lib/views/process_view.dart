import 'dart:io';

import 'package:face_detector_app/getx/controller.dart';
import 'package:face_detector_app/getx/middleware.dart';
import 'package:face_detector_app/utils/detector.dart';
import 'package:face_detector_app/utils/dialogs.dart';
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

  final Detector detector = Detector();

  Future<void> onProcessDone(BuildContext context) async {
    if(context.mounted){
      if(middleware.processArg.value?.action==ImageAction.draw){
        showOkDialog(context, "processDone".tr, "");
        return;
      }

      final isPortrait=middleware.processArg.value?.imageType==ImageTypes.portrait;
      final filteredIndices=<int>[];
      for(int i=0;i<controller.files.length&&i<controller.faces.length;i++){
        if(isPortrait){
          if(controller.faces[i]>0) filteredIndices.add(i);
        }else{
          if(controller.faces[i]==0) filteredIndices.add(i);
        }
      }
      
      if(middleware.processArg.value?.action==ImageAction.copyTo){
        final ok=await showConfirmDialog(
          context, 
          "copyFiles".tr, 
          SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(
              itemCount: filteredIndices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(p.basename(controller.files[filteredIndices[index]])),
                );
              }
            ),
          ),
          okText: "copy"
        );
        if(ok==true && context.mounted){
          for(final i in filteredIndices){
            await File(controller.files[i]).copy(
              p.join(middleware.processArg.value!.path, p.basename(controller.files[i]))
            );
          }
          if(context.mounted) showOkDialog(context, "processDone".tr, "");
        }
      }else if(middleware.processArg.value?.action==ImageAction.moveTo){
        final ok=await showConfirmDialog(
          context, 
          "moveFiles".tr, 
          SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(
              itemCount: filteredIndices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(p.basename(controller.files[filteredIndices[index]])),
                );
              }
            ),
          ),
          okText: "move"
        );
        if(ok==true && context.mounted){
          for(final i in filteredIndices){
            await File(controller.files[i]).rename(
              p.join(middleware.processArg.value!.path, p.basename(controller.files[i]))
            );
          }
          if(context.mounted) showOkDialog(context, "processDone".tr, "");
        }
      }else if(middleware.processArg.value?.action==ImageAction.delete){
        final ok=await showConfirmDialog(
          context, 
          "deleteFiles".tr, 
          SizedBox(
            height: 300,
            width: 300,
            child: ListView.builder(
              itemCount: filteredIndices.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(p.basename(controller.files[filteredIndices[index]])),
                );
              }
            ),
          ),
          okText: "delete"
        );
        if(ok==true && context.mounted){
          for(final i in filteredIndices){
            await File(controller.files[i]).delete();
          }
          if(context.mounted) showOkDialog(context, "processDone".tr, "");
        }
      }
    }
  }

  Future<void> process(BuildContext context) async {
    await detector.run(()=>onProcessDone(context));
  }

  @override
  void initState() {
    super.initState();
    controller.running.value=true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      process(context);
    });
  }

  Widget trailingBuilder(BuildContext context, int index) {
    if(controller.running.value){
      if(controller.faces.length==index){
        return SizedBox(
          height: 20,
          width: 20,
          child: const CircularProgressIndicator(strokeWidth: 2)
        );
      }else if(controller.faces.length>index){
        return Row(
          mainAxisSize: .min,
          spacing: 5,
          children: [
            Icon(Icons.face_rounded),
            Text(controller.faces[index].toString()),
          ],
        );
      }else{
        return Icon(Icons.hourglass_empty_rounded);
      }
    }else{
      if(controller.faces.length>index){
        return Row(
          mainAxisSize: .min,
          spacing: 5,
          children: [
            Icon(Icons.face_rounded),
            Text(controller.faces[index].toString()),
          ],
        );
      }else{
        return Icon(Icons.close_rounded);
      }
    }
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
                  itemBuilder: (BuildContext context, int index)=>Obx(
                    () => ListTile(
                      title: Text(p.basename(controller.files[index])),
                      trailing: trailingBuilder(context, index)
                    ),
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
                              Get.until((route) => route.isFirst, id: 1);
                              controller.files.clear();
                              controller.faces.value=[];
                            }, 
                            child: Row(
                              mainAxisSize: .min,
                              spacing: 5,
                              children: [
                                Icon(Icons.home_rounded),
                                Text("backHome".tr),
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