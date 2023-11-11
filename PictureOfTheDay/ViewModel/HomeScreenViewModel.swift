import Foundation

class HomeScreenViewModel: ObservableObject {
	@Published var isLoading: Bool = false
	@Published var pictures: [PictureModel] = []
	let pictureProtocol: PictureProtocol
	
	init(pictureProtocol: PictureProtocol) {
		self.pictureProtocol = pictureProtocol
	}
	
	func getPictureOfTheDay() async throws -> [PictureModel] {
		isLoading = true
		pictures = try await pictureProtocol.getImages()
		isLoading = false
		return pictures
	}
}
