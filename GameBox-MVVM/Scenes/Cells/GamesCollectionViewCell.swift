//
//  GamesCollectionViewCell.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 23.05.2024.
//

import UIKit

class GamesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var gameImage: UIImageView!
    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var gameReleasedDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configure(games: GamesUIModel) {
        gameLabel.text = games.name
        gameReleasedDate.text = games.released
    }

}
