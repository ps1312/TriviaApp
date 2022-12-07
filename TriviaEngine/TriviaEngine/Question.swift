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
