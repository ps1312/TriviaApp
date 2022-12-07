import XCTest
import TriviaEngine

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
        let (question, _) = makeQuestionWithCorrectFirstAnswer()

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
        let (question, answers) = makeQuestionWithCorrectFirstAnswer()
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
        let (question1, answers1) = makeQuestionWithCorrectFirstAnswer()
        let (question2, _) = makeQuestionWithCorrectFirstAnswer()

        let (sut, spy) = makeSUT()
        spy.completeLoadWithQuestions([question1, question2])

        let firstQuestion = try XCTUnwrap(try sut.start(), "Expected start() to deliver first question")
        XCTAssertEqual(firstQuestion, question1)

        let lastQuestion = sut.respond(question1, with: answers1[0])
        XCTAssertEqual(lastQuestion, question2)
    }

    func test_respond_deliversNilOnNoMoreQuestionsAvailable() throws {
        let (question, answers) = makeQuestionWithCorrectFirstAnswer()
        let wrongAnswer = answers[1]

        let (sut, spy) = makeSUT()
        spy.completeLoadWithQuestions([question])

        let receivedQuestion = try XCTUnwrap(try sut.start(), "Expected start() to deliver first question")
        let nextQuestion = sut.respond(receivedQuestion, with: wrongAnswer)

        XCTAssertNil(nextQuestion)
    }

    func test_evaluate_deliversFinalScore() throws {
        let (question, answers) = makeQuestionWithCorrectFirstAnswer()
        let correctAnswer = answers[0]
        let expectedScore = Score(points: 1, responses: [AnswerAttempt(question: question, answer: correctAnswer, isCorrect: true)])

        let (sut, spy) = makeSUT()
        spy.completeLoadWithQuestions([question])

        let receivedQuestion = try XCTUnwrap(try sut.start(), "Expected start() to deliver first question")
        _ = sut.respond(receivedQuestion, with: correctAnswer)

        let score = sut.evaluate()
        XCTAssertEqual(score, expectedScore)
    }

    private func makeSUT() -> (Examiner, QuestionsLoaderSpy) {
        let spy = QuestionsLoaderSpy()
        let sut = Examiner(questionsLoader: spy)

        return (sut, spy)
    }

    private func makeQuestionWithCorrectFirstAnswer() -> (Question, [Answer]) {
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
}
