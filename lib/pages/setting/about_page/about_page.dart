import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/global/global.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('about'.tr),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 24, 0, 8),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/aRead.png'),
              ),
            ),
            Center(
              child: Text(
                'aRead'.tr,
                style: const TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                applicationVersion,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () async {
                    await launchUrl(
                      Uri.parse("https://jike.city/gvenusleo"),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: Text('contactAuthor'.tr),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () async {
                    await launchUrl(
                      Uri.parse("https://github.com/gvenusleo/aRead"),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: Text('sourceAddress'.tr),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              '© 2022 - 2023 ${'aRead'.tr}. All rights reserved.',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
