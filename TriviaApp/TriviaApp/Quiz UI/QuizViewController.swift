import UIKit
import TriviaEngine

final class QuizViewController: UITableViewController {
    @IBOutlet private(set) public var questionTitleLabel: UILabel!
    @IBOutlet private(set) public var questionNumberLabel: UILabel!

    private var question: Question?
    private var answer: Answer?
    private var options = [Answer]()

    public var examiner: ExaminerDelegate?
    public var onFinish: (() -> Void)?

    var questionNumber = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeTableHeaderToFit()
    }

    @objc func startGame() {
        questionNumberLabel.isHidden = true

        do {
            guard let question = try examiner?.start() else { return }
            self.question = question
            questionTitleLabel.text = question.title
            options = question.answers

            updateToolbar(title: "Submit", isEnabled: false)
            questionNumberLabel.isHidden = false
            questionNumberLabel.text = "Question \(questionNumber)"
        } catch {
            questionTitleLabel.text = "Something went wrong loading the questions, please try again."
            updateToolbar(title: "Retry", action: #selector(startGame))
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        answer = question?.answers[indexPath.row]
        updateToolbar(title: "Submit", action: #selector(submit))
        tableView.reloadData()
    }

    @objc func submit() {
        question = examiner?.respond(question!, with: answer!)
        updateToolbar(title: "Submit", isEnabled: false)

        guard let question = question else {
            onFinish?()
            return
        }

        options = question.answers
        questionTitleLabel.text = question.title
        answer = nil
        questionNumber += 1
        questionNumberLabel.text = "Question \(questionNumber)"
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

