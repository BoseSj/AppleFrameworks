import Testing
@testable import SwiftTestingLrn

extension Tag {
	@Tag static var isMath: Tag
}

@Suite("Math test suite", .tags(.isMath))
struct MathTests {
	@Test(
		"Two minus Test",
		arguments: [1, 2, 3, 4],
		[5, 4, 3, 1]
	)
	func twoMinusTest(a: Int, b: Int) async throws {
		#expect(minus(of: a, with: b) == a-b)
	}
	
	@Test(
		"Two sum Test",
		arguments: [1, 2, 3, 4],
		[5, 4, 3, 1]
	)
	func twoSumTest(a: Int, b: Int) async throws {
		#expect(sum(of: a, with: b) == a+b)
	}
}
