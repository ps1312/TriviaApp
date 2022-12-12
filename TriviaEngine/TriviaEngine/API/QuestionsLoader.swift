public protocol QuestionsLoader {
    func load() throws -> [Question]
}
