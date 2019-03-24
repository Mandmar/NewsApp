//
//  ArticlesViewController.swift
//  NewsApp
//
//  Created by user on 23.03.2019.
//  Copyright © 2019 Rise1496. All rights reserved.
//

import UIKit

class ArticlesViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var articlesTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Эта url доступна в течение одного дня, при тестировании ее необходимо сгенерировать снова
    let jsonURL = "https://newsapi.org/v2/everything?q=bitcoin&from=2019-02-23&sortBy=publishedAt&apiKey=86c683b7aea84afbaf92bfaa14da1b8b"
    var articles = [Article]()
    var articlesParser = ArticlesParser()
    var downloadedImages = [UIImage]()
    var selectedArticle: Article?
    var selectedArticleImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articlesTableView.delegate = self
        articlesTableView.dataSource = self
        articlesParser.delegate = self
        if Reachability.isConnectedToNetwork() {
            guard let url = URL(string: jsonURL) else {
                showAlert(string: "Wrong api URL")
                return
            }
            setActivityIndicator(isHidden: false)
            articlesParser.startArticlesRequest(url: url)
        } else {
            showAlert(string: "No internet connection")
            setActivityIndicator(isHidden: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "articleInfoSegue" {
            let controller = segue.destination as! ArticleInfoViewController
            controller.article = selectedArticle
            controller.articleImage = selectedArticleImage
        }
    }
    
    func setActivityIndicator(isHidden: Bool) {
        if isHidden {
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        } else {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
    }
}

extension ArticlesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articlecell") as! ArticleTableViewCell
        cell.titleLabel.text = articles[indexPath.row].title ?? ""
        cell.dateLabel.text = articles[indexPath.row].publishedAt?.changeDateStringToCorrectFormat() ?? ""
        cell.descriptionLabel.text = articles[indexPath.row].description ?? ""
        cell.articleImageView.image = downloadedImages[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedArticle = articles[indexPath.row]
        selectedArticleImage = downloadedImages[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "articleInfoSegue", sender: self)
    }
}

extension ArticlesViewController: ArticlesParserDelegate {
    func reloadArticles(articles: [Article]?) {
        if articles != nil {
            DispatchQueue.main.async {
                self.setActivityIndicator(isHidden: true)
                self.articles = articles!
                self.articlesTableView.reloadData()
                self.setCellImages()
            }
        } else {
            showAlert(string: "No articles")
        }
    }
    
    func showAlert() {
        showAlert(string: "No articles")
    }
    
    func setCellImages() {
        for _ in 0...articles.count-1 {
            downloadedImages.append(UIImage(named: "placeholder")!)
        }
        for index in 0...articles.count-1 {
            if let urlString = articles[index].urlToImage {
                let url = URL(string: urlString)
                if url != nil {
                    ArticleImageDownloader().downloadImage(url: url!) { (data) in
                        DispatchQueue.main.async {
                            self.downloadedImages[index] = UIImage(data: data)!
                            self.articlesTableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
                        }
                    }
                }
            }
        }
    }
    
}

extension String {
    func changeDateStringToCorrectFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        var newString = self.replacingOccurrences(of: "Z", with: "")
        newString += ".0+0"
        let date = dateFormatter.date(from: newString)
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        dateFormatter.doesRelativeDateFormatting = true
        if date != nil {
            let resultString = dateFormatter.string(from: date!)
            return resultString
        } else {
            return ""
        }
    }
}

extension UIViewController {
    func showAlert(string: String) {
        let alertController = UIAlertController(title: string, message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ок", style: .default) {
            (action) -> Void in
        }
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
