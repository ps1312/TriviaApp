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
        updateToolbar(title: "Submit", action: #selector(submit))
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
        viewModel?.questionChanged = { [weak self] title, options, questionNumber in
            guard let self = self else { return }
            self.questionTitleLabel.text = title
            self.questionNumberLabel.isHidden = false
            self.questionNumberLabel.text = "Question \(questionNumber)"
            self.updateToolbar(title: "Submit", isEnabled: false)
            self.selected = nil
            options.enumerated().forEach { index, title in
                let indexPath = IndexPath(row: index, section: 0)
                self.optionsControllers[indexPath] = OptionCellViewController(title: title)
            }
            self.tableView.reloadData()
        }

        viewModel?.startFailed = { [weak self] in
            self?.questionTitleLabel.text = "Something went wrong loading the questions, please try again."
            self?.updateToolbar(title: "Retry", action: #selector(self?.startGame))
        }

        viewModel?.finished = { [weak self] in
            self?.updateToolbar(title: "Submit", isEnabled: false)
            self?.onFinish?()
        }
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
