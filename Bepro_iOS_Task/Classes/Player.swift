//
//  Player.swift
//  Bepro_iOS_Task
//
//  Created by frank on 2021/05/24.
//

import UIKit
import AVFoundation

open class Player: NSObject {
    open var displayView : PlayerView
    open var gravityMode : VideoGravityMode = .resizeAspect
    open var backgroundMode : PlayerBackgroundMode = .autoPlayAndPaused
    open var bufferInterval : TimeInterval = 2.0
    open weak var delegate : PlayerDelegate?
    open fileprivate(set) var playerAsset : AVURLAsset?
    open fileprivate(set) var contentURL : URL?
    open fileprivate(set) var error : PlayerError
    open fileprivate(set) var totalDuration : TimeInterval = 0.0
    open fileprivate(set) var currentDuration : TimeInterval = 0.0
    open fileprivate(set) var buffering : Bool = false
    open var state: PlayerState = .none {
        didSet {
            if state != oldValue {
                self.displayView.playStateDidChange(state)
                self.delegate?.player(self, stateDidChange: state)
            }
        }
    }
    open var bufferState : PlayerBufferState = .none {
        didSet {
            if bufferState != oldValue {
                self.displayView.bufferStateDidChange(bufferState)
                self.delegate?.player(self, bufferStateDidChange: bufferState)
            }
        }
    }
    open fileprivate(set) var player : AVPlayer? {
        willSet{
            removePlayerObservers()
        }
        didSet {
            addPlayerObservers()
        }
    }
    open fileprivate(set) var playerItem : AVPlayerItem? {
        willSet {
            removePlayerItemObservers()
            removePlayerNotifations()
        }
        didSet {
            addPlayerItemObservers()
            addPlayerNotifications()
        }
    }
    private var timeObserver: Any?
    fileprivate var seeking : Bool = false
    
    //MARK:- life cycle
    public init(URL: URL?, playerView: PlayerView?) {
        contentURL = URL
        error = PlayerError()
        if let view = playerView {
            displayView = view
        } else {
            displayView = PlayerView()
        }
        super.init()
        if contentURL != nil {
            configurationPlayer(contentURL!)
        }
    }
    public convenience init(URL: URL) {
        self.init(URL: URL, playerView: nil)
    }
    public convenience init(playerView: PlayerView) {
        self.init(URL: nil, playerView: playerView)
    }
    public override convenience init() {
        self.init(URL: nil, playerView: nil)
    }
    deinit {
        removePlayerNotifations()
        cleanPlayer()
        displayView.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
    }
    internal func configurationPlayer(_ URL: URL) {
        self.displayView.setplayer(player: self)
        self.playerAsset = AVURLAsset(url: URL, options: .none)
        let keys = ["tracks", "playable"]
        playerItem = AVPlayerItem(asset: playerAsset!, automaticallyLoadedAssetKeys: keys)
        player = AVPlayer(playerItem: playerItem)
        displayView.reloadPlayerView()
    }
    // time KVO
    internal func addPlayerObservers() {
        timeObserver = player?.addPeriodicTimeObserver(forInterval: .init(value: 1, timescale: 1), queue: DispatchQueue.main, using: { [weak self] time in
            guard let strongSelf = self else { return }
            if let currentTime = strongSelf.player?.currentTime().seconds, let totalDuration = strongSelf.player?.currentItem?.duration.seconds {
                strongSelf.currentDuration = currentTime
                strongSelf.delegate?.player(strongSelf, playerDurationDidChange: currentTime, totalDuration: totalDuration)
                strongSelf.displayView.playerDurationDidChange(currentTime, totalDuration: totalDuration)
            }
        })
    }
    internal func removePlayerObservers() {
        player?.removeTimeObserver(timeObserver!)
    }
}

//MARK: - public
extension Player {
    open func replaceVideo(_ URL: URL) {
        reloadPlayer()
        contentURL = URL
        configurationPlayer(URL)
    }
    open func reloadPlayer() {
        seeking = false
        totalDuration = 0.0
        currentDuration = 0.0
        error = PlayerError()
        state = .none
        buffering = false
        bufferState = .none
        cleanPlayer()
    }
    open func cleanPlayer() {
        player?.pause()
        player?.cancelPendingPrerolls()
        player?.replaceCurrentItem(with: nil)
        player = nil
        playerAsset?.cancelLoading()
        playerAsset = nil
        playerItem?.cancelPendingSeeks()
        playerItem = nil
    }
    open func play() {
        if contentURL == nil { return }
        player?.play()
        state = .playing
        displayView.play()
    }
    open func pause() {
        guard state == .paused else {
            player?.pause()
            state = .paused
            displayView.pause()
            return
        }
    }
    open func seekTime(_ time: TimeInterval) {
        seekTime(time, completion: nil)
    }
    open func seekTime(_ time: TimeInterval, completion: ((Bool) -> Swift.Void)?) {
        if time.isNaN || playerItem?.status != .readyToPlay {
            if completion != nil {
                completion!(false)
            }
            return
        }
        DispatchQueue.main.async { [weak self]  in
            guard let strongSelf = self else { return }
            strongSelf.seeking = true
            strongSelf.startPlayerBuffering()
            strongSelf.playerItem?.seek(to: CMTimeMakeWithSeconds(time, preferredTimescale: Int32(NSEC_PER_SEC)), completionHandler: { (finished) in
                DispatchQueue.main.async {
                    strongSelf.seeking = false
                    strongSelf.stopPlayerBuffering()
                    strongSelf.play()
                    if completion != nil {
                        completion!(finished)
                    }
                }
            })
        }
    }
}
//MARK: - private
extension Player {
    internal func startPlayerBuffering() {
        pause()
        bufferState = .buffering
        buffering = true
    }
    internal func stopPlayerBuffering() {
        bufferState = .stop
        buffering = false
    }
    internal func collectPlayerErrorLogEvent() {
        error.playerItemErrorLogEvent = playerItem?.errorLog()?.events
        error.error = playerItem?.error
        error.extendedLogData = playerItem?.errorLog()?.extendedLogData()
        error.extendedLogDataStringEncoding = playerItem?.errorLog()?.extendedLogDataStringEncoding
    }
}

//MARK: - Notifation Selector & KVO
private var playerItemContext = 0

extension Player {
    internal func addPlayerItemObservers() {
        let options = NSKeyValueObservingOptions([.new, .initial])
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: options, context: &playerItemContext)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges), options: options, context: &playerItemContext)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.playbackBufferEmpty), options: options, context: &playerItemContext)
    }
    internal func addPlayerNotifications() {
        NotificationCenter.default.addObserver(self, selector: .playerItemDidPlayToEndTime, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: .applicationWillEnterForeground, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: .applicationDidEnterBackground, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    internal func removePlayerItemObservers() {
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges))
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.playbackBufferEmpty))
    }
    internal func removePlayerNotifations() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    @objc internal func playerItemDidPlayToEnd(_ notification: Notification) {
        if state != .playFinished {
            state = .playFinished
        }
    }
    @objc internal func applicationWillEnterForeground(_ notification: Notification) {
        if let playerLayer = displayView.playerLayer  {
            playerLayer.player = player
        }
        switch self.backgroundMode {
        case .suspend:
            pause()
        case .autoPlayAndPaused:
            play()
        case .proceed:
            break
        }
    }
    @objc internal func applicationDidEnterBackground(_ notification: Notification) {
        if let playerLayer = displayView.playerLayer  {
            playerLayer.player = nil
        }
        switch self.backgroundMode {
        case .suspend:
            pause()
        case .autoPlayAndPaused:
            pause()
        case .proceed:
            play()
            break
        }
    }
}
extension Player {
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (context == &playerItemContext) {
            if keyPath == #keyPath(AVPlayerItem.status) {
                let status: AVPlayerItem.Status
                if let statusNumber = change?[.newKey] as? NSNumber {
                    status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
                } else {
                    status = .unknown
                }
                switch status {
                case .unknown:
                    startPlayerBuffering()
                case .readyToPlay:
                    bufferState = .readyToPlay
                case .failed:
                    state = .error
                    collectPlayerErrorLogEvent()
                    stopPlayerBuffering()
                    delegate?.player(self, playerFailed: error)
                    displayView.playFailed(error)
                @unknown default:
                    fatalError()
                }
            } else if keyPath == #keyPath(AVPlayerItem.playbackBufferEmpty){
                if let playbackBufferEmpty = change?[.newKey] as? Bool {
                    if playbackBufferEmpty {
                        startPlayerBuffering()
                    }
                }
            } else if keyPath == #keyPath(AVPlayerItem.loadedTimeRanges) {
                let loadedTimeRanges = player?.currentItem?.loadedTimeRanges
                if let bufferTimeRange = loadedTimeRanges?.first?.timeRangeValue {
                    let star = bufferTimeRange.start.seconds         // The start time of the time range.
                    let duration = bufferTimeRange.duration.seconds  // The duration of the time range.
                    let bufferTime = star + duration
                    if let itemDuration = playerItem?.duration.seconds {
                        delegate?.player(self, bufferedDidChange: bufferTime, totalDuration: itemDuration)
                        displayView.bufferedDidChange(bufferTime, totalDuration: itemDuration)
                        totalDuration = itemDuration
                        if itemDuration == bufferTime {
                            bufferState = .bufferFinished
                        }
                    }
                    if let currentTime = playerItem?.currentTime().seconds{
                        if (bufferTime - currentTime) >= bufferInterval && state != .paused {
                            play()
                        }
                        if (bufferTime - currentTime) < bufferInterval {
                            bufferState = .buffering
                            buffering = true
                        } else {
                            buffering = false
                            bufferState = .readyToPlay
                        }
                    }
                } else {
                    play()
                }
            }
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}

// MARK: - Selecter
extension Selector {
    static let playerItemDidPlayToEndTime = #selector(Player.playerItemDidPlayToEnd(_:))
    static let applicationWillEnterForeground = #selector(Player.applicationWillEnterForeground(_:))
    static let applicationDidEnterBackground = #selector(Player.applicationDidEnterBackground(_:))
}


