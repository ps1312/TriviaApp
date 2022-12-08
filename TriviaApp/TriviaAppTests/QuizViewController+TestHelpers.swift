import UIKit
import TriviaApp

extension QuizViewController {
    var isShowingStartRetry: Bool {
        guard let retryButton = toolbarItems?[1] else { return false }
        return retryButton.title == "Retry"
    }

    var questionTitle: String? {
        questionTitleLabel.text
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
}
