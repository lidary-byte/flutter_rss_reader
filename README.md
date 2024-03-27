![flutter_rss_reader](https://github.com/lidary-byte/flutter_rss_reader/blob/main/ARead%20res/logo1.png)

# flutter_rss_reader

基于flutter的rss阅读器 

![截图](https://github.com/lidary-byte/flutter_rss_reader/blob/main/ARead%20res/screen.jpg)
 


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

 

