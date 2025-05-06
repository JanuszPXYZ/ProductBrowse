# ProductBrowse - iOS Challenge for MarktGuru
<img width="180" alt=„ProductsScreen” src="https://github.com/user-attachments/assets/46bca42e-e3aa-4f4e-a741-20571ea531bb"/>
<img width="180" alt=„DetailView” src="https://github.com/user-attachments/assets/cf51b9d4-5aa0-4476-810f-82fc885293f9"/>
<img width="180" alt=„FavoritesScreen” src="https://github.com/user-attachments/assets/b7589129-6f21-4b4e-9d1b-c5191c33c6d5"/>
<img width="180" alt=„FavoritesScreen” src="https://github.com/user-attachments/assets/e485dae7-fcae-4fcb-b312-7f8274881e7c"/>
<img width="180" alt=„FavoritesScreen” src="https://github.com/user-attachments/assets/debadcee-5e91-47a0-b502-e38437272db0"/>

Usually before I start coding anything, I try to sit down and think what I'll need to correctly solve the problem at hand. This exercise was no different. After reading the problem statement a couple of times and going over it in my head, I decided to go with the hybrid approach, i.e., mixing SwiftUI and UIKit together. Although SwiftUI is the future of building apps for Apple platforms, I still think that there are certain pain points of the framework that have not yet been addressed, and having the "fallback" option of using the battle-tested UIKit ensures that the app remains robust. Also it goes without saying that UIKit still holds the upper hand over SwiftUI in terms of the "granularity of the modifications". `UIView`s, `UITableView`s and other UIKit elements allow for greater customization. Having said all of that, SwiftUI is a phenomenal framework that brings the speed of the development to a new level. Creating pleasant looking views is a breeze, and is extremely fast. 

So, the frameworks used to solve this challenge have been established, but what else? The **architecture that I picked is MVVM**. It can be used in both of the aforementioned frameworks, and allows for easy testing later on. Next, I wanted to "play around" with the structured concurrency introduced in Swift 5.5, so the code utilizes `async`/`await`, instead of relying on the "old-way" of GCD with escaping closures. Finally, I thought: why not create two versions of the same app? Initially, I wanted the project to contain two targets: One written in the hybrid approach mentioned in the beginning, and the other written in "pure" SwiftUI. The code that could be shared by the two could be easily put in a framework that both targets would then use. That way I could just see the performance of both and come up with some interesting findings. Ultimately, I abandonded that idea for something different: simply using compiler flags to switch between implementations. The exercise stated the following *Display a list of products (e.g., name, price, description) in a scrollable view (`UITableView` or `UICollectionView`)*. I took some liberty and implemented a SwiftUI `List` (with a custom cell) that is then embedded in a `UIHostingController` of the encompassing `UITabBarController`, as well as a normal `UITableView`. The only thing that has to be done to see the UIKit implementation is adding the `UIKIT` (all caps) flag in the `Build Settings` under the `Swift Compiler - Custom Flags` section. 

As for the usage of AI in the project, the two times I used it was when I was brainstorming the pagination element of the app - as that's something that I was exposed to only briefly at Allegro and never had the chance to see how it works. And then, when I needed a quick template for integrating a XIB into the custom `UITableViewCell` that I created for the table view. The usual operations, such as saving to a file, loading from file, etc., I copied from my latest app Flightista and adapted to the exercise. So, to recap everything:

* Hybrid SwiftUI/UIKit approach
* `async`/`await`
* MVVM design pattern
* Absolutely no storyboards (apart from the table view cell XIB that I could design easily in code, but wanted to play around a bit) - they are a hassle to work with in a collaborative setting and merge conflicts are a usual occurrence with them.
* Programmatic constraints (where needed)
* Figma for logo creation
* XCTests used for testing

Time spent on the task: around 7.5 hours in total.

## Findings
One very interesting thing I found out when experimenting with SwiftUI's `List` and a regular `UITableView` is the performance aspect of the two, especially when implementing the infinite scroll feature. Maybe it had to do with my implementation, but in general the performance of `List` when scrolling fast wasn't as good as `UITableView`. One of the decisions to implement the "Load More" button on the SwiftUI side had to do with that aspect. 

## Feature Prioritization - Dark Mode implementation
One of the aspects of the app that I was on the fence about was implementing an in-app switch for dark mode support. Apple's Human Interface Guideline recommends supporting dark mode at the system level to ensure that the experience is consistent across all the iOS apps. Not to mention that a feature like that might be confusing for the users. Let's say that a given user has automatic mode selected, which adjusts the screen colors according to the time of day, and that the app was set for dark mode internally. The user might forget that they set it and start questioning why the app is dark, when the whole layout is bright. In general, I've always went with system level support for dark mode, as it's consistent with Apple's guidelines and ensures that the colors stay the same throughout.
