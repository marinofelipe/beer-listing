[![Build Status](https://travis-ci.org/marinofelipe/beer-listing.svg?branch=master)](https://travis-ci.org/marinofelipe/beer-listing)
<a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-5.3-orange.svg?style=flat" alt="Swift" /></a>

# Beer List

This is a pet project where I wanted to achieve a modular, scalable, and testable code, while playing with latest iOS APIs (SwiftUI and Combine).

Did you ever wanted to find new beers to drink? That’s your golden opportunity. Beer App has you covered with tons of different options for you to discover.

## Features
- Discovery screen with an endless scroll
- Detail screen with detailed info about beers

## App Architecture
The aps is modular. It is composed of many modules that compile to form a working app.
Modules reduce coupling, improve (re)compile times and allow for targeted compilation.

### Main overview
The macro architecture is split into:

#### 1. App  - `Beer App`
Final binary - where the other modules get embbed to.

#### 2. Feature modules - `Discovery Feature`
Self-contained functionalities.

One app is composed by many features that are decoupled, so pieces can be glued together, reused, and worked on in isolation.

#### 3. Support modules - `CommonUI, Common, and TestSupport`
They are base modules that depend on Apple frameworks and libraries (e.g. Foundation, UIKit, Core Data, etc).
Both feature modules and app can depend on. They doesn't contain any flow logic, but only reusable code for different domain.

### In detail

This architecture intends to keep a good separation from presentation, domain, and data layers, with single responsibility principle in mind. 
The same concept can be found on widely known patterns such as VIPER.

The flow is done with MVVM-C, and the repository pattern is used to take care of model / domain layer, encapsulating and dealing with data access via injected networking and/or cache services.

#### 1. Presentation layer 

##### Coordinators
Bridged from the UIKit world, coordinators are responsible for managing flows, and in some codebases also to set up the scene by injecting all its dependencies.
For SwiftUI, where push/pop navigation is built on top of NavigationLink, Coordinators feel close to an anti-pattern. 
I am still researching and exploring other forms to replace it, and I think in the iOS community a few developers have done something using Environment, or in a fully-functional architecture as [The Composable Architecure](https://github.com/pointfreeco/swift-composable-architecture), just by deriving the store and actions.

In the UIKit world Coordinators are tight to the UIKit lifecycle, and generally referenced from the view model, but on SwiftUI, since the navigation code is sync, or in other words, the navigation links expect some view to be passed to it synchorously, the Coordinator must return the view (with its dependencies set up), which would require the view model to know about SwiftUI.

This should be always avoided, no matter if for UIKit or SwiftUI, view models shouldn't know about view logic.

Therefore, a bridge object was introduced, view store, that connects the view with the view model, and communicates with the Coordinator. Not ideal, off course, it introduces more complexity, and its not actually a view store, but in other hand it makes it easier to test a view, since the view model can have an interface and easily get stimulated to emit view state changes, and since through it the UI logic is not leaked into the view model.
Another alternative would be to also add a coordinator as a dependency of the view, but this in my opinion would mess the data flow.

##### View model
The view model contains all business logic, it has a single output: a view state.

###### View State
Inspired by state in Redux architectures, ViewState is an Equatable value type, that makes it easier to diff and reason about the states of the UI. It guarantees that the view has a valid state, and since SwiftUI only redraws what changed, there's no performance issues on having a single Published view state property.

###### Actions
The view model has a single enntry point / input, a function that receives an action.
Actions are simple value type enums, that clearly define events that can happen in an app.
They can be composed from items to screen actions, and are the starting point for state changes.

#### 2. Domain layer
The repository pattern is used to provide access to domains. They hide data access layer underneath, by receiving instances of services to consume networking or cached data.

Besides encapsulating data access logic, the repositories also deal with pagination, and returns a page with results and a next page token, so features can be unware and work independent of API related pagination logic.

For the sake of an example the repository was created as a separate package that supports both iOS and mac, which allows it to be reused to fetch a list of beers in mac, as a separate app that links to it.

Ideally a modular app may also have shared repositories that provide access to common domain for different features. E.g. One that provides in-memory observable list of favorite beers, so both a favorites screen and discovery can react and update accordingly to the latest favorited state.

#### Environments
Used to define and inject dependencies. They make it easier to understand and manage all dependencies needed in a module, without leaking details to other modules, and providing only what should be `publicly exposed` to the outside world.

For example, `DiscoveryEnvironment `hides from other modules the dependencies used in the Discovery module, as DiscoveryRepository, and return a Coordinator so the flow can be started, without leaking both the interface and concrete type of the Coordinator, as well as the type of the starting view it has. The only `public` thing and starting point is the environment itself. It also allows the injection of shared dependencies that can get resolved in the main target, e.g. a shared HTTPClient or HTTPRequestBuilder.

### In a UIKit world

In UIKit, the key difference is that the coordinator wouldn't have to return a View, and would be directly injected into the view model. Refereces would be kept from UIKit 
(UINavigationController -> UIViewController -> ViewModel - Coordinator), and all the scene stack cleaned up when the view controller gets deinitialized.

The other difference is that, by programmatically creating views (UIView and UIViewController), the view model could be injected into view controllers, via an interface, making it very easy to test/stimulate the UI, and without the need of an object acting as a bridge between view, view model, and coordinator, as done here using SwiftUI.

## Dependencies
- `CombineHTTPClient`
Wraps `URLSession` and  `URLSession.dataTaskPublisher`. Provides a simple API to build requests and perform HTTP calls. It's well tested, and comes with a separate product, `HTTPClientTestSupport`, that can help with stubbing the HTTPClient.

- `KingfisherSwiftUI`
Life is too short to reinvent the wheel, so it is used for download and cache of images.
A wrapper is not needed since it is basically a custom SwiftUI view, although I don't like that by passing a URL to it on tests it would perform a real network request, so I would explore ways of avoiding this or choosing a different library.

- `swift-log`
Apple Swift 5 API for logging. Thread-safe and with a simple API. In a real-word application the `protocol LogHandler` can be used to set up a custom logging backend implementation, for e.g. send logged event with `.error` level to Crashlytics as non-fatal or any other monitoring tool.

## General comments

### Loading view
A resuable loading view was created to be plugged into main views, and it was chosen instead of the new/cool `redactedReasons iOS 14 API`, to avoid the `#available(iOS 14, *) checks` dance.

### Swift Packages vs Projects
I generally like to work with a Workspace split into separate projects.
It allows creating the modules composed by `CocoaTouch framework` (the module code), `standalone app`, and `test` targets. 
For this case I wanted to build the app using SPM, since it is now a bit more mature, and e.g supports resources and localization. 

Downside is that standalone apps can't be built on Swift Packages, which is pretty good for modular apps.  I believe though that in the future iOS targets would be definable within a package.

Of course that, standalone apps, and highly modular features are not always needed. It varies from case by case. But event then, a modular codebase will always bring benefits such as better separation of concerns, improved build times, decoupled, reusable and scalable code.

### Snapshot tests
With proper time snapshot tests could be increased to cover different conditions, e.g. dark mode, compressed size, with large and short text, inside a smaller parent, etc.

Generally for UIKit it's a good approach to snapshot test view controllers for predefined devices, e.g. small and large sizes, so potentially in the future, depending on what the SnapshotTesting framework provides, main/container SwiftUI views could be embedded into UIHostingControllers to get tested for different device sizes.

### Why Redux would be a great alternative
- SwiftUI and Combine have a functional nature
- Consistent state - since state is composed and observed across all app, it's less likely that screens will be out of sync
- Easy to reproduce a state history, and that is something that can be very interesting when problem arises
- Pure functions for business logic - Highly testable, clear input and output, no state, no side effects
- Usually heavily built on top of value types, which has some benefits such as: less likely to produce memory leaks, more efficiency, increased thread safety, etc.

## Known issues
- The detail view UI blinks when contente is scrolled and the nav bar changes its title from inline to large. This seems to be an issue with SwiftUI when using scroll views. 
Even then, I preferred to keep the large title, since it has a nice parallax effect when the detail view gets pushed into the stack.

- When using `SwiftUI List until iOS 13`, the separator could be removed by changing the global appearance of UITableView, since a table view was used underneath by SwiftUI. But from iOS 14 / Xcode 12 beta, this behavior changed. 
Therefore, to make things easier, instead of going to a card layout, I decided to stick with seprators and  simpler UI.

- `EmptyStateViewSnapshotTests.testWithOfflineState` was failling in the CI, therefore it is `temporarily disabled` in the `main scheme`. It looks like as one of those awkward issues with OS version, different color outputs and snapshot tests. It can be solved with further investigation though.

## What comes next?
- Integrate CI with slather and coveralls to provide coverage report on pull requests.
- Dedicate more time to polish the UI and create some nice animations and transitions
- Design system module, with definition a Colors asset, common styles, margins, and helpers to apply style to text views - e.g. UILabel in UIKit, or Text in SwiftUI
- Snapshot tests for discovery view, beer cell and detail view - would be simple to do by injecting a fake view model into the view store and stimulating it by publishing different view states
- UITests with KIF
- Beer app target could have a tab bar / main container view, where different feature would be plugged into. E.g. A favorites tab
- Create a favorites feature. To do that the model state would have to be observable, which could be achieved with in-memory array of favorited beers, observed from different modules as a shared repository. Since the model would be of value type, it should be fine in terms of thread safety, unless different queues start to read and write to the array, which could be easily adressed by introducing synchrozination mechanisms such as Locks, or queues.

## References
Kudos to the [PUNK API](https://punkapi.com/documentation/v2) team on their free to use API :).