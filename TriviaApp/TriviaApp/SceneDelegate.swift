import TriviaEngine
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: scene)
        configureView()
    }

    func configureView() {
        let bundle = Bundle(for: QuizViewController.self)
        let storyboard = UIStoryboard(name: "Quiz", bundle: bundle)
        let navController = storyboard.instantiateInitialViewController() as! UINavigationController
        let quizViewController = navController.topViewController as! QuizViewController
        let examiner = Examiner(questionsLoader: InMemoryQuestionsLoader())

        quizViewController.viewModel = QuizViewModel(examiner: examiner)
        quizViewController.onFinish = {
            let bundle2 = Bundle(for: ResultsViewController.self)
            let storyboard2 = UIStoryboard(name: "Results", bundle: bundle2)
            let navController2 = storyboard2.instantiateInitialViewController() as! UINavigationController
            let resultsViewController = navController2.topViewController as! ResultsViewController
            resultsViewController.score = examiner.evaluate()
            resultsViewController.onRestart = {
                self.configureView()
            }

            navController.viewControllers = [resultsViewController]
        }

        window?.rootViewController = navController
        window?.makeKeyAndVisible()
    }
}
