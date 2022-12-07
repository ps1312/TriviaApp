import XCTest
import TriviaEngine

class Examiner {
    let questions = [Question]()
}

class ExaminerTests: XCTestCase {
    func test_init_startsWithNoQuestions() {
        let sut = Examiner()

        XCTAssertTrue(sut.questions.isEmpty)
    }
}
