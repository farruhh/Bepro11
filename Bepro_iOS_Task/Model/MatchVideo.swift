//
//  MatchVideo.swift
//  Bepro_iOS_Task
//
//  Created by frank on 2021/05/24.
//

import Foundation

struct Response<T: Codable>: Codable {
    var data: T?
}
// MARK: - Match
struct MatchVideo: Codable {
    var id, matchID, videoID: Int?
    var video: Video?
    var created, modified: String?
    var padding, startMatchTime, endMatchTime: Int?
    var eventPeriod: String?
    var isActive: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case matchID = "matchId"
        case videoID = "videoId"
        case video, created, modified, padding, startMatchTime, endMatchTime, eventPeriod, isActive
    }
}
// MARK: - Video
struct Video: Codable {
    var id, userID: Int?
    var created, modified: String?
    var title: String?
    var duration: Int?
    var servingURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "userId"
        case servingURL = "servingUrl"
        case created, modified, title, duration
    }
}
