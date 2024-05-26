//
//  GamesCollectionViewCell.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 24.05.2024.
//

import UIKit
import Lottie

final class GamesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var gameReleasedDate: UILabel!
    @IBOutlet weak var gameRatingLabel: UILabel!
    @IBOutlet weak var backGroundView: UIView!
    @IBOutlet weak var ratingView: UILabel!
    
    private var imageURL: URL?
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupActivityIndicator()
        setupRatingView()
        setupBackgroundView()
        setupImageView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        makeRatingViewCircular()
    }
    
    func configureDetail(games: GameDetail) {
        gameLabel.text = games.name
        gameRatingLabel.text = "\(games.rating)"
        gameReleasedDate.text = games.released
        setRatingColor(rating: games.rating)
        ratingView.alpha = 1.0
        
        let imageUrlString = games.backgroundImage
        if let url = URL(string: imageUrlString) {
            imageURL = url
            gameImage.image = UIImage(named: "placeholder")
            startLoading()
            loadImage(from: url)
        } else {
            gameImage.image = UIImage(named: "placeholder")
            stopLoading()
        }
    }
    
    func configureHome(games: GamesUIModel) {
        gameLabel.text = games.name
        gameRatingLabel.text = "\(games.rating ?? 0)"
        gameReleasedDate.text = games.released
        setRatingColor(rating: games.rating ?? 0)
        ratingView.alpha = 1.0
        
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
    
    private func setupBackgroundView() {
        backGroundView.layer.cornerRadius = 10
        backGroundView.layer.masksToBounds = true
    }
    
    private func setupImageView() {
        gameImage.layer.cornerRadius = 10
        gameImage.layer.masksToBounds = true
    }
    
    private func setupRatingView() {
        ratingView.layer.borderWidth = 0.0
        ratingView.layer.masksToBounds = true
    }
    
    private func makeRatingViewCircular() {
        ratingView.layer.cornerRadius = ratingView.frame.size.width / 2
        ratingView.layer.masksToBounds = true
    }
    
    private func setRatingColor(rating: Double) {
        var color: UIColor
        
        switch rating {
        case 4...:
            color = .systemGreen
        case 3..<4:
            color = .systemYellow
        case 2..<3:
            color = .systemOrange
        case 1..<2:
            color = .systemRed
        default:
            color = .systemGray
        }
        
        animateBorderColor(to: color.cgColor)
        ratingView.backgroundColor = color.withAlphaComponent(0.6)
    }
    
    private func animateBorderColor(to color: CGColor) {
        let borderAnimation = CABasicAnimation(keyPath: "borderColor")
        borderAnimation.fromValue = UIColor.clear.cgColor
        borderAnimation.toValue = color
        borderAnimation.duration = 4.0 // Animasyon süresi 4 saniye
        
        let borderWidthAnimation = CABasicAnimation(keyPath: "borderWidth")
        borderWidthAnimation.fromValue = 0.0
        borderWidthAnimation.toValue = 2.0
        borderWidthAnimation.duration = 4.0 // Animasyon süresi 4 saniye
        
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [borderAnimation, borderWidthAnimation]
        animationGroup.duration = 4.0 // Animasyon süresi 4 saniye
        
        ratingView.layer.add(animationGroup, forKey: "borderColorAndWidth")
        ratingView.layer.borderColor = color
        ratingView.layer.borderWidth = 2.0
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
