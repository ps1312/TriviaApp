import XCTest
import TriviaApp
import TriviaEngine

class QuizUIIntegrationTests: XCTestCase {
    func test_viewDidLoad_requestsExaminerForStart() {
        let (sut, spy) = makeSUT()
        sut.loadViewIfNeeded()

        XCTAssertEqual(spy.startCallCount, 1)
    }

    func test_startFailure_displaysRetryButton() {
        let (sut, spy) = makeSUT()
        spy.completeLoadWithError()

        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingStartRetry, "Expected retry button after questions loading has failed on start")

        sut.simulateTapOnRetry()
        XCTAssertEqual(spy.startCallCount, 2, "Expected another start after user requests retry")
    }

    private func makeSUT() -> (QuizViewController, ExaminerSpy) {
        let bundle = Bundle(for: QuizViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let navController = storyboard.instantiateInitialViewController() as! UINavigationController
        let sut = navController.topViewController as! QuizViewController
        let spy = ExaminerSpy()
        sut.examiner = spy

        return (sut, spy)
    }

    private class ExaminerSpy: ExaminerDelegate {
        var startCallCount = 0
        var startResult: Question?

        func start() throws -> Question {
            startCallCount += 1

            if startResult == nil {
                throw NSError(domain: "test error", code: 999)
            }

            return Question(id: UUID(), title: "", answers: [], correctAnswer: Answer(id: UUID(), text: ""))
        }

        func respond(_ question: Question, with answer: Answer) -> Question? {
            nil
        }

        func evaluate() -> Score {
            Score(points: 0, responses: [])
        }

        func completeLoadWithError() {
            startResult = nil
        }
    }
}

extension QuizViewController {
    var isShowingStartRetry: Bool {
        guard let retryButton = toolbarItems?[1] else { return false }
        return retryButton.title == "Retry"
    }

    func simulateTapOnRetry() {
        guard let retryButton = toolbarItems?[1] else { return }
        _ = retryButton.target?.perform(retryButton.action)
    }
}
