import UIKit

class ViewController: UITableViewController {
    override func viewWillAppear(_ animated: Bool) {
        setToolbarItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Submit", style: .plain, target: self, action: nil),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        ], animated: animated)
    }

    override func viewDidLoad() {
        title = "1 of 5"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)

        var config = cell.defaultContentConfiguration()
        config.text = indexPath.row == 0 ? "True" : "False"

        cell.contentConfiguration = config
        cell.accessoryType = indexPath.row == 0 ? .checkmark : .none

        return cell
    }
}

