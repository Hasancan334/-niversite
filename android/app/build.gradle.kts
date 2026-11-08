import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")

    id("dev.flutter.flutter-gradle-plugin")
}

// Her flavor kendi anahtar dosyasını kullanır (android/ klasöründe):
//   key-tarsus.properties, key-mersin.properties, key-amsterdam.properties
// Tarsus ve Mersin için bulunamazsa eski key.properties kullanılır.
// Amsterdam için YALNIZCA key-amsterdam.properties (yanlış anahtarla imzalamayı önler).
fun loadKeyProps(names: List<String>): Properties? {
    for (n in names) {
        val f = rootProject.file(n)
        if (f.exists()) {
            val p = Properties()
            FileInputStream(f).use { p.load(it) }
            return p
        }
    }
    return null
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
    signingConfigs {
        val anahtarDosyalari = mapOf(
            "tarsus" to listOf("key-tarsus.properties", "key.properties"),
            "mersin" to listOf("key-mersin.properties", "key.properties"),
            "amsterdam" to listOf("key-amsterdam.properties")
        )
        for ((flavor, dosyalar) in anahtarDosyalari) {
            val p = loadKeyProps(dosyalar)
            if (p != null) {
                create(flavor + "Release") {
                    keyAlias = p["keyAlias"] as String
                    keyPassword = p["keyPassword"] as String
                    storeFile = file(p["storeFile"] as String)
                    storePassword = p["storePassword"] as String
                }
            }
        }
    }
    // Her üniversite bir "flavor". Derleme: flutter build appbundle --flavor tarsus
    flavorDimensions.add("uni")
    productFlavors {
        create("tarsus") {
            dimension = "uni"
            signingConfig = signingConfigs.findByName("tarsusRelease")
            applicationId = "com.hasan.tarsus_genc"
            versionCode = 7 // her yayında artır
            resValue("string", "app_name", "Tarsus Üniversitesi Genç Mobil")
            manifestPlaceholders["admobAppId"] = "ca-app-pub-5799565273289643~6905287212"
        }
        create("amsterdam") {
            dimension = "uni"
            signingConfig = signingConfigs.findByName("amsterdamRelease")
            applicationId = "com.hasan.amsterdam_genc"
            versionCode = 1
            resValue("string", "app_name", "UvA Student App")
            manifestPlaceholders["admobAppId"] = "ca-app-pub-5799565273289643~5234613327"
        }
        create("mersin") {
            dimension = "uni"
            signingConfig = signingConfigs.findByName("mersinRelease")
            applicationId = "com.hasan.mersingenc"
            versionCode = 1 // Play'deki son sürüm kodunun üstüne çıkar
            resValue("string", "app_name", "Mersin Üniversitesi Genç Mobil")
            manifestPlaceholders["admobAppId"] = "ca-app-pub-5799565273289643~5736021251"
        }
    }
}

flutter {
    source = "../.."
}
dependencies {
    implementation(platform("com.google.firebase:firebase-bom:34.7.0"))
    implementation("com.google.firebase:firebase-analytics")
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")  // YENİ!


}

apply(plugin = "com.google.gms.google-services")  // ← BU SATIRI EKLE