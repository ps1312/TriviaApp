import XCTest
@testable import TriviaApp

class QuizSnapshotTests: XCTestCase {
    func test_loadQuestionsError() {
        let	(sut, spy) = makeSUT()
        spy.completeLoadWithError()

        assert(snapshot: sut.snapshot(.iPhone13(style: .light)), named: "QUESTIONS_LOAD_ERROR_light")
        assert(snapshot: sut.snapshot(.iPhone13(style: .dark)), named: "QUESTIONS_LOAD_ERROR_dark")
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

extension UINavigationController {
    func snapshot(_ configuration: SnapshotConfiguration) -> UIImage {
        SnapshotWindow(configuration: configuration, root: self).snapshot()
    }
}
