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

    private func makeSUT(score: Score = Score(points: 0, responses: [])) -> ResultsViewController {
        let bundle = Bundle(for: ResultsViewController.self)
        let storyboard = UIStoryboard(name: "Results", bundle: bundle)
        let navController = storyboard.instantiateInitialViewController() as! UINavigationController
        let sut = navController.topViewController as! ResultsViewController
        sut.score = score
        sut.loadViewIfNeeded()

        return sut
    }
}

extension ResultsViewController {
    var totalScore: String? {
        return totalScoreLabel.text
    }
}
