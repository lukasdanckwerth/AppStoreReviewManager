import XCTest
@testable import AppStoreReviewManager

final class AppStoreReviewManagerTests: XCTestCase {
    
    var manager: ASRManager {
        return ASRManager.default
    }
    
    func test_userDefaultsKeys() throws {
        XCTAssertEqual(manager.bundleIdentifier, "de.aid.AppStoreReviewManager")
        XCTAssertEqual(manager.reviewWorthyActionsCountKey, "de.aid.AppStoreReviewManager.ReviewWorthyActionsCount")
        XCTAssertEqual(manager.lastVersionPromptedForReviewKey, "de.aid.AppStoreReviewManager.LastVersionPromptedForReview")
    }
    
    func test_currentVersionAfterResetIsZero() throws {
        manager.resetLastVersionPromptedForReview()
        // XCTAssertEqual(manager.currentVersion, "0")
    }
    
    func test_resetReviewWorthyActionsCount() {
        manager.resetReviewWorthyActionsCount()
        XCTAssertEqual(manager.reviewWorthyActionsCount, 0)
    }
    
    func test_increaseReviewWorthyActionsCount() {
        let before = manager.reviewWorthyActionsCount
        manager.increaseReviewWorthyActionsCount()
        XCTAssertEqual(manager.reviewWorthyActionsCount, before + 1)
    }
    
    func test_requestReview() {
        XCTAssertEqual(manager.shouldRequestReview(for: 0), false)
        XCTAssertEqual(manager.shouldRequestReview(for: 30), false)
        XCTAssertEqual(manager.shouldRequestReview(for: 10), true)
        XCTAssertEqual(manager.shouldRequestReview(for: 25), true)
    }
}
