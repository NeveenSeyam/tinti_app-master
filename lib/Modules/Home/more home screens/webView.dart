// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

// class MyWebView extends StatefulWidget {
//   final String url;

//   MyWebView({required this.url});

//   @override
//   _MyWebViewState createState() => _MyWebViewState();
// }

// class _MyWebViewState extends State<MyWebView> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//      home: WebviewScaffold(
//             url: selectedUrl,
//             javascriptChannels: jsChannels,
//             mediaPlaybackRequiresUserGesture: false,
//             appBar: AppBar(
//               title: const Text('Widget WebView'),
//             ),
//             withZoom: true,
//             withLocalStorage: true,
//             hidden: true,
//             initialChild: Container(
//               color: Colors.redAccent,
//               child: const Center(
//                 child: Text('Waiting.....'),
//               ),
//             ),),
//     );
//   }
// }
