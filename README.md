# AppStoreReviewManager

Request an App Store review on specified action count number. 

### Use

Using `AppStoreReviewManager` is as simple as:

```swift
// call to increase actions count and request review if
// review worthy numbers contain the actions count

ASRManager.default.requestReviewIfAppropriate()

```

And has the following functionality:

#### Reset values

```swift
// reset action count
ASRManager.default.resetReviewWorthyActionsCount()

// reset last version when prompted
ASRManager.default.resetLastVersionPromptedForReview()

```

#### Get values

```swift

// get the amount of actions
ASRManager.default.reviewWorthyActionsCount

// get the version when last promted for a review
ASRManager.default.lastVersionPromptedForReview

```

#### Review worthy actions

```swift

// get or set the collections of review wortht action numbers
ASRManager.default.reviewWorthyActionsNumbers = [ 11, 22, 33, 44 ]

// default implementation
print(ASRManager.default.reviewWorthyActionsNumbers)

// prints "[10, 25, 50, 100, 200, 400, 600, 1200]"

```

#### Delay

Often its nicer to have a delay for the request to appear. When user does a review worth action it's smoother if waiting for some delay. Default implementation is `1.0` second.

```swift

// get or set the delay before a request appears (in sec)
ASRManager.default.delay = 1.2

```

### Requierments

 - iOS 10.3
 - StoreKit
