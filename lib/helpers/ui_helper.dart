import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

import '../Util/constants/constants.dart';
import '../Widgets/text_widget.dart';

class UIHelper {
  static void showNotification(String message,
      {Color backgroundColor = Colors.red,
      Duration duration = const Duration(milliseconds: 2500)}) {
    showOverlayNotification(
        (context) => Material(
              color: Colors.transparent,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () => OverlaySupportEntry.of(context)!.dismiss(),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: Constants.padding * 3,
                        vertical: Constants.padding * 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: backgroundColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 7),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Center(
                        child: TextWidget(
                          message,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        duration: duration);
  }
}
