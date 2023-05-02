//
//  NetworkManager.swift
//  GardenItemsApp
//
//  Created by ARMBP on 4/29/23.
//

import UIKit


class NetworkManager {
    static let shared           = NetworkManager()
    private let mainURL         = "http://shans.d2.i-partner.ru/api/ppp/index/?limit=20"
    private let itemByIdURL     = "http://shans.d2.i-partner.ru/api/ppp/item/?id="
    private let searchURL       = "http://shans.d2.i-partner.ru/api/ppp/index/?search="
    let cache                   = NSCache<NSString, UIImage>()
    
    private init() {}

    //MARK: - Load Data
    func getItemsList(offset: Int, completed: @escaping (Result<[GardenItem], ErrorMessages>) -> Void) {
        let endpoint = mainURL + "&offset=" + String(offset)
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy  = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let gardenItemsResults            = try decoder.decode([GardenItem].self, from: data)
                completed(.success(gardenItemsResults))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    
    
    func getItemsByID(id: Int, completed: @escaping (Result<GardenItem, ErrorMessages>) -> Void) {
        let endpoint = itemByIdURL + String(id)
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy  = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let gardenItemsResults            = try decoder.decode(GardenItem.self, from: data)
                completed(.success(gardenItemsResults))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    
    
    func searchItems(request: String, completed: @escaping (Result<[GardenItem], ErrorMessages>) -> Void) {
        let endpoint = searchURL + request.encodeUrl
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidRequest))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy  = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let gardenItemsResults            = try decoder.decode([GardenItem].self, from: data)
                completed(.success(gardenItemsResults))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }
    

    //MARK: - DownloadImage
    func downloadImage(from urlString: String, completed: @escaping(UIImage?)-> Void){
        
        let cacheKey = NSString(string: "http://shans.d2.i-partner.ru"+urlString.encodeUrl)

        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: "http://shans.d2.i-partner.ru"+urlString.encodeUrl) else {
            completed(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                completed(nil)
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
    
    
    
}

