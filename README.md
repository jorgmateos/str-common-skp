# STRCommonSkp

This is a free [Skip](https://skip.dev) Swift/Kotlin library project containing the following modules:

STRCommonSkp

## Building

This project is a Swift Package Manager module that uses the
[Skip](https://skip.dev) plugin to build the package for both iOS and Android.

## Testing

The module can be tested using the standard `swift test` command
or by running the test target for the macOS destination in Xcode,
which will run the Swift tests as well as the transpiled
Kotlin JUnit tests in the Robolectric Android simulation environment.

Parity testing can be performed with `skip test`,
which will output a table of the test results for both platforms.

## License

This software is licensed under the
[Mozilla Public License 2.0](https://www.mozilla.org/MPL/).

## HelloWorldUseCase

`HelloWorldUseCase().execute()` prints `Hello world from <iOS|Android>` and returns the message.

### Android (Kotlin)

```bash
skip export --debug --no-ios --module STRCommonSkp -d ../str-common-skp-export
```

Copy the exported `*.aar` files (except `SkipUnit`) to `app/libs/` of the Android project (`minSdk` 28, arm64-v8a).
Local `.aar` files carry no POM, so the Skip runtime dependencies must be declared explicitly:

```kotlin
android {
    defaultConfig { ndk { abiFilters += "arm64-v8a" } }
    packaging { jniLibs { useLegacyPackaging = true } }
}

dependencies {
    implementation(fileTree(mapOf("dir" to "libs", "include" to listOf("*.aar"), "exclude" to listOf("SkipUnit*"))))
    implementation(platform("org.jetbrains.kotlin:kotlin-bom:2.3.0"))
    implementation("org.jetbrains.kotlin:kotlin-reflect")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.11.0")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.11.0")
    implementation(platform("com.squareup.okhttp3:okhttp-bom:5.3.2"))
    implementation("com.squareup.okhttp3:okhttp")
    implementation("org.commonmark:commonmark:0.28.0")
    implementation("org.commonmark:commonmark-ext-gfm-strikethrough:0.28.0")
    implementation("androidx.annotation:annotation:1.9.1")
}
```

Bootstrap Skip once in your `Application` (loads `libSTRCommonSkp.so`):

```kotlin
class MyApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        skip.foundation.ProcessInfo.launch(this)
    }
}
```

```kotlin
import strcommon.skp.HelloWorldUseCase

HelloWorldUseCase().execute() // Logcat: "Hello world from Android"
```

### iOS (Swift Package)

```swift
import STRCommonSkp

HelloWorldUseCase().execute() // Console: "Hello world from iOS"
```
