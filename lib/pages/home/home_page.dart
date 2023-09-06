import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/home/home_controller.dart';
import 'package:flutter_rss_reader/theme/custom_theme.dart';
import 'package:flutter_rss_reader/widgets/anim_index_stack.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final _controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: GetBuilder<HomeController>(builder: (_) {
          final colors = Theme.of(context).extension<CustomTheme>()!;
          return AnimatedBottomNavigationBar(
            icons: const [
              Icons.home,
              Icons.settings,
            ],
            backgroundColor: Get.theme.bottomAppBarTheme
                .color, //colors.bottomNavigationBarBackgroundColor,
            activeColor: colors.activeNavigationBarColor,
            splashColor: colors.activeNavigationBarColor,
            inactiveColor: colors.notActiveNavigationBarColor,
            activeIndex: _controller.index,
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.verySmoothEdge,
            leftCornerRadius: 16,
            rightCornerRadius: 16,
            onTap: _controller.changeIndex,
          );
        }),
        body: SafeArea(
            top: false,
            child: GetBuilder<HomeController>(
                builder: (_) => AnimatedIndexedStack(
                    index: _controller.index, children: _controller.pages))));
  }
}
