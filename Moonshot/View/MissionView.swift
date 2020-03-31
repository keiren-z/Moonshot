//
//  MissionView.swift
//  Moonshot
//
//  Created by keiren on 3/29/20.
//  Copyright © 2020 keiren. All rights reserved.
//

import SwiftUI

struct MissionView: View {
    
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let astronauts: [CrewMember]
    
    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission
        var matches = [CrewMember]()
        
        for member in mission.crew {
            if let match = astronauts.first(where: {
                $0.id == member.name }) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("Missing \(member)")
            }
        }
         self.astronauts = matches
    }
    
    var body: some View {
        //GeometryReader is a view that gives you access to the size and position of your parent.
        /*We use GeometryReader to set the maximum width of the mission image, although through some trial and error I found that the mission badge worked best when it wasn’t full width – somewhere between 50% and 75% width looked better, to avoid it becoming weirdly big on the screen.*/
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(self.mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: geometry.size.width * 0.7)
                        .padding(.top)
                    Text(self.mission.formattedLaunchDate)
                        
                    Text(self.mission.description)
                         .padding()
                    
                    ForEach(self.astronauts, id: \.role) {
                        crewMember in
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut)) {
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                                
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .font(.headline)
                                    Text(crewMember.role)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        // We need to ask SwiftUI to render the contents of the navigation link as a plain button, which means it won’t apply coloring to the image or text.
                        .buttonStyle(PlainButtonStyle())
                    }
                    //  it ensures the spacer has a minimum height of at least 25 points
                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(mission.displayName), displayMode:.inline)
    }
}

struct MissionView_Previews: PreviewProvider {
    
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts)
    }
}
