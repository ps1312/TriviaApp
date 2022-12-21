@testable import TriviaApp
import TriviaEngine
import XCTest

class QuizSnapshotTests: XCTestCase {
    func test_loadQuestionsError() {
        let (navController, _, spy) = makeSUT()
        spy.completeLoadWithError()

        assert(snapshot: navController.snapshot(.iPhone13(style: .light)), named: "QUESTIONS_LOAD_ERROR_light")
        assert(snapshot: navController.snapshot(.iPhone13(style: .dark)), named: "QUESTIONS_LOAD_ERROR_dark")
    }

    func test_loadQuestionSuccess() {
        let (question, _) = makeQuestion(title: "Any any any\nmultiline multiline multine\nquestion question question")
        let (navController, _, spy) = makeSUT()
        spy.completeLoadWithSuccess(question: question)

        assert(snapshot: navController.snapshot(.iPhone13(style: .light)), named: "QUESTIONS_LOAD_SUCCESS_light")
        assert(snapshot: navController.snapshot(.iPhone13(style: .dark)), named: "QUESTIONS_LOAD_SUCCESS_dark")
    }

    func test_answerSelected() {
        let (question, _) = makeQuestion(title: "Any any any\nmultiline multiline multine\nquestion question question")
        let (navController, viewController, spy) = makeSUT()
        spy.completeLoadWithSuccess(question: question)
        viewController.simulateOptionIsSelected(at: 0)

        assert(snapshot: navController.snapshot(.iPhone13(style: .light)), named: "ANSWER_SELECTED_light")
        assert(snapshot: navController.snapshot(.iPhone13(style: .dark)), named: "ANSWER_SELECTED_dark")
    }

    private func makeSUT(onFinish: @escaping () -> Void = {}) -> (UINavigationController, QuizViewController, ExaminerSpy) {
        let spy = ExaminerSpy()
        let viewController = QuizUIComposer.composeWith(examiner: spy, onFinish: onFinish)

        let navController = UINavigationController(rootViewController: viewController)
        navController.isToolbarHidden = false
        navController.loadViewIfNeeded()

        return (navController, viewController, spy)
    }
}

extension UINavigationController {
    func snapshot(_ configuration: SnapshotConfiguration) -> UIImage {
        SnapshotWindow(configuration: configuration, root: self).snapshot()
    }
}
