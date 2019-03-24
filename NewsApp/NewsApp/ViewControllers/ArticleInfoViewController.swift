//
//  ArticleInfoViewController.swift
//  NewsApp
//
//  Created by user on 23.03.2019.
//  Copyright © 2019 Rise1496. All rights reserved.
//

import UIKit

class ArticleInfoViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var articleTextView: UITextView!
    
    var article: Article!
    var articleImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    @IBAction func browserOpenAction(_ sender: Any) {
        guard let urlString = article.url else {
            return
        }
        guard let url = URL(string: urlString) else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func setUI() {
        titleLabel.text = article.title ?? ""
        articleImageView.image = articleImage
        articleTextView.text = article.description ?? ""
        dateLabel.text = article.publishedAt?.changeDateStringToCorrectFormat() ?? ""
    }
}
