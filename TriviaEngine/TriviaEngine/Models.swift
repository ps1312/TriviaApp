import Foundation

public struct Answer {
    public let id: UUID
    public let text: String
}

public struct Question {
    public let title: String
    public let answers: [Answer]
    public let correctAnswer: Answer
}
