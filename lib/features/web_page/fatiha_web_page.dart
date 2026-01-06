import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FatihaWebPage extends StatefulWidget {
  final Color primaryColor;

  const FatihaWebPage({
    super.key,
    required this.primaryColor,
  });

  @override
  State<FatihaWebPage> createState() => _FatihaWebPageState();
}

class _FatihaWebPageState extends State<FatihaWebPage> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)

      ..setUserAgent(
        Platform.isIOS
            ? 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_0 like Mac OS X) '
            'AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 '
            'Mobile/15E148 Safari/604.1'
            : null,
      )

      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
          onWebResourceError: (error) {
            debugPrint('Fatiha WebView error: $error');
          },
        ),
      )
      ..loadRequest(Uri.parse('https://fatiha.prh.gov.sa/home'));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_loading)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
