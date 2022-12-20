import TriviaEngine
import UIKit

final class OptionCellViewController {
    private let model: Answer
    private let cell = UITableViewCell()

    init(model: Answer) {
        self.model = model
    }

    func view(_ tableView: UITableView, indexPath: IndexPath, selected: Bool) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)

        var config = cell.defaultContentConfiguration()
        config.text = model.text

        cell.contentConfiguration = config
        cell.accessoryType = selected ? .checkmark : .none

        return cell
    }
}
