//
//  InstagramAPI.swift
//  SininaCake
//
//  Created by  zoa0945 on 1/15/24.
//

import Foundation
import FirebaseFirestore

// MARK: - Insta
struct Instagram: Codable {
    let data: [InstaData]
    let paging: Paging
}

// MARK: - Data
struct InstaData: Codable, Identifiable {
    let id: String
    let caption: String?
    let mediaType: MediaType
    let mediaURL: String

    enum CodingKeys: String, CodingKey {
        case id, caption
        case mediaType = "media_type"
        case mediaURL = "media_url"
    }
}

enum MediaType: String, Codable {
    case carouselAlbum = "CAROUSEL_ALBUM"
    case image = "IMAGE"
}

// MARK: - Paging
struct Paging: Codable {
    let cursors: Cursors
    let next: String
}

// MARK: - Cursors
struct Cursors: Codable {
    let before, after: String
}

class InstagramAPI: ObservableObject {
    private var instagramAPIKey: String = ""
    
    init() {
        Task {
            await getInstagramAPIKey()
            self.fetchInstaData()
        }
    }
    
    @Published var instaData = [InstaData]()
    @Published var instaImageURLs: [String] = [String]()
    
    func fetchInstaData() {
        let urlString = "https://graph.instagram.com/me/media?fields=id,caption,media_type,media_url&access_token=\(instagramAPIKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error :" + error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Instagram.self, from: data)
                DispatchQueue.main.async {
                    if self.instaImageURLs.isEmpty {
                        results.data.forEach { image in
                            self.instaImageURLs.append(image.mediaURL)
                        }
                    }
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
    
    func getInstagramAPIKey() async {
        let db = Firestore.firestore()
        var isNewUser = false
        
        do {
            let instaAPI = try await db.collection("Keys").document("InstaKey").getDocument()
            let apiKey = instaAPI.get("key") as! String
            instagramAPIKey = apiKey
            print("Success to getting InstaAPIKey: \(apiKey)")
        } catch {
            print("Error writing document: \(error)")
        }
    }
}
