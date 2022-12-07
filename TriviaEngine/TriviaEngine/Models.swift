import Foundation

struct Answer {
    let id: UUID
    let text: String
}

struct Question {
    let title: String
    let answers: [Answer]
    let correctAnswer: Answer
}
