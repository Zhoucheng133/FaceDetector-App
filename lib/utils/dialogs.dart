import 'package:face_detector_app/getx/controller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

Route showFixedDialog(BuildContext context, String title, String content) {
  return DialogRoute(
    context: context, 
    barrierDismissible: false, 
    builder: (context)=>AlertDialog(
      title: Text(title),
      content: Row(
        crossAxisAlignment: .center,
        mainAxisSize: .min,
        spacing: 10,
        children: [
          Text(content),
          SizedBox(
            height: 20,
            width: 20,
            child: const CircularProgressIndicator(strokeWidth: 2)
          )
        ],
      ),
    )
  );
}

Future<void> showOkDialog(BuildContext context, String title, String content, {String okText="ok"}) async {
  await showDialog(
    context: context, 
    builder: (context)=>AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: ()=>Navigator.of(context).pop(), 
          child: Text(okText.tr)
        )
      ],
    )
  );
}

Future<bool?> showConfirmDialog(BuildContext context, String title, Widget content, {String okText="ok", String cancelText="cancel"}) async {
  return await showDialog(
    context: context, 
    builder: (context)=>AlertDialog(
      title: Text(title),
      content: content,
      actions: [
        TextButton(
          onPressed: ()=>Navigator.of(context).pop(false),
          child: Text(cancelText.tr)
        ),
        ElevatedButton(
          onPressed: ()=>Navigator.of(context).pop(true),
          child: Text(okText.tr)
        )
      ]
    )
  );
}
Future<void> showAbout(BuildContext context) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  if(context.mounted){
    showDialog(
      context: context, 
      builder: (BuildContext context)=>AlertDialog(
        title: Text('about'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon.png',
              width: 100,
            ),
            const SizedBox(height: 10,),
            const Text(
              'FaceDetector',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 3,),
            Text(
              'v${packageInfo.version}',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[400]
              ),
            ),
            const SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                final url=Uri.parse('https://github.com/Zhoucheng133/FaceDetector-App');
                launchUrl(url);
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.github,
                      size: 15,
                    ),
                    const SizedBox(width: 5,),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        'projectURL'.tr,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 5),
            GestureDetector(
              onTap: ()=>showLicensePage(
                applicationName: 'FaceDetector',
                applicationVersion: packageInfo.version,
                context: context
              ),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.certificate,
                      size: 15,
                    ),
                    const SizedBox(width: 5,),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        'license'.tr,
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
            }, 
            child: Text('ok'.tr)
          )
        ],
      ),
    );
  }
}

void selectLanguage(BuildContext context){
  final Controller c=Get.find();
  showDialog(
    context: context, 
    builder: (context)=>AlertDialog(
      title: Text('language'.tr),
      content: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton(
            focusColor: Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            value: c.lang.value.name,
            items: supportedLocales.map((item)=>DropdownMenuItem<String>(
              value: item.name,
              child: Text(
                item.name
              ),
            )).toList(),
            onChanged: (val){
              final index=supportedLocales.indexWhere((element) => element.name==val);
              c.changeLanguage(index);
            },
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            Navigator.pop(context);
          }, 
          child: Text('ok'.tr)
        )
      ],
    ),
  );
}