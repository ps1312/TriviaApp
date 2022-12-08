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
        let (sut, spy) = makeSUT()
        
        spy.completeLoadWithError()
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingStartRetry, "Expected retry button after questions loading has failed on start")

        spy.completeLoadWithSuccess(question: makeQuestion())
        sut.simulateTapOnRetry()
        XCTAssertEqual(spy.startCallCount, 2, "Expected another start after user requests retry")
        XCTAssertFalse(sut.isShowingStartRetry, "Expected no retry button after questions loading succeeds")
    }

    func test_viewDidLoad_displaysFirstQuestionAndAnswers() {
        let firstAnswer = Answer(id: UUID(), text: "correct answer")
        let lastAnswer = Answer(id: UUID(), text: "wrong answer")

        let question = makeQuestion(title: "another title", answers: [firstAnswer, lastAnswer])
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

    private func makeSUT() -> (QuizViewController, ExaminerSpy) {
        let bundle = Bundle(for: QuizViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let navController = storyboard.instantiateInitialViewController() as! UINavigationController
        let sut = navController.topViewController as! QuizViewController
        let spy = ExaminerSpy()
        sut.examiner = spy

        return (sut, spy)
    }

    private func makeQuestion(title: String = "", answers: [Answer] = []) -> Question {
        Question(id: UUID(), title: title, answers: answers, correctAnswer: Answer(id: UUID(), text: ""))
    }

    private class ExaminerSpy: ExaminerDelegate {
        var startCallCount = 0
        var startResult: Question?

        func start() throws -> Question {
            startCallCount += 1

            guard let startResult = startResult else {
                throw NSError(domain: "test error", code: 999)
            }

            return startResult
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

        func completeLoadWithSuccess(question: Question) {
            startResult = question
        }
    }
}

extension QuizViewController {
    var isShowingStartRetry: Bool {
        guard let retryButton = toolbarItems?[1] else { return false }
        return retryButton.title == "Retry"
    }

    var questionTitle: String? {
        questionTitleLabel.text
    }

    func simulateTapOnRetry() {
        guard let retryButton = toolbarItems?[1] else { return }
        _ = retryButton.target?.perform(retryButton.action)
    }

    func simulateOptionIsVisible(at index: Int) -> UITableViewCell? {
        let indexPath = IndexPath(row: index, section: 0)
        return tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath)
    }
}
