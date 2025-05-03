//
//  AsyncImageView.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 01/05/2025.
//

import SwiftUI

struct AsyncImageView: View {
    let urlString: String?
    let networker: Networker
    @State private var image: UIImage?
    var action: (() -> Void)?

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
            } else {
                RoundedRectangle(cornerRadius: 10.0)
                    .foregroundStyle(.gray)
                    .frame(width: 100, height: 100)
            }
        }
        .onAppear {
            guard let urlString = urlString else {
                return
            }
            Task {
                do {
                    image = try await networker.fetchImage(for: urlString)
                } catch {
                    print("Error loading image: \(error)")
                }
            }
        }
        .onTapGesture(count: 2) {
            withAnimation(.interpolatingSpring(.bouncy(duration: 0.5))) {
                action?()
            }
        }
    }
}

#Preview {
    AsyncImageView(urlString: "https://i.imgur.com/LGk9Jn2.jpeg", networker: Networker())
}
