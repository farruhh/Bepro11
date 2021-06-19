//
//  VideoPlayerView.swift
//  Bepro_iOS_Task
//
//  Created by frank on 2021/05/25.
//

import UIKit
import AVKit

class VideoPlayerView: PlayerView {
    var matchVideo: [MatchVideo] = []
    let tableView = UITableView()
    var playRate : Float = 1.0
    let rateButton = UIButton(type: .custom)
    let bottomProgressView : UIProgressView = {
        let progress = UIProgressView()
        progress.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        progress.isHidden = true
        return progress
    }()
    let mirrorFlipButton = UIButton(type: .custom)
    var viewModel: PlayerViewModel!
    override func configurationUI() {
        super.configurationUI()
        self.titleLabel.removeFromSuperview()
        self.timeSlider.minimumTrackTintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        self.topView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        self.bottomView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        self.closeButton.setImage(UIImage(named: "Player_ic_nav_back"), for: .normal)
        self.topView.addSubview(rateButton)
        rateButton.snp.makeConstraints { (make) in
            make.right.equalTo(topView.snp.right).offset(-10)
            make.centerY.equalTo(closeButton)
        }
        rateButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        rateButton.setTitle("x1.0", for: .normal)
        rateButton.titleLabel?.font   = UIFont.boldSystemFont(ofSize: 14.0)
        rateButton.addTarget(self, action: #selector(onRateButton), for: .touchUpInside)
        
        self.addSubview(bottomProgressView)
        bottomProgressView.snp.makeConstraints { (make) in
            make.left.equalTo(self.snp.left)
            make.right.equalTo(self.snp.right)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(3)
        }
        
        
        mirrorFlipButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        mirrorFlipButton.setTitle("Mirror Flip: off", for: .normal)
        mirrorFlipButton.setTitle("Mirror Flip: on", for: .selected)
        mirrorFlipButton.titleLabel?.font   = UIFont.boldSystemFont(ofSize: 14.0)
        mirrorFlipButton.addTarget(self, action: #selector(onMirrorFlipButton(_:)), for: .touchUpInside)
        self.topView.addSubview(mirrorFlipButton)
        mirrorFlipButton.snp.makeConstraints { (make) in
            make.right.equalTo(rateButton.snp.left).offset(-10)
            make.centerY.equalTo(closeButton)
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PlaylistVideoCell.self, forCellReuseIdentifier: PlaylistVideoCell.id)
    }
    override func playStateDidChange(_ state: PlayerState) {
        super.playStateDidChange(state)
        if state == .playing {
            self.player?.player?.rate = playRate
        }
    }
    override func displayControlView(_ isDisplay: Bool) {
        super.displayControlView(isDisplay)
        self.bottomProgressView.isHidden = isDisplay
    }
    override func reloadPlayerView() {
        super.reloadPlayerView()
        self.playRate = 1.0
        self.rateButton.setTitle("x1.0", for: .normal)
    }
    override func playerDurationDidChange(_ currentDuration: TimeInterval, totalDuration: TimeInterval) {
        super.playerDurationDidChange(currentDuration, totalDuration: totalDuration)
        self.bottomProgressView.setProgress(Float(currentDuration/totalDuration), animated: true)
    }
    @objc func onRateButton() {
        switch playRate {
        case 1.0:
            playRate = 1.5
        case 1.5:
            playRate = 0.5
        default:
            playRate = 1.0
        }
        rateButton.setTitle("x\(playRate)", for: .normal)
        self.player?.player?.rate = playRate
    }
    @objc func onMirrorFlipButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.playerLayer?.transform = CATransform3DScale(CATransform3DMakeRotation(0, 0, 0, 0), -1, 1, 1)
        } else {
            self.playerLayer?.transform = CATransform3DScale(CATransform3DMakeRotation(0, 0, 0, 0), 1, 1, 1)
        }
        updateDisplayerView(frame: self.bounds)
    }
}

extension VideoPlayerView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Match Playlist"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchVideo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlaylistVideoCell.id) as! PlaylistVideoCell
        let data = self.matchVideo[indexPath.row]
        
        cell.configureCell(data)
        
        return cell
    }
}

// Well, code contains not 100% developed parts.. . 
extension VideoPlayerView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        for d in self.matchVideo {
//            if let matchUrl = d.video?.servingURL {
//                let first = AVPlayerItem(url: URL(string: matchUrl)!)
//                let second = AVPlayerItem(url: URL(string: matchUrl)!)
//
//                let player = AVQueuePlayer(items: [first, second])
//                player.advanceToNextItem()
//                print(player.items())
//
//                print("First: \(first)")
//                print("Second: \(second)")
//                player.
//            }
//
//        }
        APICommunicator.fetchMatchVideos(6230).done { response -> Void in
            guard let data = response.data else { return }
            for url in data {
                var item = AVQueuePlayer(url: URL(string: (url.video?.servingURL)!)!)
                
                item.replaceCurrentItem(with: item.currentItem)
            }
        }.catch{ (er) in
            print(er)
        }
    }
}
