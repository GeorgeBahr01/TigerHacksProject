//
//  TimeBlock.swift
//  swiftuitest
//
//  Created by Andy on 11/5/22.
//

import SwiftUI

struct TimeBlock: View {
    private var time: ClockTime
    @EnvironmentObject var data: GeneralData
    
    init(inTime: ClockTime) {
        self.time = inTime
    }
    
    var body: some View {
        
        HStack {
            Text(time.getAsString())
                .font(.footnote)
                .foregroundColor(Color.gray)
                .frame(width: 75.0)

            ZStack{
                Spacer()
                Divider()
                
                    ForEach(data.events){
                        event in
                        if(event.TimeHours.getHours() == time.getHours() && event.TimeHours.isAM() == time.isAM()){
                            ZStack{
                                RoundedRectangle(cornerRadius: 26).fill(.blue).frame(width: 305, height: 25)
                                
                                HStack {
                                    Text(event.Title).padding(.leading, 12)
                                    Spacer()
                                    Image(systemName: "sun.min.fill").padding(.trailing, 12.0)
                                }
                            }
                            
                        }
                    }
                
            }
        }
        .frame(height: 50.0)
    }
}

struct TimeBlock_Previews: PreviewProvider {
    static var data = GeneralData()
    
    static var previews: some View {
        Group{
            TimeBlock(inTime: ClockTime(hours: 12, minutes: 0, AM: true))
        }.environmentObject(data)
    }
}
