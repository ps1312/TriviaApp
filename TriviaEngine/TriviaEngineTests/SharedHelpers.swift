import XCTest

extension XCTestCase {
    func testMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Expected instance to be nil after SUT has been deallocated", file: file, line: line)
        }
    }
}
