import UIKit
import TriviaEngine

public final class QuizViewController: UITableViewController {
    public var examiner: ExaminerDelegate?

    public override func viewWillAppear(_ animated: Bool) {
        setToolbarItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Submit", style: .plain, target: self, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        ], animated: animated)
    }

    public override func viewDidLoad() {
        do {
            _ = try examiner?.start()
        } catch {
            setToolbarItems([
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
                UIBarButtonItem(title: "Retry", style: .plain, target: self, action: #selector(retry)),
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
            ], animated: false)
        }
    }

    @objc func retry() {
        _ = try? examiner?.start()
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

