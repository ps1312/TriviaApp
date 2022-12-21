import TriviaEngine
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var navigationController: UINavigationController = {
        let nav = UINavigationController()
        nav.isToolbarHidden = false
        return nav
    }()

    private lazy var examiner: ExaminerDelegate = {
        Examiner(questionsLoader: InMemoryQuestionsLoader())
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
        navigationController.viewControllers = [
            QuizUIComposer.composeWith(examiner: examiner, onFinish: navigateToResults),
        ]
    }

    private func navigateToResults() {
        navigationController.viewControllers = [
            ResultsUIComposer.composeWith(examiner: examiner, onRestart: configureView),
        ]
    }
}
