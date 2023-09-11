import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/bean/rss_item_bean.dart';

// 定义用于展示 Post 的 Widget
class PostContainer extends StatelessWidget {
  const PostContainer({Key? key, required this.rssItem}) : super(key: key);
  final RssItemBean rssItem;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            rssItem.title ?? '',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (!rssItem.read)
                Icon(
                  Icons.circle,
                  size: 15,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              if (rssItem.favorite)
                Icon(
                  Icons.bookmark,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              Text(
                rssItem.feedName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                //post.pubDate.substring(0, 16),
                '${rssItem.pubDate}',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
    );
  }
}
