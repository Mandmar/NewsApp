//
//  ArticleImageDownloader.swift
//  NewsApp
//
//  Created by user on 23.03.2019.
//  Copyright © 2019 Rise1496. All rights reserved.
//

import Foundation

class ArticleImageDownloader {
    func downloadImage(url: URL, completion: @escaping ((Data) -> Void)) {
        let configuration: URLSessionConfiguration = .default
        let session = URLSession(configuration: configuration)
        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error occured in image dowload\(error)")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200:
                    if let data = data {
                        completion(data)
                    }
                default:
                    print("Not 200")
                }
            }
        }
        dataTask.resume()
    }
}
