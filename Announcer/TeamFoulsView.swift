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
    var isMensGame: Bool
    var isNFHS: Bool
    
    private func isNCAAWomensGame() -> Bool {
        return !isNFHS && !isMensGame
    }
    
    private func determineColor(teamFouls: Int, quarterOffset: Int) -> Color {
        var foulColor: Color = .gray
        if (quarterOffset < activeQuarter) {
            foulColor = .gray
        } else if (quarterOffset == activeQuarter) {
            switch teamFouls {
            case 3...4:
                foulColor = (isNCAAWomensGame()) ? .orange : .blue
            case 5:
                foulColor = (isNCAAWomensGame()) ? .red : .orange
            case 6:
                foulColor = (isNFHS || isMensGame) ? .orange : .red
            case 7...99:
                foulColor = .red
            default:
                foulColor = .blue
            }
        } else {
            foulColor = .black
        }
        return foulColor
    }
    
    private func CreateTeamFoulsGrid(_ teamFoulsByQuarter: [Int]) -> some View {
        return Grid(alignment: .center, horizontalSpacing: 10, verticalSpacing: 15) {
            GridRow {
                Text("")
                if (isNCAAWomensGame()) {
                    Text("Q1")
                    Text("Q2")
                    Text("Q3")
                    Text("Q4")
                    Text("OT")
                } else {
                    Text("H1")
                    Text("H2")
                    Text("OT")
                }
            }
            Divider()
            GridRow {
                Text("Team Fouls")
                ForEach(Array(teamFoulsByQuarter.enumerated()), id: \.0) { offset, item in
                    Text("\(item)").font(.title2).foregroundColor(determineColor(teamFouls: item, quarterOffset: offset))
                }
            }
        }.frame(maxWidth: .infinity)
    }
    
    var body: some View {
        
        CreateTeamFoulsGrid(teamFouls["home"]!)
        VStack {
            Button("Next") {
                withAnimation {
                    activeQuarter+=1
                }
            }.buttonStyle(.bordered)
        }
        CreateTeamFoulsGrid(teamFouls["guest"]!)
        
    }
}

struct TeamFoulsView_Previews: PreviewProvider {
    @State static var previewactiveQuarter = 1
    @State static var previewteamFouls = ["home": [5,0,0,0,0], "guest": [99,99,99,99,99]]

    static var previews: some View {
        HStack {
            TeamFoulsView(activeQuarter: $previewactiveQuarter, teamFouls: $previewteamFouls, isMensGame: true, isNFHS: false)
        }
    }
}
