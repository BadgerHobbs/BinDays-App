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

// libcurl-impersonate native library (the impersonate HTTP transport).
// Downloaded from the upstream lexiforest/curl-impersonate release pinned in
// `native_libs.version`, plus libc++_shared.so from the NDK, extracted into
// jniLibs at build time — binaries are not vendored in this repo. To update,
// bump native_libs.version (and keep it in sync with the dio_impersonate dep).
val curlImpersonateVersion = rootProject.file("../native_libs.version").readText().trim()
val impersonateJniLibs = file("src/main/jniLibs")
// Android ABI -> upstream release target triple.
val impersonateAbiTriples = mapOf(
    "arm64-v8a" to "aarch64-linux-android",
    "x86_64" to "x86_64-linux-android",
)
val downloadImpersonateLibs = tasks.register("downloadImpersonateLibs") {
    val marker = file("${impersonateJniLibs}/.impersonate-version")
    outputs.dir(impersonateJniLibs)
    doLast {
        if (marker.exists() && marker.readText().trim() == curlImpersonateVersion) return@doLast
        val prebuilt = file("${android.ndkDirectory}/toolchains/llvm/prebuilt")
            .listFiles()!!.first { it.isDirectory }
        impersonateAbiTriples.forEach { (abi, triple) ->
            val url =
                "https://github.com/lexiforest/curl-impersonate/releases/download/" +
                "v$curlImpersonateVersion/libcurl-impersonate-v$curlImpersonateVersion.$triple.tar.gz"
            val tgz = File(temporaryDir, "$abi.tar.gz")
            ant.withGroovyBuilder { "get"("src" to url, "dest" to tgz) }
            val abiDir = file("${impersonateJniLibs}/$abi")
            copy {
                from(tarTree(resources.gzip(tgz)))
                include("libcurl-impersonate.so")
                into(abiDir)
            }
            // The .so links against libc++_shared.so; ship the NDK's copy.
            copy {
                from("$prebuilt/sysroot/usr/lib/$triple/libc++_shared.so")
                into(abiDir)
            }
        }
        marker.writeText(curlImpersonateVersion)
    }
}
tasks.named("preBuild") { dependsOn(downloadImpersonateLibs) }
