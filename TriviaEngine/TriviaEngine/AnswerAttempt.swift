public struct AnswerAttempt: Equatable {
    let question: Question
    let answer: Answer
    let isCorrect: Bool

    public init(question: Question, answer: Answer, isCorrect: Bool) {
        self.question = question
        self.answer = answer
        self.isCorrect = isCorrect
    }
}
