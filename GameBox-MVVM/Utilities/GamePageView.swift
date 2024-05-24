//
//  GamePageView.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 24.05.2024.
//

// GamePageView.swift

import UIKit
import Lottie

class GamePageView: UIImageView {
    private let animationView = LottieAnimationView(name: "pacman")
    private let apiRequest = APIRequest() 
    private let game = [GamesUIModel]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAnimationView()
    }
    
    func configure() {
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAnimationView()
    }

    private func setupAnimationView() {
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.loopMode = .loop
        addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: 50),
            animationView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func startLoading() {
        animationView.isHidden = false
        animationView.play()
    }

    func stopLoading() {
        animationView.stop()
        animationView.isHidden = true
    }

    func setImage(from urlString: String) {
        startLoading()
        apiRequest.getGameImage(path: urlString) { data, error in
            DispatchQueue.main.async {
                self.stopLoading()
                guard let data = data else { return }
                self.image = UIImage(data: data)
            }
        }
    }
}


