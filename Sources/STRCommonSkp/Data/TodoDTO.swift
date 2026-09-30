import Foundation

/// Backend representation of a todo. Internal: never exposed outside the module.
struct TodoDTO: Decodable {
    let id: Int
    let userId: Int
    let title: String
    let completed: Bool

    func toModel() -> Todo {
        Todo(id: id, userId: userId, title: title, isCompleted: completed)
    }
}
