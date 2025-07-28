# Keep Firebase classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep ObjectBox classes
-keep class io.objectbox.** { *; }
-keep @io.objectbox.annotation.Entity class * { *; }

# Keep GetX classes
-keep class com.jakewharton.rxbinding.** { *; }

# Flutter specific
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Google Fonts
-keep class com.google.** { *; }

# Google Play Core - needed for Flutter deferred components
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**

# Fix for R8 reflection warnings
-dontwarn java.lang.reflect.AnnotatedType

# Crashlytics
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception