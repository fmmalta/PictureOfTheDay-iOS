import Foundation

protocol PictureProtocol {
	func getImages() async throws -> [PictureModel]
}

enum PictureError: Error {
	case invalidURL
	case invalidResponse
	case invalidData
}

class PictureDataService: PictureProtocol {
	private let dateFormatter = DateFormatter()
	private let lastThreeWeeks = Calendar.current.date(byAdding: .day, value: -21, to: Date())!
	
	func getImages() async throws -> [PictureModel] {
		dateFormatter.dateFormat = "yyyy-MM-dd"
		let lastThreeWeeksString = dateFormatter.string(from: lastThreeWeeks)
		let todayString = dateFormatter.string(from: Date.now)
		
		let endpoint = "https://api.nasa.gov/planetary/apod?api_key="
		
		let rangeDate = "start_date=\(lastThreeWeeksString)&end_date=\(todayString)"
		
		let apiKey = "oVyQqfbj4mi1ljYRGktH4ggADkidGgD8mysuf4xU"
		
		guard let url = URL(string: "\(endpoint)\(apiKey)&\(rangeDate)") else {
			throw PictureError.invalidURL
		}
		
		let (data, response) = try await URLSession.shared.data(from: url)
		
		guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
			throw PictureError.invalidResponse
		}
		do {
			let decoder = JSONDecoder()
			return try decoder.decode([PictureModel].self, from: data)
		} catch {
			throw PictureError.invalidData
		}
	}
}
