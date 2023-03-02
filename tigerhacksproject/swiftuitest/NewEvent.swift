//
//  NewEvent.swift
//  swiftuitest
//
//  Created by Andy on 11/6/22.
//

import SwiftUI

struct NewEvent: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var data: GeneralData
    @State private var title = ""
    @State private var currentDate = Date()
    @State private var currentSelection: TransportType = .car

    
    var body: some View {
        VStack{
            HStack{
                Button("Cancel"){
                    dismiss()
                }
                Spacer()
                Button("Add"){
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "a"
                    let AM = formatter.string(from: currentDate) == "AM"
                    
                    let calendar = Calendar.current
                    let Time = ClockTime(hours: calendar.component(.hour, from: currentDate), minutes: calendar.component(.minute, from: currentDate), AM: AM)
                    
                    let newEvent = CommuteEvent(id: data.getNumEvents(), Title: title, TimeHours: Time, location: WorldLocation(lon: 100, lat: 100))
                    data.addEvent(inEvent: newEvent)
                    
                    dismiss()
                }
                .fontWeight(Font.Weight.bold)
            }.padding()
            VStack(alignment: .leading){
//                Spacer()
                TextField("New Event", text: $title)
                    .font(.title)
                    .frame(width: 350, height: 160)
                
                DatePicker("What time do you have to be there?", selection: $currentDate, displayedComponents: .hourAndMinute)
                    .frame(width: 350, height: 80)
                
                HStack {
                    Text("How do you usually get there?")
                    
                    Spacer()
                    
                    Picker(selection: $currentSelection, label: Text("")) {
                                    ForEach(TransportType.allCases, id: \.id) { value in
                                        Text(value.rawValue)
                                            .tag(value)
                                    }
                    }.labelsHidden()
                }.frame(width: 350, height: 80)
                
                
            }
        }.padding()
    }
}

struct NewEvent_Previews: PreviewProvider {
    static var previews: some View {
        NewEvent()
    }
}
