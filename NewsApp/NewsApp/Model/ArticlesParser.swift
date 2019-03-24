//
//  ArticlesParser.swift
//  NewsApp
//
//  Created by user on 23.03.2019.
//  Copyright © 2019 Rise1496. All rights reserved.
//

import Foundation

protocol ArticlesParserDelegate {
    func reloadArticles(articles: [Article]?)
    func showAlert()
}

class ArticlesParser: NSObject {
    var delegate: ArticlesParserDelegate?
    
    func startArticlesRequest(url: URL) {
        var articles: [Article]?
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else {
                return
            }
            do {
                let articlesArrayInfo = try JSONDecoder().decode(ArticleArrayInfo.self, from: data)
                articles = articlesArrayInfo.articles
                self.delegate?.reloadArticles(articles: articles)
            } catch {
                print("No articles")
                self.delegate?.showAlert()
            }
            }.resume()
        
    }
}
