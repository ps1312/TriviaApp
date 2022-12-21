@testable import TriviaApp
import UIKit

extension QuizViewController {
    var isShowingStartRetry: Bool {
        guard let retryButton = toolbarItems?[1] else { return false }
        return retryButton.title == "Retry"
    }

    var isShowingSubmit: Bool {
        guard let submitButton = toolbarItems?[1] else { return false }
        return submitButton.title == "Submit"
    }

    var isDisplayingQuestionsNumber: Bool {
        !questionNumberLabel.isHidden
    }

    var isToolbarVisible: Bool {
        guard let nav = navigationController else { return false }
        return nav.isToolbarHidden == false
    }

    var questionTitle: String? {
        questionTitleLabel.text
    }

    var questionNumberText: String? {
        questionNumberLabel.text
    }

    var canSubmit: Bool {
        guard let submitButton = toolbarItems?[1] else { return false }
        return submitButton.isEnabled
    }

    func simulateTapOnRetry() {
        guard let retryButton = toolbarItems?[1] else { return }
        _ = retryButton.target?.perform(retryButton.action)
    }

    func simulateOptionIsVisible(at index: Int) -> UITableViewCell? {
        let indexPath = IndexPath(row: index, section: 0)
        return tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath)
    }

    func simulateOptionIsSelected(at index: Int) {
        let indexPath = IndexPath(row: index, section: 0)
        tableView.delegate?.tableView?(tableView, didSelectRowAt: indexPath)
        tableView.layoutIfNeeded()
    }

    func simulateTapOnSubmit() {
        guard let submitButton = toolbarItems?[1] else { return }
        _ = submitButton.target?.perform(submitButton.action)
    }
}
