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
        let bundle = Bundle(for: ResultsViewController.self)
        let storyboard = UIStoryboard(name: "Results", bundle: bundle)
        let navController = storyboard.instantiateInitialViewController() as! UINavigationController
        let viewController = navController.topViewController as! ResultsViewController
        let spy = ExaminerSpy()
        viewController.score = score
        navController.loadViewIfNeeded()

        return (navController, viewController, spy)
    }
}
