@testable import TriviaApp
import TriviaEngine
import XCTest

class ResultsSnapshotsTests: XCTestCase {
    func test_resultsWithResponses() {
        let (question, answers) = makeQuestion()
        let score = Score(points: 1, responses: [
            AnswerAttempt(question: question, answer: answers[0], isCorrect: true),
            AnswerAttempt(question: question, answer: answers[1], isCorrect: false),
        ])
        let (navController, _, _) = makeSUT(score: score)

        assert(snapshot: navController.snapshot(.iPhone13(style: .light)), named: "RESULTS_light")
        assert(snapshot: navController.snapshot(.iPhone13(style: .dark)), named: "RESULTS_dark")
    }

    private func makeSUT(score: Score) -> (UINavigationController, ResultsViewController, ExaminerSpy) {
        let spy = ExaminerSpy()
        let viewController = ResultsUIComposer.composeWith(examiner: spy, onRestart: {})
        viewController.score = score

        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        navController.loadViewIfNeeded()

        return (navController, viewController, spy)
    }
}
