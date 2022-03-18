//
//  ASRManager.swift
//  AppStoreReviewManager
//
//  Created by Lukas on 25.12.20.
//  Copyright © 2022 Lukas Danckwerth. All rights reserved.
//

#if canImport(StoreKit)
import StoreKit

public class ASRManager {
    
    // MARK: - Internal API -
    
    /// Returns the bundle identifier.
    ///
    var bundleIdentifier: String {
        return "de.aid.AppStoreReviewManager"
    }
    
    /// Returns the user defaults key for storing the integer of the amount of review worthy actions.
    ///
    var reviewWorthyActionsCountKey: String {
        return "\(bundleIdentifier).ReviewWorthyActionsCount"
    }
    
    /// Returns the user defaults key for storing the string of the version where the user was last prompted.
    ///
    var lastVersionPromptedForReviewKey: String {
        return "\(bundleIdentifier).LastVersionPromptedForReview"
    }
    
    /// Returns the current version (build number) of the app.
    ///
    var currentVersion: String? {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    }
    
    /// Increases the amount of review worthy actions and stores it to the user defaults.
    ///
    func increaseReviewWorthyActionsCount() {
        UserDefaults.standard.set(reviewWorthyActionsCount + 1, forKey: reviewWorthyActionsCountKey)
    }
    
    /// Returns a Boolean value indicating whether to request a review for the specified actions count by checking whether the specified count is in the collection of review worthy numbers.  If specified count is higher 1200 it returns `true` if count modulo 100 is zero.
    ///
    /// - parameter reviewWorthyActionsCount: The actions count
    /// - returns: Whether to request a review
    ///
    func shouldRequestReview(for actionsCount: Int) -> Bool {
        return actionsCount <= 1200
        ? reviewWorthyActionsNumbers.contains(actionsCount)
        : actionsCount % 100 == 0
    }
    
    /// Calls the appropriate function on `SKStoreReviewController` dependant on the iOS version.
    ///
    func requestReview() {
        if #available(iOS 14.0, *) {
            
#if canImport(UIKit)
            if let scene = UIApplication.shared.currentScene {
                SKStoreReviewController.requestReview(in: scene)
            }
#endif
            
        } else if #available(iOS 10.3, *) {
            
            SKStoreReviewController.requestReview()
            
        } else {
            // empty
        }
    }
    
    // MARK: - Public API -
    
    /// Resets the action count stored in the user defaults.
    ///
    public func resetReviewWorthyActionsCount() {
        UserDefaults.standard.set(nil, forKey: reviewWorthyActionsCountKey)
    }
    
    /// Resets the version when last promted for review stored in the user defaults.
    ///
    public func resetLastVersionPromptedForReview() {
        UserDefaults.standard.set(nil, forKey: lastVersionPromptedForReviewKey)
    }
    
    /// Returns the amount of review worthy actions. Loaded from user defaults.
    ///
    public var reviewWorthyActionsCount: Int {
        return UserDefaults.standard.integer(forKey: reviewWorthyActionsCountKey)
    }
    
    /// Returns the version where the user was last prompted. Loaded from user defaults.
    ///
    public var lastVersionPromptedForReview: String? {
        return UserDefaults.standard.string(forKey: lastVersionPromptedForReviewKey)
    }
    
    /// The delay to wait before requesting the review.
    ///
    public var delay: Double = 1.0
    
    /// The collection of numbers when to request a review.
    /// Default is:
    ///     10,
    ///     25,
    ///     50,
    ///     100,
    ///     200,
    ///     400,
    ///     600,
    ///     1200
    ///
    public var reviewWorthyActionsNumbers = [ 10, 25, 50, 100, 200, 400, 600, 1200 ]
    
    /// Increases the actions count and request a review if the collection of review worth numbers contains the new actions count.
    ///
    public func requestReviewIfAppropriate() {
        self.increaseReviewWorthyActionsCount()
        
        guard shouldRequestReview(for: reviewWorthyActionsCount) else { return }
        guard currentVersion != lastVersionPromptedForReview else { return }
        
        let oneSecondFromNow = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: oneSecondFromNow) {
            self.requestReview()
            UserDefaults.standard.set(self.currentVersion, forKey: self.lastVersionPromptedForReviewKey)
        }
    }
}

extension ASRManager {
    
    /// The default shared instance.
    ///
    public static var `default`: ASRManager = ASRManager()
}


#if canImport(UIKit)
extension UIApplication {
    var currentScene: UIWindowScene? {
        connectedScenes.first { $0.activationState == .foregroundActive } as? UIWindowScene
    }
}
#endif

#endif
