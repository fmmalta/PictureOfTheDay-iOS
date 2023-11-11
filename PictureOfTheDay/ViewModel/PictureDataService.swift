import Foundation

protocol PictureProtocol {
	func getImages() async throws -> [PictureModel]
}

enum PictureError: Error {
	case invalidURL
	case invalidResponse
	case invalidData
}

func subtractDate(days: Int) -> Date {
	let calendar = Calendar.current
	let date = calendar.date(byAdding: .day, value: -days, to: Date())
	return date!
}

func dateToString(from: Date) -> String {
	let dateFormatter = DateFormatter()
	dateFormatter.dateFormat = "yyyy-MM-dd"
	let dateString = dateFormatter.string(from: from)
	return dateString
}

class PictureDataService: PictureProtocol {
	func getImages() async throws -> [PictureModel] {
		let lastThreeWeeksString = dateToString(from: subtractDate(days: 21))
		let todayString = dateToString(from: Date.now)
		
		let endpoint = "https://api.nasa.gov/planetary/apod?api_key="
		
		let rangeDate = "start_date=\(lastThreeWeeksString)&end_date=\(todayString)"
		
		let apiKey = "oVyQqfbj4mi1ljYRGktH4ggADkidGgD8mysuf4xU"
		
		let url = "\(endpoint)\(apiKey)&\(rangeDate)"
		
		return try await HttpService.get(url: url)
	}
}

class HttpService {
	static func get<T: Codable>(url: String) async throws -> T {
		do {
			let (data, _) = try await URLSession.shared.data(from: URL(string: url)!)
			let decoder = JSONDecoder()
			let decodedData = try decoder.decode(T.self, from: data)
			return decodedData
		} catch {
			print(error)
		}
		return T.self as! T
	}
}
