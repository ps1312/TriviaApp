import Foundation
import TriviaEngine

class ExaminerSpy: ExaminerDelegate {
    var startCallCount = 0
    var startResult: Question?

    var answers = [Answer]()
    var respondCallCount: Int {
        answers.count
    }
    var respondResult: Question?

    func start() throws -> Question {
        startCallCount += 1

        guard let startResult = startResult else {
            throw NSError(domain: "test error", code: 999)
        }

        return startResult
    }

    func respond(_ question: Question, with answer: Answer) -> Question? {
        answers.append(answer)
        return respondResult
    }

    func completeRespondWith(question: Question?) {
        respondResult = question
    }

    func evaluate() -> Score {
        return Score(points: 0, responses: [])
    }

    func completeLoadWithError() {
        startResult = nil
    }

    func completeLoadWithSuccess(question: Question) {
        startResult = question
    }
}
