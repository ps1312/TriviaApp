import TriviaEngine
import UIKit

final class ResultsViewController: UITableViewController {
    var score = Score(points: 0, responses: [])
    var onRestart: (() -> Void)?

    @IBOutlet public private(set) var totalScoreLabel: UILabel!
    @IBOutlet public private(set) var playAgainButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Results"
        totalScoreLabel.text = "Your score: \(score.points)"
        playAgainButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
    }

    @objc func tap() {
        onRestart?()
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        score.responses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultAnswerCell") as! ResultAnswerCell
        let attempt = score.responses[indexPath.row]

        cell.correctAnswerLabel.text = attempt.isCorrect ? attempt.answer.text : attempt.question.correctAnswer.text
        cell.wrongAnswerLabel.text = attempt.answer.text

        cell.wrongAnswerLabel.isHidden = attempt.isCorrect

        return cell
    }
}
