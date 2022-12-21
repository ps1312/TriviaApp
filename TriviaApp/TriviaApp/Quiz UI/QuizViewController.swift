import TriviaEngine
import UIKit

final class QuizViewController: UITableViewController {
    @IBOutlet public private(set) var questionTitleLabel: UILabel!
    @IBOutlet public private(set) var questionNumberLabel: UILabel!

    public var onFinish: (() -> Void)?
    var optionsControllers = [IndexPath: OptionCellViewController]()

    var selected: IndexPath?
    var viewModel: QuizViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBindings()
        startGame()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeTableHeaderToFit()
    }

    @objc func startGame() {
        viewModel?.load()
    }

    override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = indexPath
        setupNextButton(title: "Submit", action: #selector(submit))
        tableView.reloadData()
    }

    @objc func submit() {
        viewModel?.respond(with: selected!.row)
    }

    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        optionsControllers.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let view = optionsControllers[indexPath]
        return view!.view(tableView, indexPath: indexPath, selected: selected == indexPath)
    }

    private func setupBindings() {
        viewModel?.questionChanged = { [weak self] in
            self?.setupNextQuestion(title: $0, newOptions: $1, questionNumber: $2)
        }

        viewModel?.startFailed = { [weak self] in
            self?.questionTitleLabel.text = "Something went wrong loading the questions, please try again."
            self?.setupNextButton(title: "Retry", action: #selector(self?.startGame))
        }

        viewModel?.finished = { [weak self] in
            self?.setupNextButton(title: "Submit", isEnabled: false)
            self?.onFinish?()
        }
    }

    // MARK: - UI Helpers

    private func setupNextQuestion(title: String, newOptions: [String], questionNumber: Int) {
        questionTitleLabel.text = title
        setupNextButton(title: "Submit", isEnabled: false)
        selected = nil

        updateQuestionNumber(newNumber: questionNumber)
        refreshOptions(newOptions: newOptions)
    }

    private func updateQuestionNumber(newNumber: Int) {
        questionNumberLabel.isHidden = false
        questionNumberLabel.text = "Question \(newNumber)"
    }

    private func refreshOptions(newOptions: [String]) {
        newOptions.enumerated().forEach { index, title in
            let indexPath = IndexPath(row: index, section: 0)
            self.optionsControllers[indexPath] = OptionCellViewController(title: title)
        }

        tableView.reloadData()
    }

    private func setupNextButton(title: String, action: Selector? = nil, isEnabled: Bool = true) {
        let actionButton = UIBarButtonItem(title: title, style: .plain, target: self, action: action)
        actionButton.isEnabled = isEnabled

        setToolbarItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            actionButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
        ], animated: true)
    }
}
