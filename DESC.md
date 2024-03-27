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