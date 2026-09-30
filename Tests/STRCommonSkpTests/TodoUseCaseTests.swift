import Testing
import Foundation
@testable import STRCommonSkp

private struct HTTPClientStub: HTTPClient {
    let result: Result<Data, NetworkError>
    func data(from url: URL) async throws -> Data {
        try result.get()
    }
}

@Suite struct TodoUseCaseTests {

    @Test func execute_withValidResponse_returnsMappedTodo() async throws {
        // Arrange
        let json = #"{"userId": 1, "id": 7, "title": "buy milk", "completed": true}"#
        let sut = TodoUseCase(httpClient: HTTPClientStub(result: .success(Data(json.utf8))))

        // Act
        let todo = try await sut.execute(id: 7)

        // Assert
        #expect(todo == Todo(id: 7, userId: 1, title: "buy milk", isCompleted: true))
    }

    @Test func execute_withMalformedJSON_throwsDecoding() async {
        // Arrange
        let sut = TodoUseCase(httpClient: HTTPClientStub(result: .success(Data("{}".utf8))))

        // Act / Assert
        await #expect(throws: NetworkError.decoding) { try await sut.execute(id: 1) }
    }

    @Test func execute_withInvalidResponse_propagatesError() async {
        // Arrange
        let sut = TodoUseCase(httpClient: HTTPClientStub(result: .failure(.invalidResponse)))

        // Act / Assert
        await #expect(throws: NetworkError.invalidResponse) { try await sut.execute(id: 1) }
    }
}
