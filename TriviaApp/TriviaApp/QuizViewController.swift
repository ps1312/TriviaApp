import UIKit
import TriviaEngine

public final class QuizViewController: UITableViewController {
    @IBOutlet private(set) public var questionTitleLabel: UILabel!

    private var options = [Answer]()
    public var examiner: ExaminerDelegate?

    public override func viewDidLoad() {
        startGame()
    }

    @objc func startGame() {
        do {
            guard let question = try examiner?.start() else { return }

            questionTitleLabel.text = question.title
            options = question.answers

            let submitButton = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: nil)
            submitButton.isEnabled = false

            setToolbarItems([
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                submitButton,
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            ], animated: false)
        } catch {
            setToolbarItems([
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                UIBarButtonItem(title: "Retry", style: .plain, target: self, action: #selector(startGame)),
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            ], animated: false)
        }
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let submitButton = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: nil)

        setToolbarItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            submitButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        ], animated: false)
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = options[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)

        var config = cell.defaultContentConfiguration()
        config.text = option.text

        cell.contentConfiguration = config
        cell.accessoryType = .none

        return cell
    }
}

