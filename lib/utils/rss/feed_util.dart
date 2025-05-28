import 'package:readability/readability.dart';

class FeedUtil {
  static Future<String> parseToText(String? url) async {
    if (url == null || url.isEmpty) {
      return '';
    }
    var result = await parseAsync(url);
    return result.textContent ?? '';
  }

  static String? findThumbnail(String? text) {
    if (text == null || text.isEmpty) return null;

    final enclosureMatch = _enclosureRegex.firstMatch(text);
    if (enclosureMatch != null && enclosureMatch.group(1)?.isNotEmpty == true) {
      return enclosureMatch.group(1);
    }

    final imgMatch = _imgRegex.firstMatch(text);
    final imgSrc = imgMatch?.group(2);
    if (imgSrc != null && !imgSrc.startsWith("data:")) {
      return imgSrc;
    }

    return null;
  }

  static final RegExp _enclosureRegex = RegExp(
    r'<enclosure\s+url="([^"]+)"\s+type=".*"\s*/>',
  );
  static final RegExp _imgRegex = RegExp(
    "img.*?src=([\"'])((?!data).*?)\\1",
    // caseSensitive: false,
    dotAll: true,
  );
}
