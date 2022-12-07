import XCTest
import TriviaEngine

class ExaminerWithInMemoryQuestionsLoaderTests: XCTestCase {
    func test_examinerWithInMemoryQuestionsLoader_deliversZeroScoreWhenRespondingWithWrongAnswers() throws {
        let inMemoryQuestionsLoader = InMemoryQuestionsLoader()
        let examiner = Examiner(questionsLoader: inMemoryQuestionsLoader)

        let firstQuestion = try examiner.start()
        let secondQuestion = examiner.respond(firstQuestion, with: firstQuestion.answers[0])!
        _ = examiner.respond(secondQuestion, with: secondQuestion.answers[0])

        let score = examiner.evaluate()

        XCTAssertEqual(score.points, 0)
        XCTAssertEqual(score.responses.first?.isCorrect, false)
        XCTAssertEqual(score.responses.last?.isCorrect, false)
    }

    func test_examinerWithInMemoryQuestionsLoader_deliversFullScoreWhenRespondingWithCorrectAnswers() throws {
        let inMemoryQuestionsLoader = InMemoryQuestionsLoader()
        let examiner = Examiner(questionsLoader: inMemoryQuestionsLoader)

        let firstQuestion = try examiner.start()
        let secondQuestion = examiner.respond(firstQuestion, with: firstQuestion.answers[2])!
        _ = examiner.respond(secondQuestion, with: secondQuestion.answers[2])

        let score = examiner.evaluate()

        XCTAssertEqual(score.points, 2)
        XCTAssertEqual(score.responses.first?.isCorrect, true)
        XCTAssertEqual(score.responses.last?.isCorrect, true)
    }
}
