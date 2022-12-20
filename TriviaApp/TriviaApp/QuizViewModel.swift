import Foundation
import TriviaEngine

final class QuizViewModel {
    private let examiner: ExaminerDelegate
    private var currentQuestion: Question?
    private var questionNumber = 1

    init(examiner: ExaminerDelegate) {
        self.examiner = examiner
    }

    var questionChanged: ((String, [String], Int) -> Void)?
    var startFailed: (() -> Void)?
    var finished: (() -> Void)?

    func load() {
        do {
            let question = try examiner.start()
            let answers = question.answers.map { $0.text }
            currentQuestion = question

            questionChanged?(question.title, answers, questionNumber)
        } catch {
            startFailed?()
        }
    }

    func respond(with index: Int) {
        guard let currentQuestion = currentQuestion else { return }

        if let nextQuestion = examiner.respond(currentQuestion, with: index) {
            let answers = nextQuestion.answers.map { $0.text }
            questionNumber += 1
            questionChanged?(nextQuestion.title, answers, questionNumber)
        } else {
            finished?()
        }
    }
}
