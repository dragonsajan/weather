//
//  ImageCache.swift
//  Weather
//
//  Created by Sajan Kushwaha on 2/5/26.
//

import SwiftUI

// FIXME: Need to work on this
struct AppImageView<Content: View, Placeholder: View>: View {

    let url: URL
    let content: (Image) -> Content
    let placeholder: () -> Placeholder

    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image {
                content(Image(uiImage: image))
            } else {
                placeholder()
                    .task {
                        await load()
                    }
            }
        }
    }

    @MainActor
    private func load() async {
        if let cached = ImageCache.shared.image(for: url) {
            image = cached
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let uiImage = UIImage(data: data) {
                ImageCache.shared.store(uiImage, for: url)
                image = uiImage
            }
        } catch { }
    }
}


final class ImageCache {
    static let shared = ImageCache()
    
    private init() {}

    func image(for url: URL) -> UIImage? {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        guard let cached = URLCache.shared.cachedResponse(for: request) else {
            return nil
        }
        return UIImage(data: cached.data)
    }

    func store(_ image: UIImage, for url: URL) {
        guard let data = image.pngData() else { return }

        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: "HTTP/1.1",
            headerFields: [
                "Content-Type": "image/png",
                "Cache-Control": "max-age=86400"
            ]
        )

        guard let response else { return }

        let cachedResponse = CachedURLResponse(
            response: response,
            data: data,
            storagePolicy: .allowed
        )

        URLCache.shared.storeCachedResponse(
            cachedResponse,
            for: URLRequest(url: url)
        )
    }
}
