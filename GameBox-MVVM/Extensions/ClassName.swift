//
//  ClassName.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 21.05.2024.
//

import Foundation
import UIKit

extension UICollectionViewCell {
    
    static var identifier: String {
        print(String(describing: self))
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
}
