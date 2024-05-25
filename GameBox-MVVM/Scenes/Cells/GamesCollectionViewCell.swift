//
//  GamesCollectionViewCell.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 24.05.2024.
//

import UIKit
import Lottie

class GamesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var gameReleasedDate: UILabel!
    @IBOutlet weak var gameRatingLabel: UILabel!
    
    private var imageURL: URL?
        private let activityIndicator = UIActivityIndicatorView(style: .medium)

        override func awakeFromNib() {
            super.awakeFromNib()
            setupActivityIndicator()
        }
        
        func configure(games: GamesUIModel) {
            gameLabel.text = games.name
            gameRatingLabel.text = games.rating != nil ? "\(games.rating!)" : "N/A"
            gameReleasedDate.text = games.released ?? "N/A"
            
            if let imageUrlString = games.backgroundImage, let url = URL(string: imageUrlString) {
                imageURL = url
                gameImage.image = UIImage(named: "placeholder")
                startLoading()
                loadImage(from: url)
            } else {
                gameImage.image = UIImage(named: "placeholder")
                stopLoading()
            }
        }
        
        private func setupActivityIndicator() {
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(activityIndicator)
            
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: gameImage.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: gameImage.centerYAnchor)
            ])
            activityIndicator.hidesWhenStopped = true
        }
        
        private func startLoading() {
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
        }
        
        private func stopLoading() {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
        
        private func loadImage(from url: URL) {
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self, let data = data, error == nil, let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        self?.stopLoading()
                    }
                    return
                }
                DispatchQueue.main.async {
                    if self.imageURL == url {
                        self.gameImage.image = image
                        self.stopLoading()
                    }
                }
            }.resume()
        }
    }
