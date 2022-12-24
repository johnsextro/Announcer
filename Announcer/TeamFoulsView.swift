//
//  TeamFoulsView.swift
//  Announcer
//
//  Created by John Sextro on 12/21/22.
//

import SwiftUI

struct TeamFoulsView: View {
    
    @Binding var activeQuarter: Int
    @Binding var teamFouls: [String: [Int]]
    var mensgame: Bool
    
    fileprivate func CreateTeamFoulsGrid(_ teamFoulsByQuarter: [Int]) -> some View {
        return Grid(alignment: .center, horizontalSpacing: 10, verticalSpacing: 15) {
            GridRow {
                Text("")
                if (mensgame) {
                    Text("H1")
                    Text("H2")
                    Text("OT")
                } else {
                    Text("Q1")
                    Text("Q2")
                    Text("Q3")
                    Text("Q4")
                    Text("OT")
                }
            }
            Divider()
            GridRow {
                Text("Team Fouls")
                ForEach(Array(teamFoulsByQuarter.enumerated()), id: \.0) { offset, item in
                    Text("\(item)").foregroundColor(offset >= activeQuarter ? .black : .red)
                }
            }
        }.frame(maxWidth: .infinity)
    }
    
    var body: some View {
        
        CreateTeamFoulsGrid(teamFouls["home"]!).font(.title3)
        VStack {
            Button("Next") {
                withAnimation {
                    self.activeQuarter+=1
                }
            }.buttonStyle(.bordered)
        }
        CreateTeamFoulsGrid(teamFouls["guest"]!).font(.title3)
        
    }
}

struct TeamFoulsView_Previews: PreviewProvider {
    @State static var previewactiveQuarter = 0
    @State static var previewteamFouls = ["home": [99,99,99,99,99], "guest": [99,99,99,99,99]]

    static var previews: some View {
        HStack {
            TeamFoulsView(activeQuarter: $previewactiveQuarter, teamFouls: $previewteamFouls, mensgame: true)
        }
    }
}
