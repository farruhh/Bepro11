//
//  APICommunicator.swift
//  Bepro_iOS_Task
//
//  Created by frank on 2021/05/22.
//

import Foundation
import Alamofire
import SwiftyJSON
import PromiseKit

class APICommunicator {
    static func fetchMatchVideos(_ matchID: Int = 0) -> Promise<Response<[MatchVideo]>> {
        let decoder = JSONDecoder()
        return Promise { seal in
            AF.request(BeproAPI.getMatchVideos(matchID), method: .get, parameters: ["matchId": matchID]).responseDecodable(of: Response<[MatchVideo]>.self,decoder: decoder) { response in
                switch response.result {
                case .success(let value):
                    return seal.fulfill(value)
                case .failure(let error):
                    return seal.reject(error)
                }
            }
        }
    }
}
