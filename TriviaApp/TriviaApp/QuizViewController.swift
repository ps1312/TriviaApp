import UIKit
import TriviaEngine

public final class QuizViewController: UITableViewController {
    public var examiner: ExaminerDelegate?

    public override func viewDidLoad() {
        startGame()
    }

    @objc func startGame() {
        do {
            _ = try examiner?.start()
            setToolbarItems([
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                UIBarButtonItem(title: "Submit", style: .plain, target: self, action: nil),
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

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)

        var config = cell.defaultContentConfiguration()
        config.text = indexPath.row == 0 ? "True" : "False"

        cell.contentConfiguration = config
        cell.accessoryType = indexPath.row == 0 ? .checkmark : .none

        return cell
    }
}

