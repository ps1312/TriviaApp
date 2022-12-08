import XCTest
import TriviaApp
import TriviaEngine

class QuizUIIntegrationTests: XCTestCase {
    func test_viewDidLoad_requestsExaminerForStart() {
        let bundle = Bundle(for: QuizViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let navController = storyboard.instantiateInitialViewController() as! UINavigationController
        let viewController = navController.topViewController as! QuizViewController
        let spy = ExaminerSpy()
        viewController.examiner = spy
        viewController.loadViewIfNeeded()

        XCTAssertEqual(spy.startCallCount, 1)
    }

    func test_startFailure_displaysRetryButton() {
        let bundle = Bundle(for: QuizViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let navController = storyboard.instantiateInitialViewController() as! UINavigationController
        let sut = navController.topViewController as! QuizViewController
        let spy = ExaminerSpy()
        sut.examiner = spy
        sut.loadViewIfNeeded()

        XCTAssertTrue(sut.isShowingStartRetry, "Expected retry button after questions loading has failed on start")
    }

    private class ExaminerSpy: ExaminerDelegate {
        var startCallCount = 0

        func start() throws -> Question {
            startCallCount += 1
            throw NSError(domain: "test error", code: 999)
        }

        func respond(_ question: Question, with answer: Answer) -> Question? {
            nil
        }

        func evaluate() -> Score {
            Score(points: 0, responses: [])
        }
    }
}

extension QuizViewController {
    var isShowingStartRetry: Bool {
        guard let retryButton = toolbarItems?[1] else { return false }
        return retryButton.title == "Retry"
    }
}
