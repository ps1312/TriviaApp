import Foundation
import TriviaEngine
import XCTest

func makeQuestion(title: String = "any title", answers: [Answer]? = nil) -> (Question, [Answer]) {
    let correctAnswer = Answer(id: UUID(), text: "Correct answer")
    let wrongAnswer = Answer(id: UUID(), text: "Wrong answer")
    let question = Question(id: UUID(), title: title, answers: answers ?? [correctAnswer, wrongAnswer], correctIndex: 0)

    return (question, answers ?? [correctAnswer, wrongAnswer])
}

extension XCTestCase {
    func testMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Expected instance to be nil after SUT has been deallocated", file: file, line: line)
        }
    }
}
