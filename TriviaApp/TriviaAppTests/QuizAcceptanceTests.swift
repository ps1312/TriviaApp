import XCTest
import TriviaEngine
@testable import TriviaApp

class QuizAcceptanceTests: XCTestCase {
    func test_quiz_displaysFirstQuestionAndAnswers() {
        let sceneDelegate = SceneDelegate()
        sceneDelegate.window = UIWindow(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        sceneDelegate.configureView()

        let navController = sceneDelegate.window?.rootViewController as? UINavigationController
        let sut = navController?.topViewController as? QuizViewController
        sut?.examiner = Examiner(questionsLoader: InMemoryQuestionsLoader())
        sut?.loadViewIfNeeded()

        XCTAssertEqual(sut?.questionTitleLabel.text, "What is the capital of Brazil?")

        let firstOption = sut?.simulateOptionIsVisible(at: 0)
        expect(firstOption, toHaveTitle: "Pernambuco", isSelected: false)

        let secondOption = sut?.simulateOptionIsVisible(at: 1)
        expect(secondOption, toHaveTitle: "Rio de Janeiro", isSelected: false)

        let thirdOption = sut?.simulateOptionIsVisible(at: 2)
        expect(thirdOption, toHaveTitle: "Brasília", isSelected: false)

        let lastOption = sut?.simulateOptionIsVisible(at: 3)
        expect(lastOption, toHaveTitle: "São Paulo", isSelected: false)
    }

    private func expect(_ cell: UITableViewCell?, toHaveTitle title: String? = nil, isSelected: Bool) {
        let config = cell?.contentConfiguration as? UIListContentConfiguration
        if title != nil {
            XCTAssertEqual(config?.text, title, "Expect cell to have title")
        }
        XCTAssertEqual(cell?.accessoryType, isSelected ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none)
    }
}
