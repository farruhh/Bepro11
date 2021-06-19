//
//  PlayerViewModel.swift
//  Bepro_iOS_Task
//
//  Created by frank on 2021/05/25.
//

import Foundation
import AVKit


class PlayerViewModel {
    var playerView = VideoPlayerView()
    var servingURL: URL?
    var player: Player = {
        let playerView = VideoPlayerView()
        let player = Player(playerView: playerView)
        
        return player
    }()
    var numberOfRows: Int {
        return self.playerView.matchVideo.count
    }
    
    func fetchVideo(_ matchID: Int = 0) {
        APICommunicator.fetchMatchVideos(matchID).done { ( response ) -> Void in
            guard let data = response.data  else { return }
            self.playerView.matchVideo = data
            self.playerView.tableView.reloadData()
            for url in data {
                if let servingURL = url.video?.servingURL {
                    self.servingURL = URL(string: servingURL)
                    self.player.replaceVideo(self.servingURL!)
                }
                print(url.video?.title!)
            }
        }.catch{ (error) in
            print(error)
        }
    }
}
