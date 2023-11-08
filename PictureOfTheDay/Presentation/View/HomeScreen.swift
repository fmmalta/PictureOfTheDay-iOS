import SwiftUI

struct HomeScreen: View {
	@StateObject private var viewModel: HomeScreenViewModel
	
	init(pictureProtocol: PictureProtocol) {
		_viewModel = StateObject(wrappedValue: HomeScreenViewModel(pictureProtocol: pictureProtocol))
	}
	
	var body: some View {
		NavigationStack {
			List(viewModel.pictures.reversed(), id: \.self) { picture in
				HStack(spacing: 20 ) {
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
		.task {
			do {
				try await viewModel.getPictureOfTheDay()
			} catch {
				print(error)
			}
		}
	}
}

#Preview {
	HomeScreen(pictureProtocol: PictureDataService())
}
