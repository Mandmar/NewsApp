//
//  Article.swift
//  NewsApp
//
//  Created by user on 23.03.2019.
//  Copyright © 2019 Rise1496. All rights reserved.
//

import Foundation

class Article: Decodable {
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    var source: ArticleSource?
}

class ArticleArrayInfo: NSObject, Decodable {
    var articles: [Article] = [Article]()
}

class ArticleSource: NSObject, Decodable {
    var id: String?
    var name: String?
}
