# Flutter Proguard Rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Hive Proguard Rules
-keep class com.mongodb.** { *; }
-keep class org.bson.** { *; }
-keep class com.github.davidmoten.rtree.** { *; }
-keep class com.github.davidmoten.guavamini.** { *; }

# Generic Proguard rules
-dontwarn android.test.**
-dontwarn android.support.**
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.gms.**
-dontwarn androidx.**
