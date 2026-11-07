import java.util.Properties
import java.io.FileInputStream

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
plugins {
    id("com.android.application")
    id("kotlin-android")

    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.hasan.tarsus_genc"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled = true  // EKLE

    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionName = flutter.versionName
    }
    // Her üniversite bir "flavor". Derleme: flutter build appbundle --flavor tarsus
    flavorDimensions.add("uni")
    productFlavors {
        create("tarsus") {
            dimension = "uni"
            applicationId = "com.hasan.tarsus_genc"
            versionCode = 7 // her yayında artır
            resValue("string", "app_name", "Tarsus Üniversitesi Genç Mobil")
            manifestPlaceholders["admobAppId"] = "ca-app-pub-5799565273289643~6905287212"
        }
        create("amsterdam") {
            dimension = "uni"
            applicationId = "com.hasan.amsterdam_genc"
            versionCode = 1
            resValue("string", "app_name", "UvA Student App")
            // Test uygulama kimliği: AdMob'da gerçek uygulama açınca değiştir
            manifestPlaceholders["admobAppId"] = "ca-app-pub-3940256099942544~3347511713"
        }
        create("mersin") {
            dimension = "uni"
            applicationId = "com.hasan.mersingenc"
            versionCode = 1 // Play'deki son sürüm kodunun üstüne çıkar
            resValue("string", "app_name", "Mersin Üniversitesi Genç Mobil")
            manifestPlaceholders["admobAppId"] = "ca-app-pub-5799565273289643~5736021251"
        }
    }
    signingConfigs {
        if (keystorePropertiesFile.exists()) create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    buildTypes {
        release {
            if (keystorePropertiesFile.exists()) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }}

flutter {
    source = "../.."
}
dependencies {
    implementation(platform("com.google.firebase:firebase-bom:34.7.0"))
    implementation("com.google.firebase:firebase-analytics")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")  // YENİ!


}

apply(plugin = "com.google.gms.google-services")  // ← BU SATIRI EKLE