import XCTest
import TriviaEngine
@testable import TriviaApp

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

    private func makeSUT(score: Score = Score(points: 0, responses: [])) -> ResultsViewController {
        let bundle = Bundle(for: ResultsViewController.self)
        let storyboard = UIStoryboard(name: "Results", bundle: bundle)
        let navController = storyboard.instantiateInitialViewController() as! UINavigationController
        let sut = navController.topViewController as! ResultsViewController
        sut.score = score
        sut.loadViewIfNeeded()

        return sut
    }

    private func makeQuestion(title: String = "any title", answers: [Answer]? = nil) -> (Question, [Answer]) {
        let correctAnswer = Answer(id: UUID(), text: "Correct answer")
        let wrongAnswer = Answer(id: UUID(), text: "Wrong answer")
        let question = Question(id: UUID(), title: title, answers: answers ?? [correctAnswer, wrongAnswer], correctIndex: 0)

        return (question, answers ?? [correctAnswer, wrongAnswer])
    }
}

extension ResultsViewController {
    var totalScore: String? {
        return totalScoreLabel.text
    }

    func simulateAttemptIsVisible(at row: Int) -> UITableViewCell? {
        let indexPath = IndexPath(row: row, section: 0)
        return tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath)
    }
}

extension ResultAnswerCell {
    var isDisplayingWrongAnswer: Bool {
        !wrongAnswerLabel.isHidden
    }

    var correctAnswerText: String? {
        correctAnswerLabel.text
    }

    var correctAnswerColor: UIColor {
        correctAnswerLabel.textColor
    }

    var wrongAnswerText: String? {
        wrongAnswerLabel.text
    }

    var wrongAnswerColor: UIColor {
        wrongAnswerLabel.textColor
    }
}
