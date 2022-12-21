import TriviaEngine
import UIKit

final class QuizUIComposer {
    static func composeWith(examiner: ExaminerDelegate, onFinish: @escaping () -> Void) -> QuizViewController {
        let bundle = Bundle(for: QuizViewController.self)
        let storyboard = UIStoryboard(name: "Quiz", bundle: bundle)
        let viewController = storyboard.instantiateInitialViewController() as! QuizViewController
        viewController.viewModel = QuizViewModel(examiner: examiner)
        viewController.onFinish = onFinish

        return viewController
    }
}
