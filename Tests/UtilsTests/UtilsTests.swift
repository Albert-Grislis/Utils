import XCTest
@testable import Utils

final class UtilsTests: XCTestCase {
    func testExample() {
        XCTAssertEqual(Utils().text, "Utils!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
