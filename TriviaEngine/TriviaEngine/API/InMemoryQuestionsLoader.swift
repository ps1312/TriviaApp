import Foundation

public class InMemoryQuestionsLoader: QuestionsLoader {
    let firstQuestionAnswers: [Answer] = [
        Answer(id: UUID(), text: "Pernambuco"),
        Answer(id: UUID(), text: "Rio de Janeiro"),
        Answer(id: UUID(), text: "Brasília"),
        Answer(id: UUID(), text: "São Paulo"),
    ]
    var firstQuestion: Question {
        Question(
            id: UUID(),
            title: "What is the capital of Brazil?",
            answers: firstQuestionAnswers,
            correctIndex: 2
        )
    }

    let secondQuestionAnswers: [Answer] = [
        Answer(id: UUID(), text: "1962"),
        Answer(id: UUID(), text: "1653"),
        Answer(id: UUID(), text: "1969"),
        Answer(id: UUID(), text: "1983"),
    ]
    var secondQuestion: Question {
        Question(
            id: UUID(),
            title: "In what year Apollo 11 landed on the moon?",
            answers: secondQuestionAnswers,
            correctIndex: 2
        )
    }

    public init() {}

    public func load() throws -> [Question] {
        [firstQuestion, secondQuestion]
    }
}
