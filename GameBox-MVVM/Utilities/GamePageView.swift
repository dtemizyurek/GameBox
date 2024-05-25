//
//  GamePageView.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 25.05.2024.
//

import Foundation
import UIKit
 //Custom UIImageView subclass to load and display game images
class GamePageView: UIImageView {
    func setImage(from urlString: String?) {
        guard let urlString = urlString else { return }
        let apiRequest = APIRequest()
        apiRequest.getGameImage(path: urlString) { [weak self] data, error in
            guard let self = self, let data = data, error == nil else {
                // Handle error appropriately, e.g., show a default image or an error message
                print("Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
    }
}
