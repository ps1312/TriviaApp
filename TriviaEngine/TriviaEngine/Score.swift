public struct Score: Equatable {
    var points: Int
    var responses: [AnswerAttempt]

    public init(points: Int, responses: [AnswerAttempt]) {
        self.points = points
        self.responses = responses
    }
}
