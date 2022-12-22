@testable import TriviaApp
import TriviaEngine
import XCTest

class QuizAcceptanceTests: XCTestCase {
    func test_quiz_displaysFirstQuestionAndAnswers() {
        let nav = makeSUT()
        let sut = nav.topViewController as! QuizViewController
        sut.loadViewIfNeeded()

        XCTAssertEqual(sut.questionTitleLabel.text, "What is the capital of Brazil?")

        let firstOption = sut.simulateOptionIsVisible(at: 0)
        expect(firstOption, toHaveTitle: "Pernambuco", isSelected: false)

        let secondOption = sut.simulateOptionIsVisible(at: 1)
        expect(secondOption, toHaveTitle: "Rio de Janeiro", isSelected: false)

        let thirdOption = sut.simulateOptionIsVisible(at: 2)
        expect(thirdOption, toHaveTitle: "Brasília", isSelected: false)

        let lastOption = sut.simulateOptionIsVisible(at: 3)
        expect(lastOption, toHaveTitle: "São Paulo", isSelected: false)

        XCTAssertTrue(sut.isToolbarVisible, "Expected toolbar to be visible")
    }

    func test_quiz_displaysResultsAfterLastQuestionWithAllCorrectAnswers() {
        let nav = makeSUT()
        let sut = nav.topViewController as! QuizViewController
        sut.loadViewIfNeeded()

        selectAnswer(in: sut, at: 2)
        selectAnswer(in: sut, at: 2)

        let results = try? XCTUnwrap(nav.topViewController as? ResultsViewController)
        results?.loadViewIfNeeded()
        XCTAssertEqual(results?.totalScore, "Your score: 2", "Expected full score after finishing with all correct answers")
        XCTAssertEqual(results?.numberOfAttempts, 2)

        let view0 = results?.simulateAttemptIsVisible(at: 0) as? ResultAnswerCell
        XCTAssertEqual(view0?.correctAnswerText, "Brasília")

        let view1 = results?.simulateAttemptIsVisible(at: 1) as? ResultAnswerCell
        XCTAssertEqual(view1?.correctAnswerText, "1969")
    }

    func test_playAgain_restartsGame() {
        let scheduler = DispatchQueue.immediateMainQueueScheduler.eraseToAnyScheduler()
        let sceneDelegate = SceneDelegate(scheduler: scheduler)
        sceneDelegate.window = UIWindow(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        sceneDelegate.configureView()

        let nav = sceneDelegate.window?.rootViewController as! UINavigationController
        let sut = nav.topViewController as! QuizViewController
        sut.loadViewIfNeeded()

        selectAnswer(in: sut, at: 2)
        selectAnswer(in: sut, at: 2)

        let results = try! XCTUnwrap(nav.topViewController as? ResultsViewController)
        results.loadViewIfNeeded()

        results.simulateTapOnPlayAgain()

        let currentView = try! XCTUnwrap(nav.topViewController as? QuizViewController)
        currentView.loadViewIfNeeded()

        XCTAssertEqual(currentView.questionTitleLabel.text, "What is the capital of Brazil?")

        selectAnswer(in: currentView, at: 2)
        selectAnswer(in: currentView, at: 2)

        let secondResults = try! XCTUnwrap(nav.topViewController as? ResultsViewController)
        XCTAssertEqual(secondResults.numberOfAttempts, 2)
    }

    private func makeSUT() -> UINavigationController {
        let scheduler = DispatchQueue.immediateMainQueueScheduler.eraseToAnyScheduler()
        let sceneDelegate = SceneDelegate(scheduler: scheduler)
        sceneDelegate.window = UIWindow(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        sceneDelegate.configureView()

        let nav = sceneDelegate.window?.rootViewController as! UINavigationController

        return nav
    }

    private func selectAnswer(in sut: QuizViewController, at index: Int) {
        _ = sut.simulateOptionIsVisible(at: index)
        sut.simulateOptionIsSelected(at: index)
        sut.simulateTapOnSubmit()
        RunLoop.current.run(until: Date())
    }

    private func expect(_ cell: UITableViewCell?, toHaveTitle title: String? = nil, isSelected: Bool) {
        let config = cell?.contentConfiguration as? UIListContentConfiguration
        if title != nil {
            XCTAssertEqual(config?.text, title, "Expect cell to have title")
        }
        XCTAssertEqual(cell?.accessoryType, isSelected ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none)
    }
}
