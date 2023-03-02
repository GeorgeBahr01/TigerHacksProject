//
//  Days.swift
//  swiftuitest
//
//  Created by Andy on 11/5/22.
//

import SwiftUI

enum Days: String, CaseIterable{
    
    case monday = "Monday"
    case tuesday = "Tuesday"
    case wednesday = "Wednesday"
    case thursday = "Thursday"
    case friday = "Friday"
    case saturday = "Saturday"
    case sunday = "Sunday"
    
    init?(id : Int) {
            switch id {
            case 1: self = .monday
            case 2: self = .tuesday
            case 3: self = .wednesday
            case 4: self = .thursday
            case 5: self = .friday
            case 6: self = .saturday
            case 7: self = .sunday
            default: return nil
            }
        }
}

extension Days: Identifiable {
    var id: Self { self }
}

func getDayNameShortened(inDay: Days) -> String{
    switch inDay {
    case .monday:
        return "M"
    case .tuesday:
        return "T";
    case .wednesday:
        return "W"
    case .thursday:
        return "T"
    case .friday:
        return "F"
    case .saturday:
        return "S"
    case .sunday:
        return "S"
    }
}

struct DayButton: View {
    private var day: Days = .monday
    @EnvironmentObject var data: GeneralData
    
    
    init(day: Days) {
        self.day = day
    }
    
    func updateAppearance(){
        
    }
    
    private func getIsActive() -> Bool{
        return day == data.currDay
    }
    
    var body: some View {
        ZStack{
            Circle()
                .fill(data.currDay == day ? Color.blue : .white)
            
            Button(getDayNameShortened(inDay:day)){
                data.currDay = day
            }
            .foregroundColor(.primary)
        }
    }
}

struct DayButton_Previews: PreviewProvider {
    static let data = GeneralData()
    static var previews: some View {
        DayButton(day: .monday).environmentObject(data)
    }
}
