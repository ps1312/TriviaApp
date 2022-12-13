import XCTest
@testable import TriviaApp

class QuizSnapshotTests: XCTestCase {
    func test_loadQuestionsError() {
        let	(sut, spy) = makeSUT()
        spy.completeLoadWithError()

        let snapshot = SnapshotWindow(configuration: .iPhone13(style: .light), root: sut).snapshot()
        record(snapshot: snapshot, named: "QUESTIONS_LOAD_ERROR_light")
    }

    private func makeSUT(onFinish: @escaping () -> Void = {}) -> (UINavigationController, ExaminerSpy) {
        let bundle = Bundle(for: QuizViewController.self)
        let storyboard = UIStoryboard(name: "Quiz", bundle: bundle)
        let sut = storyboard.instantiateInitialViewController() as! UINavigationController
        let viewController = sut.topViewController as! QuizViewController
        let spy = ExaminerSpy()
        viewController.examiner = spy
        viewController.onFinish = onFinish
        viewController.loadViewIfNeeded()

        return (sut, spy)
    }
}

