import XCTest
@testable import TriviaApp

class ResultsUIIntegrationTests: XCTestCase {
    func test_view_displaysTitle() {
        let bundle = Bundle(for: ResultsViewController.self)
        let storyboard = UIStoryboard(name: "Results", bundle: bundle)
        let navController = storyboard.instantiateInitialViewController() as! UINavigationController
        let sut = navController.topViewController as! ResultsViewController
        sut.loadViewIfNeeded()

        XCTAssertEqual(navController.title, "Results")
    }
}
