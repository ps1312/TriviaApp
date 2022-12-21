import Foundation

public final class QuizViewModel {
    private let examiner: ExaminerDelegate
    private var currentQuestion: Question?
    private var questionNumber = 1

    public init(examiner: ExaminerDelegate) {
        self.examiner = examiner
    }

    public var questionChanged: ((String, [String], Int) -> Void)?
    public var startFailed: (() -> Void)?
    public var finished: (() -> Void)?

    public func load() {
        do {
            let question = try examiner.start()
            let answers = question.answers.map { $0.text }
            currentQuestion = question

            questionChanged?(question.title, answers, questionNumber)
        } catch {
            startFailed?()
        }
    }

    public func respond(with index: Int) {
        guard let question = currentQuestion else { return }

        if let nextQuestion = examiner.respond(question, with: index) {
            let answers = nextQuestion.answers.map { $0.text }
            currentQuestion = nextQuestion
            questionNumber += 1
            questionChanged?(nextQuestion.title, answers, questionNumber)
        } else {
            finished?()
        }
    }
}
