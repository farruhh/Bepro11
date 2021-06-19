//
//  PlayerDelegate.swift
//  Bepro_iOS_Task
//
//  Created by frank on 2021/05/26.
//

import Foundation

/// play state
///
/// - none: none
/// - playing: playing
/// - paused: pause
/// - playFinished: finished
/// - error: play failed
public enum PlayerState: Int {
    case none            // default
    case playing
    case paused
    case playFinished
    case error
}
/// buffer state
///
/// - none: none
/// - readyToPlay: ready To Play
/// - buffering: buffered
/// - stop : buffer error stop
/// - bufferFinished: finished
public enum PlayerBufferState: Int {
    case none           // default
    case readyToPlay
    case buffering
    case stop
    case bufferFinished
}
/// play video content mode
///
/// - resize: Stretch to fill layer bounds.
/// - resizeAspect: Preserve aspect ratio; fit within layer bounds.
/// - resizeAspectFill: Preserve aspect ratio; fill layer bounds.
public enum VideoGravityMode: Int {
    case resize
    case resizeAspect      // default
    case resizeAspectFill
}
/// play background mode
///
/// - suspend: suspend
/// - autoPlayAndPaused: auto play and Paused
/// - proceed: continue
public enum PlayerBackgroundMode: Int {
    case suspend
    case autoPlayAndPaused
    case proceed
}
public protocol PlayerDelegate: class {
    // play state
    func player(_ player: Player, stateDidChange state: PlayerState)
    // playe Duration
    func player(_ player: Player, playerDurationDidChange currentDuration: TimeInterval, totalDuration: TimeInterval)
    // buffer state
    func player(_ player: Player, bufferStateDidChange state: PlayerBufferState)
    // buffered Duration
    func player(_ player: Player, bufferedDidChange bufferedDuration: TimeInterval, totalDuration: TimeInterval)
    // player error
    func player(_ player: Player, playerFailed error: PlayerError)
}

// MARK: - delegate methods optional
public extension PlayerDelegate {
    func player(_ player: Player, stateDidChange state: PlayerState) {}
    func player(_ player: Player, playerDurationDidChange currentDuration: TimeInterval, totalDuration: TimeInterval) {}
    func player(_ player: Player, bufferStateDidChange state: PlayerBufferState) {}
    func player(_ player: Player, bufferedDidChange bufferedDuration: TimeInterval, totalDuration: TimeInterval) {}
    func player(_ player: Player, playerFailed error: PlayerError) {}
}
