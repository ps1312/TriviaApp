import XCTest
import TriviaEngine

protocol QuestionsLoader {
    func load() throws -> [Question]
}

struct AnswerAttempt: Equatable {
    let question: Question
    let answer: Answer
    let isCorrect: Bool
}

class Examiner {
    private let questionsLoader: QuestionsLoader
    private var questions = [Question]()
    var responses = [AnswerAttempt]()

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

    func respond(_ question: Question, with answer: Answer) -> Question? {
        responses.append(AnswerAttempt(question: question, answer: answer, isCorrect: question.correctAnswer == answer))

        if questions.isEmpty {
            return nil
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
        let (question, _) = makeTrivia()

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

    func test_respond_registersAnswerToAQuestion() throws {
        let (question, answers) = makeTrivia()
        let wrongAnswer = answers[1]

        let (sut, spy) = makeSUT()
        spy.completeLoadWithQuestions([question])

        let receivedQuestion = try XCTUnwrap(try sut.start(), "Expected start() to deliver first question")
        _ = sut.respond(receivedQuestion, with: wrongAnswer)

        XCTAssertEqual(sut.responses, [
            AnswerAttempt(question: question, answer: wrongAnswer, isCorrect: false),
        ])
    }

    func test_respond_presentsNextQuestion() throws {
        let (question1, answers1) = makeTrivia()
        let (question2, _) = makeTrivia()

        let (sut, spy) = makeSUT()
        spy.completeLoadWithQuestions([question1, question2])

        let firstQuestion = try XCTUnwrap(try sut.start(), "Expected start() to deliver first question")
        XCTAssertEqual(firstQuestion, question1)

        let lastQuestion = sut.respond(question1, with: answers1[0])
        XCTAssertEqual(lastQuestion, question2)
    }

    func test_respond_deliversNilOnNoMoreQuestionsAvailable() throws {
        let (question, answers) = makeTrivia()
        let wrongAnswer = answers[1]

        let (sut, spy) = makeSUT()
        spy.completeLoadWithQuestions([question])

        let receivedQuestion = try XCTUnwrap(try sut.start(), "Expected start() to deliver first question")
        let nextQuestion = sut.respond(receivedQuestion, with: wrongAnswer)

        XCTAssertNil(nextQuestion)
    }

    private func makeTrivia() -> (Question, [Answer]) {
        let correctAnswer = Answer(id: UUID(), text: "Correct answer")
        let wrongAnswer = Answer(id: UUID(), text: "Wrong answer")
        let question = Question(id: UUID(), title: "Is this correct?", answers: [correctAnswer, wrongAnswer], correctAnswer: correctAnswer)

        return (question, [correctAnswer, wrongAnswer])
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
