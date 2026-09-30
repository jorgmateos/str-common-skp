import Foundation
import SkipFuse

// MARK: - Protocol

public protocol HelloWorldUseCaseProtocol {
    @discardableResult
    func execute() -> String
}

// MARK: - Implementation

public final class HelloWorldUseCase: HelloWorldUseCaseProtocol {

    private let logger = Logger(subsystem: "com.stradivarius.common", category: "HelloWorldUseCase")

    public init() {}

    /// Prints and returns "Hello world from <platform>".
    /// On Android the message is also sent to Logcat (tag `HelloWorldUseCase`).
    @discardableResult
    public func execute() -> String {
        let message = "Hello world from \(Self.platformName)"
        print(message)
        logger.info("\(message)")
        return message
    }

    static var platformName: String {
        #if os(Android)
        return "Android"
        #elseif os(iOS)
        return "iOS"
        #elseif os(macOS)
        return "macOS"
        #else
        return "Unknown"
        #endif
    }
}
