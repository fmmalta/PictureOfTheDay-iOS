import Foundation

protocol PictureProtocol {
	func getImages() async throws -> [PictureModel]
}

class PictureDataService: PictureProtocol {
	private let dateFormatter = DateFormatter()
	private let lastThreeWeeks = Calendar.current.date(byAdding: .day, value: -21, to: Date())!
	
	func getImages() async throws -> [PictureModel] {
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let lastThreeWeeksString = dateFormatter.string(from: lastThreeWeeks)
		let todayString = dateFormatter.string(from: Date.now)
		
		let rangeDate = "start_date=\(lastThreeWeeksString)&end_date=\(todayString)"
		
		let apiKey = "oVyQqfbj4mi1ljYRGktH4ggADkidGgD8mysuf4xU"
		
		let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)&\(rangeDate)")
		
		let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url!))
		
		let fecthedData = try JSONDecoder().decode([PictureModel].self, from: data)
		
		return fecthedData
	}
}

class HomeScreenViewModel: ObservableObject {
	@Published var pictures: [PictureModel] = []
	@Published var isLoading: Bool = false
	let pictureProtocol: PictureProtocol
	
	init(pictureProtocol: PictureProtocol) {
		self.pictureProtocol = pictureProtocol
	}
	
	func getPictureOfTheDay() async throws -> [PictureModel] {
		pictures = try await pictureProtocol.getImages()
		return pictures
	}
}
