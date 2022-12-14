@testable import TriviaApp
import UIKit

extension ResultsViewController {
    var totalScore: String? {
        return totalScoreLabel.text
    }

    var numberOfAttempts: Int? {
        tableView.dataSource?.tableView(tableView, numberOfRowsInSection: 0)
    }

    func simulateAttemptIsVisible(at row: Int) -> UITableViewCell? {
        let indexPath = IndexPath(row: row, section: 0)
        return tableView.dataSource?.tableView(tableView, cellForRowAt: indexPath)
    }

    func simulateTapOnPlayAgain() {
        playAgainButton.allTargets.forEach { target in
            playAgainButton.actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

extension ResultAnswerCell {
    var isDisplayingWrongAnswer: Bool {
        !wrongAnswerLabel.isHidden
    }

    var correctAnswerText: String? {
        correctAnswerLabel.text
    }

    var correctAnswerColor: UIColor {
        correctAnswerLabel.textColor
    }

    var wrongAnswerText: String? {
        wrongAnswerLabel.text
    }

    var wrongAnswerColor: UIColor {
        wrongAnswerLabel.textColor
    }
}
