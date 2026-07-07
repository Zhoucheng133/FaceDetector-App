import 'package:flutter/material.dart';
import 'package:get/get.dart';

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