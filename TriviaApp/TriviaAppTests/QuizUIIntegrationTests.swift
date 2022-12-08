import XCTest
import TriviaApp
import TriviaEngine

class QuizUIIntegrationTests: XCTestCase {
    func test_viewDidLoad_requestsExaminerForStart() {
        let (sut, spy) = makeSUT()
        sut.loadViewIfNeeded()

        XCTAssertEqual(spy.startCallCount, 1)
    }

    func test_retryButton_isDisplayedOnFailure() {
        let (question, _) = makeQuestion()
        let (sut, spy) = makeSUT()
        
        spy.completeLoadWithError()
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingStartRetry, "Expected retry button after questions loading has failed on start")

        spy.completeLoadWithSuccess(question: question)
        sut.simulateTapOnRetry()
        XCTAssertEqual(spy.startCallCount, 2, "Expected another start after user requests retry")
        XCTAssertFalse(sut.isShowingStartRetry, "Expected no retry button after questions loading succeeds")
    }

    func test_viewDidLoad_displaysFirstQuestionAndAnswers() {
        let (question, answers) = makeQuestion()
        let firstAnswer = answers[0]
        let lastAnswer = answers[1]
        let (sut, spy) = makeSUT()
        spy.completeLoadWithSuccess(question: question)
        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.questionTitle, question.title)

        let firstOption = sut.simulateOptionIsVisible(at: 0)
        let firstContentConfig = firstOption?.contentConfiguration as? UIListContentConfiguration
        XCTAssertEqual(firstContentConfig?.text, firstAnswer.text)
        XCTAssertEqual(firstOption?.accessoryType, UITableViewCell.AccessoryType.none)

        let lastOption = sut.simulateOptionIsVisible(at: 1)
        let lastContentConfig = lastOption?.contentConfiguration as? UIListContentConfiguration
        XCTAssertEqual(lastContentConfig?.text, lastAnswer.text)
        XCTAssertEqual(lastOption?.accessoryType, UITableViewCell.AccessoryType.none)
    }

    func test_submitButton_isDisabledUntilOptionIsSelected() {
        let (question, _) = makeQuestion()
        let (sut, spy) = makeSUT()
        spy.completeLoadWithSuccess(question: question)
        sut.loadViewIfNeeded()

        XCTAssertFalse(sut.canSubmit, "Expected submit to be disabled until an option is selected")

        sut.simulateOptionIsSelected(at: 0)

        XCTAssertTrue(sut.canSubmit, "Expect submit to be enabled after an option is selected")
    }

    func test_submitButton_messagedExaminerWithSelectedOption() {
        let (question, _) = makeQuestion()
        let (sut, spy) = makeSUT()
        spy.completeLoadWithSuccess(question: question)
        sut.loadViewIfNeeded()

        sut.simulateOptionIsSelected(at: 0)
        sut.simulateTapOnSubmit()
        XCTAssertEqual(spy.respondCallCount, 1)
    }

    func test_option_displaysSelectionIndicatorWhileChosen() {
        let (question, _) = makeQuestion()
        let (sut, spy) = makeSUT()
        spy.completeLoadWithSuccess(question: question)
        sut.loadViewIfNeeded()

        var firstOption = sut.simulateOptionIsVisible(at: 0)
        var lastOption = sut.simulateOptionIsVisible(at: 1)
        
        XCTAssertEqual(firstOption?.accessoryType, UITableViewCell.AccessoryType.none)
        XCTAssertEqual(lastOption?.accessoryType, UITableViewCell.AccessoryType.none)

        sut.simulateOptionIsSelected(at: 0)

        firstOption = sut.simulateOptionIsVisible(at: 0)
        lastOption = sut.simulateOptionIsVisible(at: 1)
        XCTAssertEqual(firstOption?.accessoryType, UITableViewCell.AccessoryType.checkmark)
        XCTAssertEqual(lastOption?.accessoryType, UITableViewCell.AccessoryType.none)

        sut.simulateOptionIsSelected(at: 1)

        firstOption = sut.simulateOptionIsVisible(at: 0)
        lastOption = sut.simulateOptionIsVisible(at: 1)
        XCTAssertEqual(firstOption?.accessoryType, UITableViewCell.AccessoryType.none)
        XCTAssertEqual(lastOption?.accessoryType, UITableViewCell.AccessoryType.checkmark)
    }

    func test_submitButton_isDisabledAfterQuestionSubmit() {
        let (question, _) = makeQuestion()
        let (sut, spy) = makeSUT()
        spy.completeLoadWithSuccess(question: question)
        sut.loadViewIfNeeded()
        sut.simulateOptionIsSelected(at: 0)
        sut.simulateTapOnSubmit()

        XCTAssertFalse(sut.canSubmit)
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

    private func makeQuestion() -> (Question, [Answer]) {
        let correctAnswer = Answer(id: UUID(), text: "Correct answer")
        let wrongAnswer = Answer(id: UUID(), text: "Wrong answer")
        let question = Question(id: UUID(), title: "Is this correct?", answers: [correctAnswer, wrongAnswer], correctIndex: 0)

        return (question, [correctAnswer, wrongAnswer])
    }
}
