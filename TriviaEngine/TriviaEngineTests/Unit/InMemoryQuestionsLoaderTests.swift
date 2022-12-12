import XCTest
import TriviaEngine

class InMemoryQuestionsLoaderTests: XCTestCase {
    func test_load_deliversDefaultTriviaQuestions() {
        let sut = InMemoryQuestionsLoader()

        let questions = try! sut.load()
        XCTAssertEqual(questions.count, 2)
        XCTAssertEqual(questions[0].title, "What is the capital of Brazil?")
        XCTAssertEqual(questions[0].correctAnswer.text, "Brasília")
        XCTAssertEqual(questions[1].title, "In what year Apollo 11 landed on the moon?")
        XCTAssertEqual(questions[1].correctAnswer.text, "1969")
    }
}
