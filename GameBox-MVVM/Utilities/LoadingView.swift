//
//  LoadingView.swift
//  GameBox-MVVM
//
//  Created by Doğukan Temizyürek on 23.05.2024.
//
import UIKit
import Lottie

class LoadingView {
    
    private var animationView: LottieAnimationView?
    static let shared = LoadingView()
    
    private var blurView: UIVisualEffectView
    
    private init() {
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.frame = UIScreen.main.bounds
        
        configure()
    }
    
    private func configure() {
        animationView = LottieAnimationView(name: "pacman") 
        if let animationView = animationView {
            animationView.translatesAutoresizingMaskIntoConstraints = false
            animationView.loopMode = .loop
            animationView.contentMode = .scaleAspectFit
            blurView.contentView.addSubview(animationView)
            
            NSLayoutConstraint.activate([
                animationView.centerXAnchor.constraint(equalTo: blurView.centerXAnchor),
                animationView.centerYAnchor.constraint(equalTo: blurView.centerYAnchor),
                animationView.widthAnchor.constraint(equalToConstant: 200),
                animationView.heightAnchor.constraint(equalToConstant: 200)
            ])
        }
    }
    
    func startLoading() {
        guard let window = UIApplication.shared.windows.first else {
            return
        }
        
        if blurView.superview == nil {
            window.addSubview(blurView)
            
            NSLayoutConstraint.activate([
                blurView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                blurView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
                blurView.topAnchor.constraint(equalTo: window.topAnchor),
                blurView.bottomAnchor.constraint(equalTo: window.bottomAnchor)
            ])
        }
        
        animationView?.play()
    }
    
    func hideLoading() {
        animationView?.stop()
        blurView.removeFromSuperview()
    }
}


