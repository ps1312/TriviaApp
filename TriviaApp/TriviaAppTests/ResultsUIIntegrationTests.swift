@testable import TriviaApp
import TriviaEngine
import XCTest

class ResultsUIIntegrationTests: XCTestCase {
    func test_view_displaysTitle() {
        let sut = makeSUT()

        XCTAssertEqual(sut.title, "Results")
    }

    func test_view_displaysTotalScore() {
        let score = Score(points: 1, responses: [])
        let sut = makeSUT(score: score)

        XCTAssertEqual(sut.totalScore, "Your score: 1")
    }

    func test_answerAttempts_displaysCorrectAnswer() {
        let (question, answers) = makeQuestion()
        let correctAnswer = answers[0]
        let attempt = AnswerAttempt(question: question, answer: correctAnswer, isCorrect: true)
        let score = Score(points: 1, responses: [attempt])
        let sut = makeSUT(score: score)

        let cell0 = sut.simulateAttemptIsVisible(at: 0) as? ResultAnswerCell

        XCTAssertEqual(cell0?.isDisplayingWrongAnswer, false, "Expected no wrong answer in cell when attempt is correct")
        XCTAssertEqual(cell0?.correctAnswerText, correctAnswer.text, "Expected correct answer text in cell")
        XCTAssertEqual(cell0?.correctAnswerColor, UIColor.systemGreen, "Expected correct answer color to be .systemGreen")
    }

    func test_answerAttempts_displaysWrongAnswerWithCorrectAnswerOnBottom() {
        let (question, answers) = makeQuestion()
        let correctAnswer = answers[0]
        let wrongAnswer = answers[1]
        let attempt = AnswerAttempt(question: question, answer: wrongAnswer, isCorrect: false)
        let score = Score(points: 1, responses: [attempt])
        let sut = makeSUT(score: score)

        let cell0 = sut.simulateAttemptIsVisible(at: 0) as? ResultAnswerCell

        XCTAssertEqual(cell0?.isDisplayingWrongAnswer, true, "Expected wrong answer in cell when attempt is wrong")
        XCTAssertEqual(cell0?.wrongAnswerText, wrongAnswer.text, "Expected wrong answer text in cell")
        XCTAssertEqual(cell0?.wrongAnswerColor, UIColor.systemRed, "Expected wrong answer color to be .systemRed")

        XCTAssertEqual(cell0?.correctAnswerText, correctAnswer.text, "Expected correct answer text in cell")
    }

    func test_playAgain_notifiesHandler() {
        var callCount = 0
        let sut = makeSUT(onRestart: {
            callCount += 1
        })

        sut.simulateTapOnPlayAgain()

        XCTAssertEqual(callCount, 1)
    }

    private func makeSUT(score: Score = Score(points: 0, responses: []), onRestart: @escaping () -> Void = {}, file: StaticString = #filePath, line: UInt = #line) -> ResultsViewController {
        let sut = ResultsUIComposer.composeWith(examiner: ExaminerSpy(), onRestart: onRestart)
        sut.score = score
        sut.loadViewIfNeeded()

        testMemoryLeak(sut, file: file, line: line)

        return sut
    }
}
