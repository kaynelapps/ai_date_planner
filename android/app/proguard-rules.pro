# Your existing rules
-keep class com.aifun.dateideas.planadate.MainActivity { *; }
-keep class com.aifun.dateideas.planadate.** { *; }

# Flutter and plugin rules
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Google Services and Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keep public class com.google.android.gms.ads.** { public *; }
-keep public class com.google.ads.** { public *; }

# Third-party plugins
-keep class io.flutter.plugins.imagepicker.** { *; }
-keep class com.baseflow.geolocator.** { *; }
-keep class com.aboutyou.dart_packages.sign_in_with_apple.** { *; }
-keep class dev.fluttercommunity.plus.connectivity.** { *; }
-keep class io.flutter.plugins.sharedpreferences.** { *; }

# New rules for Play Core Library
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
-dontwarn com.facebook.infer.annotation.Nullsafe$Mode
-dontwarn com.facebook.infer.annotation.Nullsafe
# Keep important attributes
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable

# Native methods
-keepclasseswithmembernames class * {
    native <methods>;
}
