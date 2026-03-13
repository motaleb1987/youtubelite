import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'full_screen_loading_overlay.dart';


class WebViewWrapper extends StatefulWidget {
  const WebViewWrapper({super.key, required this.url, required this.title});

  final String url;
  final String title;

  @override
  State<WebViewWrapper> createState() => _WebViewWrapperState();
}

class _WebViewWrapperState extends State<WebViewWrapper> {
  late final WebViewController _controller;
  final ValueNotifier<bool> _isLoading = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (_) => _isLoading.value,
          onPageFinished: (_) {
            _isLoading.value = false;
            _controller.runJavaScript('''
              var navBar = document.querySelector('ytm-pivot-bar-renderer');
              if (navBar) navBar.style.display = 'none';
            ''');
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  void dispose() {
    super.dispose();
    _isLoading.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isLoading,
      builder: (context, isLoading, child) {
        return FullScreenLoadingOverlay(
          isLoading: isLoading,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
              ),
              title: Text(widget.title),
            ),
            body: WebViewWidget(controller: _controller),
          ),
        );
      },
    );
  }
}
