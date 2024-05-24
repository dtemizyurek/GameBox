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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(games: GamesUIModel) {
           gameLabel.text = games.name
           gameRatingLabel.text = "Rating: \(games.rating ?? 0.0)"
           gameReleasedDate.text = "Released: \(games.released ?? "N/A")"
        
       }

}
