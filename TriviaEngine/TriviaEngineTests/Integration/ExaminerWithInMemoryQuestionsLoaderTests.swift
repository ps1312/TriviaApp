import TriviaEngine
import XCTest

class ExaminerWithInMemoryQuestionsLoaderTests: XCTestCase {
    let correctIndex = 2
    let wrongIndex = 1

    func test_examinerWithInMemoryQuestionsLoader_deliversZeroScoreWhenRespondingWithWrongAnswers() throws {
        let examiner = makeSUT()

        let firstQuestion = try examiner.start()
        let secondQuestion = examiner.respond(firstQuestion, with: wrongIndex)!
        _ = examiner.respond(secondQuestion, with: wrongIndex)

        let score = examiner.evaluate()

        XCTAssertEqual(score.points, 0)
        XCTAssertEqual(score.responses.first?.isCorrect, false)
        XCTAssertEqual(score.responses.last?.isCorrect, false)
    }

    func test_examinerWithInMemoryQuestionsLoader_deliversFinalScoreScoreWhenRespondingWithOneRightAnswer() throws {
        let examiner = makeSUT()

        let firstQuestion = try examiner.start()
        let secondQuestion = examiner.respond(firstQuestion, with: wrongIndex)!
        _ = examiner.respond(secondQuestion, with: correctIndex)

        let score = examiner.evaluate()

        XCTAssertEqual(score.points, 1)
        XCTAssertEqual(score.responses.first?.isCorrect, false)
        XCTAssertEqual(score.responses.last?.isCorrect, true)
    }

    func test_examinerWithInMemoryQuestionsLoader_deliversFullScoreWhenRespondingWithCorrectAnswers() throws {
        let examiner = makeSUT()

        let firstQuestion = try examiner.start()
        let secondQuestion = examiner.respond(firstQuestion, with: correctIndex)!
        _ = examiner.respond(secondQuestion, with: correctIndex)

        let score = examiner.evaluate()

        XCTAssertEqual(score.points, 2)
        XCTAssertEqual(score.responses.first?.isCorrect, true)
        XCTAssertEqual(score.responses.last?.isCorrect, true)
    }

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> Examiner {
        let inMemoryQuestionsLoader = InMemoryQuestionsLoader()
        let examiner = Examiner(questionsLoader: inMemoryQuestionsLoader)

        testMemoryLeak(inMemoryQuestionsLoader, file: file, line: line)
        testMemoryLeak(examiner, file: file, line: line)

        return examiner
    }
}
