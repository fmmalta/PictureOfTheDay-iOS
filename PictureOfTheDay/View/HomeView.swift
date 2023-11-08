import SwiftUI

struct HomeView: View {
	@StateObject private var viewModel: HomeScreenViewModel
	@State private var pictures: [PictureModel] = []
	
	init(pictureProtocol: PictureProtocol) {
		_viewModel = StateObject(wrappedValue: HomeScreenViewModel(pictureProtocol: pictureProtocol))
	}
	
	var body: some View {
		NavigationStack {
			if viewModel.isLoading {
				ProgressView()
			} else {
				List(pictures.reversed(), id: \.self) { picture in
					HStack(spacing: 20) {
						AsyncImage(url: URL(string: picture.url)) { phase in
							if let image = phase.image {
								image.resizable()
							} else if phase.error != nil {
								Image(systemName: "exclamationmark.triangle")
							} else {
								ProgressView()
							}
						}
						.frame(width: 50, height: 50)
						.clipShape(RoundedRectangle(cornerRadius: 10))
						
						NavigationLink {
							DetailView(picture: picture)
						} label: {
							VStack (alignment: .leading) {
								Text(picture.title)
									.font(.subheadline)
								Text(picture.explanation)
									.font(.caption2)
									.lineLimit(2)
							}
						}
					}
					
				}.navigationTitle("Pictures")
			}
		}
		.task {
			do {
				viewModel.isLoading = true
				pictures = try await viewModel.getPictureOfTheDay()
				viewModel.isLoading = false
			} catch {
				print(error)
			}
		}
	}
}

#Preview {
	HomeView(pictureProtocol: PictureDataService())
}
