//
//  EmptyView.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 26.05.2024.
//

import Foundation
import UIKit

extension UICollectionView {
    
    func setEmptyView(title: String, message: String){
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))

        let titleLabel = UILabel()
        let messageLabel = UILabel()
        let imageView = UIImageView(image: UIImage(imageLiteralResourceName: "notfound"))

        imageView.backgroundColor = .clear

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.textColor = UIColor.systemRed
        titleLabel.font = UIFont(name: "Chalkboard SE Bold", size: 22)
        messageLabel.textColor = UIColor.systemRed
        messageLabel.font = UIFont(name: "Chalkboard SE", size: 18)

        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)
        emptyView.addSubview(imageView)


        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true

        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true

        imageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: -20).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true

        titleLabel.text = title
        messageLabel.text = message

        titleLabel.textAlignment = .center
        messageLabel.textAlignment = .center

        titleLabel.numberOfLines = 0
        messageLabel.numberOfLines = 0

        self.backgroundView = emptyView
    }
    func restore() {
        self.backgroundView = nil
    }
}
