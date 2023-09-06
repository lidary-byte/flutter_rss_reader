import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/utils/hex_color.dart';
import 'package:get/get.dart';

/// 仿[CupertinoListSection.insetGrouped]布局
// ignore: must_be_immutable
class ListSectionGroup extends StatelessWidget {
  final String? titleText;
  final List<Widget>? children;
  bool? hasPadding;

  ListSectionGroup(
      {super.key, this.titleText, this.children, this.hasPadding}) {
    hasPadding ??= true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (titleText != null)
            Text(
              titleText ?? '',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 6),
          Card(
            elevation: 0,
            margin: const EdgeInsets.all(0),
            clipBehavior: Clip.hardEdge,
            child: Column(
              children: buildChildren(),
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildChildren() {
    if (children == null) {
      return [];
    }
    final newChildren = <Widget>[];
    for (int i = 0; i < children!.length; i++) {
      if (i == children!.length - 1) {
        newChildren.add(children![i]);
      } else {
        newChildren.add(Column(
          children: [
            children![i],
            Padding(
              padding: EdgeInsets.only(left: hasPadding == true ? 54.0 : 0.0),
              child: Container(
                height: 0.1,
                color: Get.theme.dividerColor,
              ),
            )
          ],
        ));
      }
    }
    return newChildren;
  }
}

class SectionChild extends StatelessWidget {
  final String? imagePath;
  final Color? iconColor;
  final IconData? icon;
  final String? title;
  final String? subTitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  const SectionChild(
      {super.key,
      this.imagePath,
      this.iconColor,
      this.icon,
      this.title,
      this.subTitle,
      this.trailing,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: (icon != null || imagePath != null) ? 8 : 14),
        child: Row(
          children: [
            if (icon != null || imagePath != null)
              Container(
                width: 30,
                height: 30,
                decoration: ShapeDecoration(
                    color: iconColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusDirectional.circular(6))),
                padding: EdgeInsets.all(imagePath == null ? 0 : 4),
                child: imagePath == null
                    ? Icon(icon, color: Colors.white)
                    : Image.asset(imagePath ?? '', fit: BoxFit.cover),
              ),
            if (icon != null || imagePath != null) const SizedBox(width: 12),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title ?? '',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                if (subTitle != null)
                  Text(subTitle!,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: HexColor('#8D8D8D')))
              ],
            )),
            if (trailing != null) trailing!
          ],
        ),
      ),
    );
  }
}
