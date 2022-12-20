import TriviaEngine
import UIKit

final class QuizViewController: UITableViewController {
    @IBOutlet public private(set) var questionTitleLabel: UILabel!
    @IBOutlet public private(set) var questionNumberLabel: UILabel!

    private var question: Question?

    public var examiner: ExaminerDelegate?
    public var onFinish: (() -> Void)?

    var optionsControllers = [IndexPath: OptionCellViewController]()

    var questionNumber = 1

    var selected: IndexPath?

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

            question.answers.enumerated().forEach { index, option in
                let indexPath = IndexPath(row: index, section: 0)
                self.optionsControllers[indexPath] = OptionCellViewController(model: option)
            }

            updateToolbar(title: "Submit", isEnabled: false)
            questionNumberLabel.isHidden = false
            questionNumberLabel.text = "Question \(questionNumber)"
        } catch {
            questionTitleLabel.text = "Something went wrong loading the questions, please try again."
            updateToolbar(title: "Retry", action: #selector(startGame))
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = indexPath
        updateToolbar(title: "Submit", action: #selector(submit))
        tableView.reloadData()
    }

    @objc func submit() {
        question = examiner?.respond(question!, with: selected!.row)

        updateToolbar(title: "Submit", isEnabled: false)

        guard let question = question else {
            onFinish?()
            return
        }

        question.answers.enumerated().forEach { index, option in
            let indexPath = IndexPath(row: index, section: 0)
            self.optionsControllers[indexPath] = OptionCellViewController(model: option)
        }

        selected = nil
        questionTitleLabel.text = question.title
        questionNumber += 1
        questionNumberLabel.text = "Question \(questionNumber)"
        tableView.reloadData()
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        optionsControllers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view = optionsControllers[indexPath]
        return view!.view(tableView, indexPath: indexPath, selected: selected == indexPath)
    }

    private func updateToolbar(title: String, action: Selector? = nil, isEnabled: Bool = true) {
        let actionButton = UIBarButtonItem(title: title, style: .plain, target: self, action: action)
        actionButton.isEnabled = isEnabled

        setToolbarItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            actionButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
        ], animated: true)
    }
}
