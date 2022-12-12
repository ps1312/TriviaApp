import Foundation
import TriviaEngine

class QuestionsLoaderSpy: QuestionsLoader {
    var loadCallCount = 0
    var loadResult: [Question]?

    func load() throws -> [Question] {
        loadCallCount += 1

        if let loadResult = loadResult {
            return loadResult
        }

        throw NSError(domain: "Test made error", code: 9999)
    }

    func completeLoadWithError() {
        loadResult = nil
    }

    func completeLoadWithQuestions(_ questions: [Question]) {
        loadResult = questions
    }
}
