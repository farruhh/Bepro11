//
//  Timer+Player.swift
//  Bepro_iOS_Task
//
//  Created by frank on 2021/05/24.
//


//  Timer break retain cycle
import Foundation

extension Timer {
    class func player_scheduledTimerWithTimeInterval(_ timeInterval: TimeInterval, block: @escaping ()->(), repeats: Bool) -> Timer {
        return self.scheduledTimer(timeInterval: timeInterval, target:
            self, selector: #selector(self.player_blcokInvoke(_:)), userInfo: block, repeats: repeats)
    }
    @objc class func player_blcokInvoke(_ timer: Timer) {
        let block: ()->() = timer.userInfo as! ()->()
        block()
    }
}
