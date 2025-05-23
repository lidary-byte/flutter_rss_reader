// plugins {
//     id "com.android.application"
//     id "kotlin-android"
//     id "dev.flutter.flutter-gradle-plugin" 
// }

// def localProperties = new Properties()
// def localPropertiesFile = rootProject.file('local.properties')
// if (localPropertiesFile.exists()) {
//     localPropertiesFile.withReader('UTF-8') { reader ->
//         localProperties.load(reader)
//     }
// }

// def flutterVersionCode = localProperties.getProperty('flutter.versionCode')
// if (flutterVersionCode == null) {
//     flutterVersionCode = '1'
// }

// def flutterVersionName = localProperties.getProperty('flutter.versionName')
// if (flutterVersionName == null) {
//     flutterVersionName = '1.0'
// }

// android {
//     namespace "com.lidary.reader.flutter_rss_reader"
//     compileSdkVersion flutter.compileSdkVersion
//     ndkVersion flutter.ndkVersion

//     compileOptions {
//         sourceCompatibility JavaVersion.VERSION_1_8
//         targetCompatibility JavaVersion.VERSION_1_8
//     }

//     kotlinOptions {
//         jvmTarget = '1.8'
//     }

//     sourceSets {
//         main.java.srcDirs += 'src/main/kotlin'
//     }

//     defaultConfig {
//         // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
//         applicationId "com.lidary.reader.flutter_rss_reader"
//         // You can update the following values to match your application needs.
//         // For more information, see: https://docs.flutter.dev/deployment/android#reviewing-the-gradle-build-configuration.
//         minSdkVersion 21//flutter.minSdkVersion
//         targetSdkVersion flutter.targetSdkVersion
//         versionCode flutterVersionCode.toInteger()
//         versionName flutterVersionName
//     }

// signingConfigs {
//     release {
//         storeFile file('../lidary-android.jks')
//         storePassword '123456'       
//         keyAlias 'key0'                    
//         keyPassword '123456'               
//     }
// }

//     buildTypes {
//         release { 
//             signingConfig signingConfigs.release
//         }
//     }
// }

// flutter {
//     source '../..'
// }

// dependencies {}

// tasks.withType(JavaCompile) {
//     options.encoding = "UTF-8"
// }


plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.lidary.reader.flutter_rss_reader"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.lidary.reader.flutter_rss_reader"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
