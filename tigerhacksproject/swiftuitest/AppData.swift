//
//  AppData.swift
//  swiftuitest
//
//  Created by Andy on 11/6/22.
//

import SwiftUI

struct WorldLocation{
    private var lon, lat: Float
    
    init(lon: Float, lat: Float) {
        self.lon = lon
        self.lat = lat
    }
}

struct WeatherData: Decodable {
    let resolvedAddress: String
    let days: [WeatherDays]
}

struct WeatherDays: Decodable {
    let datetime: String
    let cloudcover: Float
    let temp: Float
    let uvindex:Float
    let precipprob:Float
    let hours: [WeatherHours]
}
struct WeatherHours: Decodable {
    let datetime: String
    let cloudcover: Float
    let temp: Float
    let uvindex:Float
    let precipprob:Float
    
}

enum TransportType: String, CaseIterable{
    case onfoot = "On Foot"
    case car = "Car"
    case bicycle = "Bicycle"
    case publictr = "Public Transport"
    
    init?(id : Int) {
            switch id {
            case 1: self = .onfoot
            case 2: self = .car
            case 3: self = .bicycle
            case 4: self = .publictr
            default: return nil
            }
        }
}

extension TransportType: Identifiable {
    var id: Self { self }
}

class GeneralData: ObservableObject{
    @Published var events = [CommuteEvent]()
    @Published var currDay: Days = .monday
    
    var sundayImportantHours = [Int]()
    var mondayImportantHours = [Int]()
    var tuesdayImportantHours = [Int]()
    var wednesdayImportantHours = [Int]()
    var thursdayImportantHours = [Int]()
    var fridayImportantHours = [Int]()
    var saturdayImportantHours = [Int]()
    
    func addEvent(inEvent: CommuteEvent){
        events.append(inEvent)
        
        mondayImportantHours.append(inEvent.TimeHours.getHoursMilitary())
    }
    
    func updateCurrDay(newCurrDay: Days){
        currDay = newCurrDay
    }
    
    func getCurrDay() -> Days{
        return currDay
    }
    
    func getNumEvents() -> Int{
        return events.count
    }
    
    func getEvents() -> [CommuteEvent]{
        return events
    }
    
    init(){
        self.sundayImportantHours = UserDefaults.standard.array(forKey: "sundayImportantHours") as? [Int] ?? []
        
        self.mondayImportantHours = UserDefaults.standard.array(forKey: "mondayImportantHours") as? [Int] ?? []
        
        self.tuesdayImportantHours = UserDefaults.standard.array(forKey: "tuesdayImportantHours") as? [Int] ?? []
        
        self.wednesdayImportantHours = UserDefaults.standard.array(forKey: "wednesdayImportantHours") as? [Int] ?? []
        
        self.thursdayImportantHours = UserDefaults.standard.array(forKey: "thursdayImportantHours") as? [Int] ?? []
        
        self.fridayImportantHours = UserDefaults.standard.array(forKey: "fridayImportantHours") as? [Int] ?? []
        
        self.saturdayImportantHours = UserDefaults.standard.array(forKey: "saturdayImportantHours") as? [Int] ?? []
        
        for event in self.mondayImportantHours{
            let newEvent = CommuteEvent(id: events.count, Title: "", TimeHours: ClockTime(hours: event, minutes: 0, AM: false, isMilitaryTime: true), location: WorldLocation(lon: 0, lat: 0))
            events.append(newEvent)
        }
    }
}
