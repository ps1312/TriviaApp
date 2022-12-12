import UIKit
import TriviaEngine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        configureView()
    }

    func configureView() {
        let bundle = Bundle(for: QuizViewController.self)
//        let storyboard = UIStoryboard(name: "Quiz", bundle: bundle)
//        let navController = storyboard.instantiateInitialViewController() as! UINavigationController
//        let quizViewController = navController.topViewController as! QuizViewController
//        quizViewController.examiner = Examiner(questionsLoader: InMemoryQuestionsLoader())

        let storyboard = UIStoryboard(name: "Results", bundle: bundle)

        window?.rootViewController = storyboard.instantiateInitialViewController()
        window?.makeKeyAndVisible()
    }

}

