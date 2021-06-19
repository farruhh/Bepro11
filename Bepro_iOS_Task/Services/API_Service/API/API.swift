//
//  API.swift
//  Bepro_iOS_Task
//
//  Created by frank on 2021/05/22.
//

import Foundation

class BeproAPI {
    static private let baseUrl_MatchVideos = "https://recruit-dev.bepro11.com/api/match-videos"
    static func getMatchVideos(_ matchID: Int = 0) -> String {
        return baseUrl_MatchVideos + "?\(matchID)"
    }
}
