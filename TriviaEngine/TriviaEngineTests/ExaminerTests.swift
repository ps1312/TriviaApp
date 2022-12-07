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
        let (sut, _) = makeSUT()

        XCTAssertTrue(sut.questions.isEmpty)
    }

    func test_prepare_messagesQuestionsLoader() {
        let (sut, spy) = makeSUT()

        sut.prepare()

        XCTAssertEqual(spy.loadCallCount, 1)
    }

    private func makeSUT() -> (Examiner, QuestionsLoaderSpy) {
        let spy = QuestionsLoaderSpy()
        let sut = Examiner(questionsLoader: spy)

        return (sut, spy)
    }

    private class QuestionsLoaderSpy: QuestionsLoader {
        var loadCallCount = 0

        func load() throws -> [Question] {
            loadCallCount += 1
            return []
        }
    }
}
