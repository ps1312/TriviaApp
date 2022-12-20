public protocol ExaminerDelegate {
    func start() throws -> Question
    func respond(_ question: Question, with index: Int) -> Question?
    func evaluate() -> Score
}

public class Examiner: ExaminerDelegate {
    private let questionsLoader: QuestionsLoader
    private var questions = [Question]()
    private var score = Score(points: 0, responses: [])
    private var responses = [AnswerAttempt]()

    public var hasQuestions: Bool {
        !questions.isEmpty
    }

    public enum Error: Swift.Error {
        case loadingQuestions
        case noQuestionsAvailable
    }

    public init(questionsLoader: QuestionsLoader) {
        self.questionsLoader = questionsLoader
    }

    public func start() throws -> Question {
        do {
            questions = try questionsLoader.load()
        } catch {
            throw Error.loadingQuestions
        }

        if questions.isEmpty {
            throw Error.noQuestionsAvailable
        }

        return questions.removeFirst()
    }

    public func respond(_ question: Question, with index: Int) -> Question? {
        let isCorrect = question.correctIndex == index
        let selectedAnswer = question.answers[index]
        let attempt = AnswerAttempt(question: question, answer: selectedAnswer, isCorrect: isCorrect)

        responses.append(attempt)
        score.responses = responses

        if isCorrect {
            score.points += 1
        }

        if questions.isEmpty {
            return nil
        }

        return questions.removeFirst()
    }

    public func evaluate() -> Score {
        score
    }
}
