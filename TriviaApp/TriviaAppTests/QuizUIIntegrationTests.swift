import XCTest
import TriviaApp
import TriviaEngine

class QuizUIIntegrationTests: XCTestCase {
    func test_viewDidLoad_requestsExaminerForStart() {
        let bundle = Bundle(for: QuizViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let navController = storyboard.instantiateInitialViewController() as! UINavigationController
        let viewController = navController.topViewController as! QuizViewController
        let spy = ExaminerSpy()
        viewController.examiner = spy
        viewController.loadViewIfNeeded()

        XCTAssertEqual(spy.startCallCount, 1)
    }

    private class ExaminerSpy: ExaminerDelegate {
        var startCallCount = 0

        func start() throws -> Question {
            startCallCount += 1
            let answer = Answer(id: UUID(), text: "answer 1")
            return Question(id: UUID(), title: "question 1?", answers: [answer], correctAnswer: answer)
        }

        func respond(_ question: Question, with answer: Answer) -> Question? {
            nil
        }

        func evaluate() -> Score {
            Score(points: 0, responses: [])
        }
    }
}
