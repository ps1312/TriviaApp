import Foundation
import TriviaEngine

func makeQuestion(title: String = "any title", answers: [Answer]? = nil) -> (Question, [Answer]) {
    let correctAnswer = Answer(id: UUID(), text: "Correct answer")
    let wrongAnswer = Answer(id: UUID(), text: "Wrong answer")
    let question = Question(id: UUID(), title: title, answers: answers ?? [correctAnswer, wrongAnswer], correctIndex: 0)

    return (question, answers ?? [correctAnswer, wrongAnswer])
}
