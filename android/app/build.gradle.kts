import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

configurations.configureEach {
    resolutionStrategy.eachDependency {
        when (requested.group) {
            "androidx.camera" -> {
                if (
                    requested.name == "camera-core" ||
                    requested.name == "camera-camera2" ||
                    requested.name == "camera-lifecycle" ||
                    requested.name == "camera-view"
                ) {
                    useVersion("1.4.2")
                    because("Use CameraX binaries with 16 KB page-size compatible native libs")
                }
            }

            "com.google.mlkit" -> {
                if (requested.name == "barcode-scanning") {
                    useVersion("17.3.0")
                    because("Use ML Kit barcode binaries compatible with 16 KB page-size requirement")
                }
            }

            "com.google.android.gms" -> {
                if (requested.name == "play-services-mlkit-barcode-scanning") {
                    useVersion("18.3.1")
                    because("Use Play Services ML Kit barcode binaries compatible with 16 KB page-size requirement")
                }
            }
        }
    }
}

android {
    namespace = "com.ajmal.quickscanpro"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlin {
        jvmToolchain(17)
        compilerOptions {
            jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
        }
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.ajmal.quickscanpro"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = 24
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        ndk {
            abiFilters += listOf("arm64-v8a", "x86_64")
        }
    }

    signingConfigs {
        if (keystorePropertiesFile.exists()) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            // Use upload/release key for Play Store builds when key.properties is present.
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    packaging {
        jniLibs {
            excludes += listOf("**/armeabi-v7a/*.so")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
