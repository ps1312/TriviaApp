import Foundation

public struct Answer: Equatable {
    public let id: UUID
    public let text: String

    public init(id: UUID, text: String) {
        self.id = id
        self.text = text
    }
}

public struct Question: Equatable {
    public let title: String
    public let answers: [Answer]
    public let correctAnswer: Answer

    public init(title: String, answers: [Answer], correctAnswer: Answer) {
        self.title = title
        self.answers = answers
        self.correctAnswer = correctAnswer
    }
}
