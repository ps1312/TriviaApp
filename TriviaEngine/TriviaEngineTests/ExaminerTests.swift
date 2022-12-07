import XCTest
import TriviaEngine

protocol QuestionsLoader {
    func load() throws -> [Question]
}

class Examiner {
    private let questionsLoader: QuestionsLoader
    let questions = [Question]()

    init(questionsLoader: QuestionsLoader) {
        self.questionsLoader = questionsLoader
    }

    func prepare() {
        _ = try? questionsLoader.load()
    }
}

class ExaminerTests: XCTestCase {
    func test_init_startsWithNoQuestions() {
        let spy = QuestionsLoaderSpy()
        let sut = Examiner(questionsLoader: spy)

        XCTAssertTrue(sut.questions.isEmpty)
    }

    func test_prepare_messagesQuestionsLoader() {
        let spy = QuestionsLoaderSpy()
        let sut = Examiner(questionsLoader: spy)

        sut.prepare()

        XCTAssertEqual(spy.loadCallCount, 1)
    }

    private class QuestionsLoaderSpy: QuestionsLoader {
        var loadCallCount = 0

        func load() throws -> [Question] {
            loadCallCount += 1
            return []
        }
    }
}
