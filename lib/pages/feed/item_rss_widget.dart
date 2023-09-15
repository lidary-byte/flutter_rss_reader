import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/bean/rss_item_bean.dart';
import 'package:flutter_rss_reader/utils/diff_time_util.dart';
import 'package:flutter_rss_reader/utils/web_feed_desc_util.dart';
import 'package:get/get.dart';

// 定义用于展示 Post 的 Widget
class ItemRssWidget extends StatelessWidget {
  const ItemRssWidget({Key? key, required this.rssItem}) : super(key: key);
  final RssItemBean rssItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  rssItem.title ?? '',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: rssItem.read
                          ? Colors.grey
                          : Get.theme.appBarTheme.foregroundColor),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  WebFeedDescUtil.stripHtmlIfNeeded(rssItem.description ?? ''),
                  style: TextStyle(
                      fontSize: 14,
                      color: rssItem.read
                          ? Colors.grey
                          : Get.theme.appBarTheme.foregroundColor),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (!rssItem.read)
                      Icon(
                        Icons.circle,
                        size: 15,
                        color: Theme.of(context).primaryColor,
                      ),
                    const SizedBox(width: 6),
                    if (rssItem.favorite)
                      Icon(
                        Icons.bookmark,
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    const SizedBox(width: 6),
                    Expanded(
                        child: Text(
                      rssItem.author ?? '',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12,
                          color: rssItem.read
                              ? Colors.grey
                              : Get.theme.appBarTheme.foregroundColor),
                    )),
                    const SizedBox(width: 6),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        rssItem.pubDate.calculateTimeDifference(),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12,
                            color: rssItem.read
                                ? Colors.grey
                                : Get.theme.appBarTheme.foregroundColor),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          if (rssItem.cover != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Card(
                color: Colors.transparent,
                child: CachedNetworkImage(
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  imageUrl: rssItem.cover!,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
