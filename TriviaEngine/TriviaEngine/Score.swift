public struct Score: Equatable {
    public var points: Int
    public var responses: [AnswerAttempt]

    public init(points: Int, responses: [AnswerAttempt]) {
        self.points = points
        self.responses = responses
    }
}
