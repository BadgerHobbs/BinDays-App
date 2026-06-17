import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    namespace = "com.bindays.app.release"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973" // previously: flutter.ndkVersion

    compileOptions {
        // Required for flutter local notifications
        // Flag to enable support for the new language APIs
        isCoreLibraryDesugaringEnabled = true

        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.bindays.app.release"

        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // Required for flutter local notifications
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

dependencies {
    // Required for flutter local notifications
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

flutter {
    source = "../.."
}

// libcurl-impersonate native library (the impersonate HTTP transport), bundled
// into the APK from the prebuilt jniLibs archive published by the bindays_client
// repo (each ABI's libcurl-impersonate.so paired with libc++_shared.so). The
// version is the single source of truth in bindays_client's native_libs.version,
// resolved here via the Dart package config so the app never pins it separately.
// To update, bump native_libs.version in bindays_client and re-run its
// publish-native-libs workflow. Binaries are not vendored in this repo.
val impersonateJniLibs = file("src/main/jniLibs")

// Locate the resolved bindays_client package via the Dart package config, then
// read the native library version it pins.
val bindaysClientDir: File = run {
    val pkgConfig = rootProject.file("../.dart_tool/package_config.json")
    require(pkgConfig.exists()) {
        "package_config.json not found; run `flutter pub get` first."
    }
    @Suppress("UNCHECKED_CAST")
    val parsed = groovy.json.JsonSlurper().parseText(pkgConfig.readText()) as Map<String, Any>
    @Suppress("UNCHECKED_CAST")
    val packages = parsed["packages"] as List<Map<String, Any>>
    val rootUri = packages.first { it["name"] == "bindays_client" }["rootUri"] as String
    if (rootUri.startsWith("file:")) File(java.net.URI(rootUri))
    else File(pkgConfig.parentFile, rootUri).canonicalFile
}
val curlImpersonateVersion = File(bindaysClientDir, "native_libs.version").readText().trim()

val downloadImpersonateLibs = tasks.register("downloadImpersonateLibs") {
    val marker = file("${impersonateJniLibs}/.impersonate-version")
    outputs.dir(impersonateJniLibs)
    doLast {
        if (marker.exists() && marker.readText().trim() == curlImpersonateVersion) return@doLast
        val url =
            "https://github.com/BadgerHobbs/BinDays-Client/releases/download/" +
            "native-v$curlImpersonateVersion/android-jniLibs-v$curlImpersonateVersion.tar.gz"
        val tgz = File(temporaryDir, "android-jniLibs.tar.gz")
        ant.withGroovyBuilder { "get"("src" to url, "dest" to tgz) }
        // Replace any previous ABI dirs with the freshly downloaded bundle.
        impersonateJniLibs.listFiles()?.filter { it.isDirectory }?.forEach { it.deleteRecursively() }
        copy {
            from(tarTree(resources.gzip(tgz)))
            // Bundle entries are jniLibs/<abi>/<lib>; strip the leading dir.
            eachFile { path = path.removePrefix("jniLibs/") }
            includeEmptyDirs = false
            into(impersonateJniLibs)
        }
        marker.writeText(curlImpersonateVersion)
    }
}
tasks.named("preBuild") { dependsOn(downloadImpersonateLibs) }
