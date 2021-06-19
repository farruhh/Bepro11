//
//  PlayerError.swift
//  Bepro_iOS_Task
//
//  Created by frank on 2021/05/24.
//

import Foundation
import AVFoundation

public struct PlayerError: CustomStringConvertible {
    var error : Error?
    var playerItemErrorLogEvent : [AVPlayerItemErrorLogEvent]?
    var extendedLogData : Data?
    var extendedLogDataStringEncoding : UInt?
    
   public var description: String {
        return "Player Log -------------------------- \n error: \(String(describing: error))\n playerItemErrorLogEvent: \(String(describing: playerItemErrorLogEvent))\n extendedLogData: \(String(describing: extendedLogData))\n extendedLogDataStringEncoding \(String(describing: extendedLogDataStringEncoding))\n --------------------------"
    }
}
