import Combine
import Foundation

public final class QuizViewModel {
    private let examiner: ExaminerDelegate
    private let scheduler: AnyDispatchQueueScheduler
    private var currentQuestion: Question?
    private var questionNumber = 1
    private var cancellable: Cancellable?

    public init(examiner: ExaminerDelegate, scheduler: AnyDispatchQueueScheduler) {
        self.examiner = examiner
        self.scheduler = scheduler
    }

    public var questionChanged: ((String, [String], Int) -> Void)?
    public var loadingChanged: ((Bool) -> Void)?
    public var startFailed: (() -> Void)?
    public var finished: (() -> Void)?

    public func load() {
        loadingChanged?(true)

        cancellable = loadPublisher()
            .subscribe(on: scheduler)
            .receive(on: DispatchQueue.immediateMainQueueScheduler)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished: break

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
