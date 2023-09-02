import 'package:flutter/material.dart';
import 'package:flutter_rss_reader/models/post.dart';

// 定义用于展示 Post 的 Widget
class PostContainer extends StatelessWidget {
  const PostContainer({Key? key, required this.post}) : super(key: key);
  final Post post;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            post.title,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (post.read)
                Icon(
                  Icons.circle,
                  size: 15,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              if (post.favorite)
                Icon(
                  Icons.bookmark,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              Text(
                post.feedName,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
              Text(
                post.pubDate.substring(0, 16),
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
