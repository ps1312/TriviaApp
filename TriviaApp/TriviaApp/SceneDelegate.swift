import TriviaEngine
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private lazy var navigationController: UINavigationController = {
        let nav = UINavigationController()
        nav.isToolbarHidden = false
        return nav
    }()

    private lazy var scheduler: AnyDispatchQueueScheduler = DispatchQueue(
        label: "com.triviaApp.queue",
        qos: .userInitiated
    ).eraseToAnyScheduler()

    convenience init(scheduler: AnyDispatchQueueScheduler) {
        self.init()
        self.scheduler = scheduler
    }

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        configureView()
    }

    func configureView() {
        navigateToQuiz()
        navigationController.navigationBar.prefersLargeTitles = false

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private func navigateToQuiz() {
        let examiner = Examiner(questionsLoader: InMemoryQuestionsLoader())

        navigationController.viewControllers = [
            QuizUIComposer.composeWith(examiner: examiner, onFinish: { self.navigateToResults(with: examiner) }, scheduler: scheduler),
        ]
    }

    private func navigateToResults(with examiner: ExaminerDelegate) {
        navigationController.viewControllers = [
            ResultsUIComposer.composeWith(examiner: examiner, onRestart: configureView),
        ]
    }
}
