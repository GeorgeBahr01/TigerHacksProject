//
//  AppData.swift
//  swiftuitest
//
//  Created by Andy on 11/6/22.
//

import SwiftUI

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

struct WorldLocation{
    private var lon, lat: Float
    
    init(lon: Float, lat: Float) {
        self.lon = lon
        self.lat = lat
    }
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
    
    let sundayImportantHours = UserDefaults.standard.array(forKey: "sundayImportantHours") as? [Int] ?? []
    
    let mondayImportantHours = UserDefaults.standard.array(forKey: "mondayImportantHours") as? [Int] ?? []
    
    let tuesdayImportantHours = UserDefaults.standard.array(forKey: "tuesdayImportantHours") as? [Int] ?? []
    
    let wednesdayImportantHours = UserDefaults.standard.array(forKey: "wednesdayImportantHours") as? [Int] ?? []
    
    let thursdayImportantHours = UserDefaults.standard.array(forKey: "thursdayImportantHours") as? [Int] ?? []
    
    let fridayImportantHours = UserDefaults.standard.array(forKey: "fridayImportantHours") as? [Int] ?? []
    
    let saturdayImportantHours = UserDefaults.standard.array(forKey: "saturdayImportantHours") as? [Int] ?? []
    
    func getImportantHours(dayOfWeek:Int) -> [Int]
    {
        if(dayOfWeek == 0)
        {
            return sundayImportantHours
        }
        if(dayOfWeek == 1)
        {
            return mondayImportantHours
        }
        if(dayOfWeek == 2)
        {
            return tuesdayImportantHours
        }
        if(dayOfWeek == 3)
        {
            return wednesdayImportantHours
        }
        if(dayOfWeek == 4)
        {
            return thursdayImportantHours
        }
        if(dayOfWeek == 5)
        {
            return fridayImportantHours
        }
        else
        {
            return saturdayImportantHours
        }
        
    }
    
    func addEvent(inEvent: CommuteEvent){
        events.append(inEvent)
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
        
    }
}
