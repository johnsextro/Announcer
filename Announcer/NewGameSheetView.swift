//
//  NewGameSheetView.swift
//  Announcer
//
//  Created by John Sextro on 12/24/22.
//

import SwiftUI

struct NewGameSheetView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Team.year, ascending: false)],
        animation: .default) private var teams: FetchedResults<Team>
    
    @Binding var mensGame: Bool
    @Binding var teamFouls: [String: [Int]]
    @Binding var homeSelection: String!
    @Binding var guestSelection: String!

    var body: some View {
        Spacer().frame(height: 35)
        HStack {
            Text("Game Setup").font(.title)
        }
        Form {
            VStack(alignment: .leading) {
                HStack {
                    Text("Format")
                    Spacer().frame(width: 100)
                    List {
                        Picker("Format", selection: $mensGame) {
                            Text("Men").tag(true)
                            Text("Women").tag(false)
                        }.pickerStyle(.segmented).frame(width: 400)
                    }.onChange(of: self.mensGame) { newValue in
                        if (newValue) {
                            teamFouls["home"] = [0,0,0]
                            teamFouls["guest"] = [0,0,0]
                        } else {
                            teamFouls["home"] = [0,0,0,0,0]
                            teamFouls["guest"] = [0,0,0,0,0]
                        }
                    }
                }
                List {
                    Picker("Select Home Team", selection: $homeSelection) {
                        ForEach(teams, id: \.self) { team in
                            Text(team.name!).tag(team.name)
                        }
                    }.frame(width: 550)
                }
                List {
                    Picker("Select Guest Team", selection: $guestSelection) {
                        ForEach(teams, id: \.self) { team in
                            Text(team.name!).tag(team.name)
                        }
                    }.frame(width: 550)
                }
                Spacer().frame(height: 60)
                Button("Load Teams") {
                    dismiss()
                }.buttonStyle(.borderedProminent)
            }
        }
    }
}
