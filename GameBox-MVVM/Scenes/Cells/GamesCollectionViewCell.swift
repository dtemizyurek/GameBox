//
//  GamesCollectionViewCell.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 24.05.2024.
//

import UIKit

class GamesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var gameReleasedDate: UILabel!
    @IBOutlet weak var gameRatingLabel: UILabel!
    
    private var imageURL: URL?

       override func awakeFromNib() {
           super.awakeFromNib()
       }
       
       func configure(games: GamesUIModel) {
           gameLabel.text = games.name
           gameRatingLabel.text = "\(games.rating ?? 5)"
           gameReleasedDate.text = "Released: \(games.released ?? "010101")"
           
           if let imageUrlString = games.backgroundImage, let url = URL(string: imageUrlString) {
               imageURL = url
               gameImage.image = UIImage(named: "placeholder") // Placeholder image
               loadImage(from: url)
           } else {
               gameImage.image = UIImage(named: "placeholder") // Placeholder image
           }
       }
       
       private func loadImage(from url: URL) {
           URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
               guard let self = self, let data = data, error == nil, let image = UIImage(data: data) else {
                   return
               }
               DispatchQueue.main.async {
                   if self.imageURL == url {
                       self.gameImage.image = image
                   }
               }
           }.resume()
       }
}
