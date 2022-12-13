import UIKit
import TriviaEngine

final class ResultsViewController: UITableViewController {
    var score: Score?

    @IBOutlet private(set) public var totalScoreLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Results"
        totalScoreLabel.text = "Your score: \(score?.points ?? 0)"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultAnswerCell") as! ResultAnswerCell
        let attempt = score?.responses[indexPath.row]

        cell.correctAnswerLabel.text = attempt?.answer.text
        cell.wrongAnswerLabel.text = attempt?.answer.text

        cell.wrongAnswerLabel.isHidden = attempt?.isCorrect ?? true
        
        return cell
    }
}
