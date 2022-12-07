import Foundation

public struct Question: Equatable {
    public let id: UUID
    public let title: String
    public let answers: [Answer]
    public let correctAnswer: Answer

    public init(id: UUID, title: String, answers: [Answer], correctAnswer: Answer) {
        self.id = id
        self.title = title
        self.answers = answers
        self.correctAnswer = correctAnswer
    }
}
