![flutter_rss_reader](https://github.com/lidary-byte/flutter_rss_reader/blob/main/ARead%20res/logo1.png)

# flutter_rss_reader

基于flutter的rss阅读器
<img src="https://github.com/lidary-byte/flutter_rss_reader/blob/main/ARead%20res/screen_1.jpg" alt="描述" width="800" height="1200">
# 截图
![首页](https://github.com/lidary-byte/flutter_rss_reader/blob/main/ARead%20res/screen_1.jpg)
![设置](https://github.com/lidary-byte/flutter_rss_reader/blob/main/ARead%20res/%E8%AE%BE%E7%BD%AE.png)
![内置源](https://github.com/lidary-byte/flutter_rss_reader/blob/main/ARead%20res/%E5%86%85%E7%BD%AE%E6%BA%90.png)
![Feed流](https://github.com/lidary-byte/flutter_rss_reader/blob/main/ARead%20res/feed%E6%B5%81.png)
![阅读页面](https://github.com/lidary-byte/flutter_rss_reader/blob/main/ARead%20res/Frame%206.png)


# 打包命令
```
flutter build apk --split-per-abi
flutter build appbundle
```

# 自动打包
## 安卓包
```
flutter_distributor release --name dev --jobs aread-android
```
## iOS包
```
flutter_distributor release --name dev --jobs aread-ios
```
 ## iOS及安卓包
```
flutter_distributor release --name dev
```
#
isar命令
```
flutter pub run build_runner build
```

 

