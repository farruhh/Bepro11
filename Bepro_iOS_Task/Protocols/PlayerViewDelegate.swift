//
//  PlayerViewDelegate.swift
//  Bepro_iOS_Task
//
//  Created by frank on 2021/05/25.
//

import Foundation

public protocol PlayerViewDelegate: class {
    /// Fullscreen
    ///
    /// - Parameters:
    ///   - playerView: PlayerView
    ///   - fullscreen: Bool
    func playerView(_ playerView: PlayerView, willFullscreen isFullscreen: Bool)
   
    /// Close play view
    ///
    /// - Parameter playerView: PlayerView
    func playerView(didTappedClose playerView: PlayerView)
    
    /// Displaye control
    ///
    /// - Parameter playerView: PlayerView
    func playerView(didDisplayControl playerView: PlayerView)
}

// MARK: - delegate methods optional
public extension PlayerViewDelegate {
    func playerView(_ playerView: PlayerView, willFullscreen fullscreen: Bool){}
    func playerView(didTappedClose playerView: PlayerView) {}
    func playerView(didDisplayControl playerView: PlayerView) {}
}
