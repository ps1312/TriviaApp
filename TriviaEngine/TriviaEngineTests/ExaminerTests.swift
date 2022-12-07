import XCTest
import TriviaEngine

protocol QuestionsLoader {
    func load() throws -> [Question]
}

class Examiner {
    private let questionsLoader: QuestionsLoader
    private var questions = [Question]()

    var hasQuestions: Bool {
        !questions.isEmpty
    }

    struct NoQuestionsAvailable: Error {}

    init(questionsLoader: QuestionsLoader) {
        self.questionsLoader = questionsLoader
    }

    func prepare() throws {
        questions = try questionsLoader.load()
    }

    func start() throws -> Question {
        try prepare()

        if questions.isEmpty {
            throw NoQuestionsAvailable()
        }

        return questions.removeFirst()
    }
}

class ExaminerTests: XCTestCase {
    func test_init_startsWithNoQuestions() {
        let (sut, _) = makeSUT()

        XCTAssertFalse(sut.hasQuestions)
    }

    func test_prepare_messagesQuestionsLoader() {
        let (sut, spy) = makeSUT()

        try? sut.prepare()

        XCTAssertEqual(spy.loadCallCount, 1)
    }

    func test_prepare_throwsErrorWhenLoadingFails() {
        let (sut, spy) = makeSUT()
        spy.completeLoadWithError()

        XCTAssertThrowsError(try sut.prepare())
    }

    func test_start_presentsFirstQuestion() {
        let correctAnswer = Answer(id: UUID(), text: "First answer")
        let wrongAnswer = Answer(id: UUID(), text: "Second answer")
        let question = Question(title: "First question?", answers: [correctAnswer, wrongAnswer], correctAnswer: correctAnswer)

        let (sut, spy) = makeSUT()
        spy.completeLoadWithQuestions([question])

        let receivedQuestion = try? sut.start()

        XCTAssertEqual(receivedQuestion, question)
    }

    func test_start_throwsErrorWhenQuestionsIsEmpty() {
        let (sut, spy) = makeSUT()
        spy.completeLoadWithQuestions([])

        XCTAssertThrowsError(try sut.start())
    }

    private func makeSUT() -> (Examiner, QuestionsLoaderSpy) {
        let spy = QuestionsLoaderSpy()
        let sut = Examiner(questionsLoader: spy)

        return (sut, spy)
    }

    private class QuestionsLoaderSpy: QuestionsLoader {
        var loadCallCount = 0
        var loadResult: [Question]?

        func load() throws -> [Question] {
            loadCallCount += 1

            if let loadResult = loadResult {
                return loadResult
            }

            throw NSError(domain: "any", code: 0)
        }

        func completeLoadWithError() {
            loadResult = nil
        }

        func completeLoadWithQuestions(_ questions: [Question]) {
            loadResult = questions
        }
    }
}
