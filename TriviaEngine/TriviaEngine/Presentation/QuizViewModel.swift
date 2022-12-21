import Combine
import Foundation

public final class QuizViewModel {
    private let examiner: ExaminerDelegate
    private var currentQuestion: Question?
    private var questionNumber = 1

    public init(examiner: ExaminerDelegate) {
        self.examiner = examiner
    }

    public var questionChanged: ((String, [String], Int) -> Void)?
    public var loadingChanged: ((Bool) -> Void)?
    public var startFailed: (() -> Void)?
    public var finished: (() -> Void)?

    public func load() {
        loadingChanged?(true)

        _ = loadPublisher()
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished:
                    break

                case .failure:
                    self?.startFailed?()
                }

                self?.loadingChanged?(false)
            }, receiveValue: { [weak self] question in
                guard let self = self else { return }
                let answers = question.answers.map { $0.text }
                self.currentQuestion = question
                self.questionChanged?(question.title, answers, self.questionNumber)
            })
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

public extension QuizViewModel {
    func loadPublisher() -> AnyPublisher<Question, Error> {
        Deferred {
            Future { completion in
                do {
                    let question = try self.examiner.start()
                    completion(.success(question))
                } catch {
                    completion(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
