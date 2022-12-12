import UIKit
import TriviaEngine

public final class QuizViewController: UITableViewController {
    @IBOutlet private(set) public var questionTitleLabel: UILabel!

    private var question: Question?
    private var answer: Answer?
    private var options = [Answer]()
    public var examiner: ExaminerDelegate?

    public override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
    }

    @objc func startGame() {
        do {
            guard let question = try examiner?.start() else { return }
            self.question = question
            questionTitleLabel.text = question.title
            options = question.answers

            updateToolbar(title: "Submit", isEnabled: false)
        } catch {
            updateToolbar(title: "Retry", action: #selector(startGame))
        }
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        answer = question?.answers[indexPath.row]
        updateToolbar(title: "Submit", action: #selector(submit))
        tableView.reloadData()
    }

    @objc func submit() {
        question = examiner?.respond(question!, with: answer!)
        updateToolbar(title: "Submit", isEnabled: false)
        
        guard let question = question else {
            _ = examiner?.evaluate()
            return
        }

        options = question.answers
        questionTitleLabel.text = question.title
        answer = nil
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
        cell.accessoryType = answer?.id == option.id ? .checkmark : .none
        
        return cell
    }

    private func updateToolbar(title: String, action: Selector? = nil, isEnabled: Bool = true) {
        let actionButton = UIBarButtonItem(title: title, style: .plain, target: self, action: action)
        actionButton.isEnabled = isEnabled

        setToolbarItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            actionButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        ], animated: true)
    }
}

