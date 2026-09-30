/// Public data model exposed to iOS and Android consumers.
public struct Todo: Equatable, Sendable {
    public let id: Int
    public let userId: Int
    public let title: String
    public let isCompleted: Bool

    public init(id: Int, userId: Int, title: String, isCompleted: Bool) {
        self.id = id
        self.userId = userId
        self.title = title
        self.isCompleted = isCompleted
    }
}
