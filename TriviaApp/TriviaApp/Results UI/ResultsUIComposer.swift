import TriviaEngine
import UIKit

final class ResultsUIComposer {
    static func composeWith(examiner: ExaminerDelegate, onRestart: @escaping () -> Void) -> ResultsViewController {
        let bundle = Bundle(for: ResultsViewController.self)
        let storyboard = UIStoryboard(name: "Results", bundle: bundle)
        let viewController = storyboard.instantiateInitialViewController() as! ResultsViewController
        viewController.score = examiner.evaluate()
        viewController.onRestart = onRestart

        return viewController
    }
}
