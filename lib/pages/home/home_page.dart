import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/pages/home/home_controller.dart';
import 'package:flutter_rss_reader/utils/hex_color.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final _controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: GetBuilder<HomeController>(
            builder: (_) => AnimatedBottomNavigationBar(
                  icons: const [
                    Icons.home,
                    Icons.settings,
                  ],
                  activeColor: HexColor('#FFA400'),
                  splashColor: HexColor('#FFA400'),
                  activeIndex: _controller.index,
                  gapLocation: GapLocation.center,
                  notchSmoothness: NotchSmoothness.verySmoothEdge,
                  leftCornerRadius: 32,
                  rightCornerRadius: 32,
                  onTap: _controller.changeIndex,
                )),
        body: SafeArea(
          child: PageTransitionSwitcher(
              child:
                  GetBuilder<HomeController>(builder: (_) => _controller.page),
              transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
                return SharedAxisTransition(
                    child: child,
                    animation: primaryAnimation,
                    secondaryAnimation: secondaryAnimation,
                    transitionType: SharedAxisTransitionType.scaled);
              }),
        ));
  }
}
