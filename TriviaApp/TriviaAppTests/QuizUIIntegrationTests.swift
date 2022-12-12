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
        XCTAssertTrue(sut.isShowingSubmit, "Expected to show submit after user retries with success")
    }

    func test_viewDidLoad_displaysFirstQuestionAndAnswers() {
        let (question, answers) = makeQuestion()
        let firstAnswer = answers[0]
        let lastAnswer = answers[1]
        let (sut, spy) = makeSUT()
        spy.completeLoadWithSuccess(question: question)
        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.questionTitle, question.title, "Expected to display question title text")

        let firstOption = sut.simulateOptionIsVisible(at: 0)
        expect(firstOption, toHaveTitle: firstAnswer.text, isSelected: false)

        let lastOption = sut.simulateOptionIsVisible(at: 1)
        expect(lastOption, toHaveTitle: lastAnswer.text, isSelected: false)
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

        expect(sut.simulateOptionIsVisible(at: 0), isSelected: false)
        expect(sut.simulateOptionIsVisible(at: 1), isSelected: false)

        sut.simulateOptionIsSelected(at: 0)

        expect(sut.simulateOptionIsVisible(at: 0), isSelected: true)
        expect(sut.simulateOptionIsVisible(at: 1), isSelected: false)

        sut.simulateOptionIsSelected(at: 1)

        expect(sut.simulateOptionIsVisible(at: 0), isSelected: false)
        expect(sut.simulateOptionIsVisible(at: 1), isSelected: true)
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

    func test_submitButton_displaysNextQuestionAfterTapAndUnselectPreviousOption() {
        let (question1, _) = makeQuestion(title: "first title")
        let (question2, answers) = makeQuestion(title: "second title", answers: [
            Answer(id: UUID(), text: "answer 1"),
            Answer(id: UUID(), text: "answer 2")
        ])

        let (sut, spy) = makeSUT()
        spy.completeLoadWithSuccess(question: question1)
        sut.loadViewIfNeeded()
        sut.simulateOptionIsSelected(at: 0)

        spy.completeRespondWith(question: question2)
        sut.simulateTapOnSubmit()

        XCTAssertEqual(sut.questionTitle, question2.title)
        expect(sut.simulateOptionIsVisible(at: 0), toHaveTitle: answers[0].text, isSelected: false)
        expect(sut.simulateOptionIsVisible(at: 1), toHaveTitle: answers[1].text, isSelected: false)
    }

    func test_submitButton_messagesExaminerForEvaluationAfterLastQuestion() {
        let (question1, _) = makeQuestion(title: "first title")
        let (sut, spy) = makeSUT()
        spy.completeLoadWithSuccess(question: question1)
        sut.loadViewIfNeeded()
        sut.simulateOptionIsSelected(at: 0)
        sut.simulateTapOnSubmit()

        XCTAssertEqual(spy.evaluateCallCount, 1)
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

    private func expect(_ cell: UITableViewCell?, toHaveTitle title: String? = nil, isSelected: Bool) {
        let config = cell?.contentConfiguration as? UIListContentConfiguration
        if title != nil {
            XCTAssertEqual(config?.text, title, "Expect cell to have title")
        }
        XCTAssertEqual(cell?.accessoryType, isSelected ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none)
    }

    private func makeQuestion(title: String = "any title", answers: [Answer]? = nil) -> (Question, [Answer]) {
        let correctAnswer = Answer(id: UUID(), text: "Correct answer")
        let wrongAnswer = Answer(id: UUID(), text: "Wrong answer")
        let question = Question(id: UUID(), title: title, answers: answers ?? [correctAnswer, wrongAnswer], correctIndex: 0)

        return (question, answers ?? [correctAnswer, wrongAnswer])
    }
}
