//
//  AstronautView.swift
//  Moonshot
//
//  Created by keiren on 3/29/20.
//  Copyright © 2020 keiren. All rights reserved.
//

import SwiftUI

struct AstronautView: View {
    
    struct astronautMissions {
        var role: String
        let mission: Mission
    }
    
    let astronaut: Astronaut
    let missions: [astronautMissions]
    
    init(astronaut: Astronaut) {
        
        self.astronaut = astronaut
        let missions: [Mission] = Bundle.main.decode("missions.json")
        var matches = [astronautMissions]()
        
        for mission in missions {
            for member in mission.crew {
                if member.name == astronaut.id {
                    matches.append(astronautMissions(role: member.role, mission: mission))
                }
            }
        }
         self.missions = matches
        
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                        .padding(.top)
                      
                    Text(self.astronaut.description)
                        .padding()
                        /* bugfix swiftUI
                      Layout priority lets us control how readily a view shrinks when space is limited, or expands when space is plentiful. All views have a layout priority of 0 by default, which means they each get equal chance to grow or shrink. We’re going to give our astronaut description a layout priority of 1, which is higher than the image’s 0, which means it will automatically take up all available space.
                             */
                        .layoutPriority(1)
                    Spacer()
                    
                    HStack {
                        Text("Missions:").fontWeight(.heavy)
                        Spacer()
                    }.padding(.leading)
                    
                    List {
                        ForEach(self.missions, id: \.role) { mission in
                            HStack {
                                Image(mission.mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 44, height: 44)
                                
                                VStack(alignment: .leading) {
                                    Text(mission.mission.displayName)
                                        .font(.headline)
                                    Text(mission.role)
                                }
                            }
                            
                        }
                    }
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
    
}

struct AstronautView_Previews: PreviewProvider {
   
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        AstronautView(astronaut: astronauts[0])
    }
}
