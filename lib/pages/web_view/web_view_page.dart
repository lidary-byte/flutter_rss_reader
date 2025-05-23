import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_rss_reader/pages/web_view/web_view_controller.dart';
import 'package:get/get.dart';

class WebViewPage extends StatelessWidget {
  WebViewPage({super.key});
  final _controller = Get.put(WebViewController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GetBuilder<WebViewController>(
          id: 'app_bar',
          builder: (_) => Text(_controller.title),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            GetBuilder<WebViewController>(
              id: 'progress',
              builder: (_) => AnimatedOpacity(
                opacity: _controller.progress >= 1 ? 0.0 : 1.0, // 控制可见性
                duration: const Duration(milliseconds: 500), // 动画持续时间
                child: LinearProgressIndicator(value: _controller.progress),
              ),
            ),
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(_controller.url)),
              ),
              // onProgressChanged: (controller, progress) =>
              //     _controller.setProgress(progress),
              // onTitleChanged: (controller, title) => _controller.setTitle(title),
            ),
          ],
        ),
      ),
    );
  }
}
