import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget systemMenu(){
  return Platform.isMacOS ? PlatformMenuBar(
  menus: [
    PlatformMenu(
      label: "FaceDetector",
      menus: [
        PlatformMenuItemGroup(
          members: [
            PlatformMenuItem(
              label: "${'about'.tr} FaceDetector",
              onSelected: (){
                // 显示关于
              }
            )
          ]
        ),
        const PlatformMenuItemGroup(
          members: [
            PlatformProvidedMenuItem(
              enabled: true,
              type: PlatformProvidedMenuItemType.hide,
            ),
            PlatformProvidedMenuItem(
              enabled: true,
              type: PlatformProvidedMenuItemType.quit,
            ),
          ]
        ),
      ]
    ),
    PlatformMenu(
      label: "edit".tr,
      menus: [
        PlatformMenuItem(
          label: "copy".tr,
          onSelected: (){
            final focusedContext = FocusManager.instance.primaryFocus?.context;
            if (focusedContext != null) {
              Actions.invoke(focusedContext, CopySelectionTextIntent.copy);
            }
          }
        ),
        PlatformMenuItem(
          label: "paste".tr,
          onSelected: (){
            final focusedContext = FocusManager.instance.primaryFocus?.context;
            if (focusedContext != null) {
              Actions.invoke(focusedContext, const PasteTextIntent(SelectionChangedCause.keyboard));
            }
          },
        ),
        PlatformMenuItem(
          label: "selectAll".tr,
          onSelected: (){
            final focusedContext = FocusManager.instance.primaryFocus?.context;
            if (focusedContext != null) {
              Actions.invoke(focusedContext, const SelectAllTextIntent(SelectionChangedCause.keyboard));
            }
          }
        )
      ]
    ),
    PlatformMenu(
      label: "window".tr, 
      menus: [
        PlatformMenuItemGroup(
          members: [
            PlatformProvidedMenuItem(
              enabled: true,
              type: PlatformProvidedMenuItemType.minimizeWindow,
            ),
            PlatformProvidedMenuItem(
              enabled: true,
              type: PlatformProvidedMenuItemType.toggleFullScreen,
            )
          ]
        )
      ]
    )
  ]
) : Container();
}