@testable import TriviaApp
import TriviaEngine
import XCTest

class QuizUIIntegrationTests: XCTestCase {
    func test_viewDidLoad_requestsExaminerForStart() {
        let (sut, spy) = makeSUT()
        sut.loadViewIfNeeded()

        XCTAssertEqual(spy.startCallCount, 1)
    }

    func test_loadingError_displaysRetryButtonAndMessage() {
        let (question, _) = makeQuestion()
        let (sut, spy) = makeSUT()

        spy.completeLoadWithError()
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingStartRetry, "Expected retry button after questions loading has failed on start")
        XCTAssertEqual(sut.questionTitle, "Something went wrong loading the questions, please try again.")

        spy.completeLoadWithSuccess(question: question)
        sut.simulateTapOnRetry()
        XCTAssertEqual(spy.startCallCount, 2, "Expected another start after user requests retry")
        XCTAssertFalse(sut.isShowingStartRetry, "Expected no retry button after questions loading succeeds")
        XCTAssertTrue(sut.isShowingSubmit, "Expected to show submit after user retries with success")
        XCTAssertEqual(sut.questionTitle, question.title)
    }

    func test_questionNumber_isDisplayedOnceQuestionsLoad() {
        let (sut, spy) = makeSUT()
        spy.completeLoadWithError()
        sut.loadViewIfNeeded()

        XCTAssertFalse(sut.isDisplayingQuestionsNumber, "Expect no question number label when questions loading fails")

        let (question1, _) = makeQuestion()
        spy.completeLoadWithSuccess(question: question1)
        sut.simulateTapOnRetry()

        XCTAssertTrue(sut.isDisplayingQuestionsNumber)
        XCTAssertEqual(sut.questionNumberText, "Question 1")

        let (question2, _) = makeQuestion()
        spy.completeRespondWith(question: question2)
        _ = sut.simulateOptionIsVisible(at: 0)
        sut.simulateOptionIsSelected(at: 0)
        sut.simulateTapOnSubmit()

        XCTAssertTrue(sut.isDisplayingQuestionsNumber)
        XCTAssertEqual(sut.questionNumberText, "Question 2")

        let (question3, _) = makeQuestion()
        spy.completeRespondWith(question: question3)
        _ = sut.simulateOptionIsVisible(at: 1)
        sut.simulateOptionIsSelected(at: 1)
        sut.simulateTapOnSubmit()

        XCTAssertTrue(sut.isDisplayingQuestionsNumber)
        XCTAssertEqual(sut.questionNumberText, "Question 3")
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

        sut.simulateTapOnSubmit()

        XCTAssertFalse(sut.canSubmit, "Expect submit to be disabled after entering second question")
    }

    func test_submitButton_messagesExaminerWithSelectedAnswer() {
        let (question, answers) = makeQuestion()
        let (sut, spy) = makeSUT()
        spy.completeLoadWithSuccess(question: question)
        sut.loadViewIfNeeded()

        sut.simulateOptionIsSelected(at: 0)
        sut.simulateTapOnSubmit()
        XCTAssertEqual(spy.respondCallCount, 1)
        XCTAssertEqual(spy.answers, [answers[0]])
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

    func test_submitButton_displaysNextQuestionAfterTapAndClearsSelectedAnswers() {
        let (question1, _) = makeQuestion(title: "first title")
        let (question2, answers) = makeQuestion(title: "second title", answers: [
            Answer(id: UUID(), text: "answer 1"),
            Answer(id: UUID(), text: "answer 2"),
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

    func test_submitButton_notifiesHandler() {
        let (question1, _) = makeQuestion(title: "first title")
        var handlerCallCount = 0
        let (sut, spy) = makeSUT(onFinish: {
            handlerCallCount += 1
        })

        spy.completeLoadWithSuccess(question: question1)
        sut.loadViewIfNeeded()
        sut.simulateOptionIsSelected(at: 0)
        sut.simulateTapOnSubmit()

        XCTAssertEqual(handlerCallCount, 1)
    }

    private func makeSUT(onFinish: @escaping () -> Void = {}, file: StaticString = #filePath, line: UInt = #line) -> (QuizViewController, ExaminerSpy) {
        let spy = ExaminerSpy()
        let sut = QuizUIComposer.composeWith(
            examiner: spy,
            onFinish: onFinish,
            scheduler: DispatchQueue.immediateMainQueueScheduler.eraseToAnyScheduler()
        )

        testMemoryLeak(sut, file: file, line: line)
        testMemoryLeak(spy, file: file, line: line)

        return (sut, spy)
    }

    private func expect(_ cell: UITableViewCell?, toHaveTitle title: String? = nil, isSelected: Bool, file: StaticString = #filePath, line: UInt = #line) {
        let config = cell?.contentConfiguration as? UIListContentConfiguration
        if title != nil {
            XCTAssertEqual(config?.text, title, "Expect cell to have title")
        }
        XCTAssertEqual(cell?.accessoryType, isSelected ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none, file: file, line: line)
    }

    private func makeQuestion(title: String = "any title", answers: [Answer]? = nil) -> (Question, [Answer]) {
        let correctAnswer = Answer(id: UUID(), text: "Correct answer")
        let wrongAnswer = Answer(id: UUID(), text: "Wrong answer")
        let question = Question(id: UUID(), title: title, answers: answers ?? [correctAnswer, wrongAnswer], correctIndex: 0)

        return (question, answers ?? [correctAnswer, wrongAnswer])
    }
}
