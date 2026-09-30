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

The Android artifacts are published as a Maven repository in the `maven` branch of this repo.

`settings.gradle.kts`:

```kotlin
dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
        maven {
            url = uri("https://raw.githubusercontent.com/jorgmateos/str-common-skp/maven")
            content { includeGroup("com.jorgmateos.strcommonskp") }
        }
    }
}
```

`app/build.gradle.kts` (`minSdk` 28; transitive Skip dependencies come from the POM):

```kotlin
android {
    packaging { jniLibs { useLegacyPackaging = true } }
}

dependencies {
    implementation("com.jorgmateos.strcommonskp:STRCommonSkp:<version>")
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

## TodoUseCase

`TodoUseCase().execute(id:)` fetches `https://jsonplaceholder.typicode.com/todos/{id}` and returns the public `Todo`
model (`id`, `userId`, `title`, `isCompleted`). The backend DTO is internal to the module. Failures throw
`NetworkError` (`invalidURL`, `invalidResponse`, `decoding`) or the underlying `URLError`.

```swift
let todo = try await TodoUseCase().execute(id: 1)
```

On Android `execute` is a `suspend fun`, `Todo` a Kotlin class and `NetworkError` an `Exception`.
The app needs `<uses-permission android:name="android.permission.INTERNET" />`.

```kotlin
scope.launch {
    val todo = TodoUseCase().execute(1)
}
```

## Releasing a new version

```bash
../release-str-common-skp.sh <version>
```

Creates the signed tag (iOS/SPM), exports the Android Gradle project, publishes all modules to the
`maven` branch (stripping the Swift `.so` files to stay under GitHub's 100 MiB file limit) and pushes it.
