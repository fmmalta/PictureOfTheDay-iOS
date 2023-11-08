import SwiftUI

@main
struct PictureOfTheDayApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView(pictureProtocol: PictureDataService())
        }
    }
}
