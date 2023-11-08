
import SwiftUI

struct DetailView: View {
	let picture: PictureModel
	
	init(picture: PictureModel) {
		self.picture = picture
	}
	var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				Text(picture.title)
					.font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
					.frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
				AsyncImage(url: URL(string: picture.url)) { image in
					image
						.resizable()
						.frame(width: 300, height: 300)
						.clipShape(RoundedRectangle(cornerRadius: 10))
				} placeholder: {
					ProgressView()
				}
				Text(picture.explanation)
					.frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
			}
			.padding()
		}
	}
}

#Preview {
	DetailView(picture: PictureModel(explanation: "Explanation", title: "Title", url: "https://apod.nasa.gov/apod/image/2311/Perseus_Euclid_960.jpg"))
}
