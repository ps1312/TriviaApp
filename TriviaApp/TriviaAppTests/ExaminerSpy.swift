import Foundation
import TriviaEngine

class ExaminerSpy: ExaminerDelegate {
    var startCallCount = 0
    var startResult: Question?

    func start() throws -> Question {
        startCallCount += 1

        guard let startResult = startResult else {
            throw NSError(domain: "test error", code: 999)
        }

        return startResult
    }

    func respond(_ question: Question, with answer: Answer) -> Question? {
        nil
    }

    func evaluate() -> Score {
        Score(points: 0, responses: [])
    }

    func completeLoadWithError() {
        startResult = nil
    }

    func completeLoadWithSuccess(question: Question) {
        startResult = question
    }
}