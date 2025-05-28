import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/bean/rss_item_bean.dart';

// 定义用于展示 Post 的 Widget
class ItemRssWidget extends StatelessWidget {
  const ItemRssWidget({super.key, required this.rssItem});
  final RssItemBean rssItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ListTile(
            title: Text(
              '${rssItem.title}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              rssItem.shortDescription ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        if (rssItem.cover != null && rssItem.cover?.isNotEmpty == true)
          CachedNetworkImage(
            imageUrl: rssItem.cover ?? '',
            width: 100,
            height: 100,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => SizedBox(
              width: 80,
              height: 80,
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
      ],
    );
  }
}
