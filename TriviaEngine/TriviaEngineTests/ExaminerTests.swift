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

    enum Error: Swift.Error {
        case loadingQuestions
        case noQuestionsAvailable
    }

    init(questionsLoader: QuestionsLoader) {
        self.questionsLoader = questionsLoader
    }

    func start() throws -> Question {
        do {
            questions = try questionsLoader.load()
        } catch {
            throw Error.loadingQuestions
        }

        if questions.isEmpty {
            throw Error.noQuestionsAvailable
        }

        return questions.removeFirst()
    }
}

class ExaminerTests: XCTestCase {
    func test_init_startsWithNoQuestions() {
        let (sut, _) = makeSUT()

        XCTAssertFalse(sut.hasQuestions)
    }

    func test_start_messagesQuestionsLoader() {
        let (sut, spy) = makeSUT()

        _ = try? sut.start()

        XCTAssertEqual(spy.loadCallCount, 1)
    }

    func test_start_throwsLoadingErrorWhenLoadingQuestionsFails() {
        let (sut, spy) = makeSUT()

        expect(sut, toThrow: .loadingQuestions, when: {
            spy.completeLoadWithError()
        })
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

        expect(sut, toThrow: .noQuestionsAvailable, when: {
            spy.completeLoadWithQuestions([])
        })
    }

    private func expect(_ sut: Examiner, toThrow expectedError: Examiner.Error, when action: () -> Void) {
        action()

        do {
            _ = try sut.start()
        } catch {
            XCTAssertEqual(error as NSError, expectedError as NSError)
        }
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

            throw NSError(domain: "Test made error", code: 9999)
        }

        func completeLoadWithError() {
            loadResult = nil
        }

        func completeLoadWithQuestions(_ questions: [Question]) {
            loadResult = questions
        }
    }
}
