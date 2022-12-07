public struct AnswerAttempt: Equatable {
    public let question: Question
    public let answer: Answer
    public let isCorrect: Bool

    public init(question: Question, answer: Answer, isCorrect: Bool) {
        self.question = question
        self.answer = answer
        self.isCorrect = isCorrect
    }
}
