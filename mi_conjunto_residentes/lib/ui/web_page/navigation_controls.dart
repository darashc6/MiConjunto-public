import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Clase de controles de navegacion del webview
class NavigationControls extends StatelessWidget {
  const NavigationControls(this.webViewControllerFuture)
      : assert(webViewControllerFuture != null);

  final Future<WebViewController> webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final WebViewController controller = snapshot.data;

          return Row(
            children: <Widget>[
              IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () async => (await controller.canGoBack())
                      ? await controller.goBack()
                      : null),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () async => (await controller.canGoForward())
                    ? await controller.goForward()
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.replay),
                onPressed: () {
                  controller.reload();
                },
              ),
            ],
          );
        }

        return Container();
      },
    );
  }
}
