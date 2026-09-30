import Foundation
import SkipFuse

protocol HTTPClient: Sendable {
    func data(from url: URL) async throws -> Data
}

struct URLSessionHTTPClient: HTTPClient {
    func data(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        return data
    }
}
