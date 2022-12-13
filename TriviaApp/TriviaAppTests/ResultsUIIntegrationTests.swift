import XCTest
@testable import TriviaApp

class ResultsUIIntegrationTests: XCTestCase {
    func test_view_displaysTitle() {
        let sut = makeSUT()

        XCTAssertEqual(sut.title, "Results")
    }

    private func makeSUT() -> ResultsViewController {
        let bundle = Bundle(for: ResultsViewController.self)
        let storyboard = UIStoryboard(name: "Results", bundle: bundle)
        let navController = storyboard.instantiateInitialViewController() as! UINavigationController
        let sut = navController.topViewController as! ResultsViewController
        sut.loadViewIfNeeded()

        return sut
    }
}
