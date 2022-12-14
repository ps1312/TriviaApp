import XCTest
import TriviaEngine
@testable import TriviaApp

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
    }

    private func makeSUT() -> UINavigationController {
        let sceneDelegate = SceneDelegate()
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
