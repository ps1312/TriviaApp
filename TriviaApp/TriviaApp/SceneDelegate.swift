import TriviaEngine
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var navigationController: UINavigationController = {
        let nav = UINavigationController()
        nav.isToolbarHidden = false
        return nav
    }()

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        configureView()
    }

    func configureView() {
        navigateToQuiz()

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private func navigateToQuiz() {
        let examiner = Examiner(questionsLoader: InMemoryQuestionsLoader())

        navigationController.viewControllers = [
            QuizUIComposer.composeWith(examiner: examiner, onFinish: { self.navigateToResults(with: examiner) }),
        ]
    }

    private func navigateToResults(with examiner: ExaminerDelegate) {
        navigationController.viewControllers = [
            ResultsUIComposer.composeWith(examiner: examiner, onRestart: configureView),
        ]
    }
}
