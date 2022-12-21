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
    
    fileprivate func CreateTeamFoulsGrid(_ teamFoulsByQuarter: [Int]) -> some View {
        return Grid(alignment: .center, horizontalSpacing: 10, verticalSpacing: 15) {
            GridRow {
                Text("")
                Text("Q1")
                Text("Q2")
                Text("Q3")
                Text("Q4")
                Text("OT")
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
        
        CreateTeamFoulsGrid(teamFouls["home"]!)
        VStack {
            Button("Next Qtr") {
                withAnimation {
                    self.activeQuarter+=1
                }
            }.buttonStyle(.bordered)
        }
        CreateTeamFoulsGrid(teamFouls["guest"]!)
        
    }
}

//struct TeamFoulsView_Previews: PreviewProvider {
//    @Binding var activeQuarter = 0
//
//    static var previews: some View {
//        TeamFoulsView(activeQuarter: self.activeQuarter)
//    }
//}
