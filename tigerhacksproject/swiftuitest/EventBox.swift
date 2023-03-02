//
//  Event.swift
//  swiftuitest
//
//  Created by Andy on 11/5/22.
//

import SwiftUI

struct CommuteEvent: Identifiable{
    var id: Int
    var Title: String
    var TimeHours: ClockTime
    var location: WorldLocation
}

struct EventBox: View {
    private var initiated: Bool
    private var boxColor: Color
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(boxColor)
                .frame(width: 800, height: 100)
        }
    }
    
    init(initiated: Bool = false, boxColor: Color = .white) {
        self.initiated = initiated
        self.boxColor = boxColor
    }
}

struct Event_Previews: PreviewProvider {
    static var previews: some View {
        EventBox()
    }
}
