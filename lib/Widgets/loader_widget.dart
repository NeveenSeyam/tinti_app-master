import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoaderWidget extends StatelessWidget {
  final Color? backgroundColor;

  const LoaderWidget({Key? key, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          color: Colors.transparent,
          height: 45,
          width: 45,
          child: LoadingIndicator(
            indicatorType: Indicator.ballClipRotate,
            colors: [backgroundColor ?? Colors.cyan],
            strokeWidth: 5,
          )),
    );
  }
}
