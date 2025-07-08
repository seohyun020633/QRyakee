// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class WebViewPage extends StatelessWidget {
//   final String url;
//   final String title;

//   const WebViewPage({super.key, required this.url, this.title = '웹뷰'});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(title)),
//       body: WebViewWidget(controller: WebViewController()
//         ..setJavaScriptMode(JavaScriptMode.unrestricted)
//         ..loadRequest(Uri.parse(url))),
//     );
//   }
// }