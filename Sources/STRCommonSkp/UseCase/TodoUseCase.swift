import Foundation
import SkipFuse

// MARK: - Protocol

public protocol TodoUseCaseProtocol: Sendable {
    func execute(id: Int) async throws -> Todo
}

// MARK: - Implementation

/// Fetches a todo from jsonplaceholder.typicode.com and maps it to the public `Todo` model.
public final class TodoUseCase: TodoUseCaseProtocol, Sendable {

    private let httpClient: HTTPClient
    private let logger = Logger(subsystem: "com.stradivarius.common", category: "TodoUseCase")

    public init() {
        self.httpClient = URLSessionHTTPClient()
    }

    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }

    public func execute(id: Int) async throws -> Todo {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/\(id)") else {
            throw NetworkError.invalidURL
        }
        let data = try await httpClient.data(from: url)
        let dto: TodoDTO
        do {
            dto = try JSONDecoder().decode(TodoDTO.self, from: data)
        } catch {
            logger.error("Decoding failed: \(error.localizedDescription)")
            throw NetworkError.decoding
        }
        let todo = dto.toModel()
        logger.info("Todo \(todo.id): \(todo.title)")
        return todo
    }
}
