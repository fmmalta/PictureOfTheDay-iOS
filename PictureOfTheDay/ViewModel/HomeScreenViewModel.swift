import Foundation

class HomeScreenViewModel: ObservableObject {
	@Published var isLoading: Bool = false
	let pictureProtocol: PictureProtocol
	
	init(pictureProtocol: PictureProtocol) {
		self.pictureProtocol = pictureProtocol
	}
	
	func getPictureOfTheDay() async throws -> [PictureModel] {
		try await pictureProtocol.getImages()
	}
}
