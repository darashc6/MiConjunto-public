import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mi_conjunto_residentes/provider/resident_provider.dart';
import 'package:mi_conjunto_residentes/ui/common/orange_gradient_container.dart';
import 'package:mi_conjunto_residentes/ui/web_page/navigation_controls.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Clase de WebPage
class WebPagePage extends StatelessWidget {
  WebPagePage();

  final Completer<WebViewController> controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    final _residentData = context.watch<ResidentProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        flexibleSpace: OrangeGradientContainer(),
        actions: [NavigationControls(controller.future)],
      ),
      body: WebView(
        initialUrl: _residentData.getResident.webPage,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (webViewController) {
          controller.complete(webViewController);
        },
      ),
    );
  }
}
