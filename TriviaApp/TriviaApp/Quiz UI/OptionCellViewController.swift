import TriviaEngine
import UIKit

final class OptionCellViewController {
    private let title: String
    private let cell = UITableViewCell()

    init(title: String) {
        self.title = title
    }

    func view(_ tableView: UITableView, indexPath: IndexPath, selected: Bool) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)

        var config = cell.defaultContentConfiguration()
        config.text = title

        cell.contentConfiguration = config
        cell.accessoryType = selected ? .checkmark : .none

        return cell
    }
}
