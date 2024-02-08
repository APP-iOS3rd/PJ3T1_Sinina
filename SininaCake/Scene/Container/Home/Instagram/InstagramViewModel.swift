//
//  InstagramViewModel.swift
//  SininaCake
//
//  Created by 이종원 on 1/15/24.
//

import Foundation

class InstagramViewModel: ObservableObject {
    static let shared = InstagramViewModel()
    init() { 
        self.fetchInstaData()
    }
    
    @Published var instaData = [InstaData]()
    
    func fetchInstaData() {
        let instagramAPIKey = Bundle.main.infoDictionary?["INSTAGRAM_API_KEY"] ?? ""
        
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
                    self.instaData = results.data
                }
            } catch let error {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
}
