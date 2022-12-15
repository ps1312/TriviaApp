@testable import TriviaApp
import XCTest

class SceneDelegateTests: XCTest {
    func test_sceneWillConnectToSession_configuresWindow() {
        let window = UIWindow()
        let sut = SceneDelegate()
        sut.window = window

        sut.configureView()

        let root = sut.window?.rootViewController as! UINavigationController
        XCTAssertNotNil(root, "Expect root view controller attached to window to be an UINavigationController")
        XCTAssertNotNil(root.topViewController as! QuizViewController, "Expected navigation top view controller to be a QuizViewController")
    }
}
