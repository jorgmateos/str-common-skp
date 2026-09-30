/// Errors thrown by the network use cases. On Android they surface as Kotlin exceptions.
public enum NetworkError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case decoding
}
