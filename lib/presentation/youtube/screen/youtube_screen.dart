import 'package:flutter/material.dart';

import '../../core/widgets/web_view_wrapper.dart';

class YoutubeScreen extends StatelessWidget {
  const YoutubeScreen({super.key, required this.url, required this.title});
  final String url;
  final String title;


  @override
  Widget build(BuildContext context) {
    return WebViewWrapper(url: url, title: title);
  }
}
