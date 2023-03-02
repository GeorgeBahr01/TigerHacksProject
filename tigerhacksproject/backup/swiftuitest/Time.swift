//
//  Time.swift
//  swiftuitest
//
//  Created by Andy on 11/5/22.
//

import Foundation

struct ClockTime{
    private var hours, minutes: Int
    private var AM, isMilitaryTime: Bool
    
    init(hours: Int, minutes: Int, AM: Bool, isMilitaryTime: Bool = false) {
        self.hours = hours
        self.minutes = minutes
        self.AM = AM
        self.isMilitaryTime = isMilitaryTime
    }
    
    func getHours()->Int{
        return hours
    }
    
    func isAM() -> Bool{
        return self.AM
    }
    
    func getMinutes() -> Int{
        return minutes
    }
    
    func getAsString() -> String{
        var asString: String = ""
        let hAsString: String = hours < 10 ? "0" + String(hours) : String(hours)
        
        let mAsString: String = minutes < 10 ? "0" + String(minutes) : String(minutes)
        
        asString = hAsString + ":" + mAsString
        if(!isMilitaryTime){
            asString += AM ? " AM" : " PM"
        }
        
        return asString
    }
    
}
