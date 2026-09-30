import Testing
import Foundation
@testable import STRCommonSkp

@Suite struct HelloWorldUseCaseTests {

    @Test func execute_returnsHelloWorldWithCurrentPlatform() {
        // Arrange
        let sut = HelloWorldUseCase()

        // Act
        let message = sut.execute()

        // Assert
        #if os(Android) || SKIP
        #expect(message == "Hello world from Android")
        #else
        #expect(message == "Hello world from macOS" || message == "Hello world from iOS")
        #endif
    }
}
