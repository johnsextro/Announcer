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
        sortDescriptors: [NSSortDescriptor(keyPath: \Team.year, ascending: false)]
        , predicate: NSPredicate(format: "men == YES")) private var menTeams: FetchedResults<Team>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Team.year, ascending: false)]
        , predicate: NSPredicate(format: "men == NO")) private var womenTeams: FetchedResults<Team>
    
    @State private var schoolName: String = ""
    @State private var mensTeam: Bool = true
    @State private var year: String = ""
    @State private var mascot: String = ""
    
    @Binding var isNFHSGame: Bool
    @Binding var isMensGame: Bool
    @Binding var teamFouls: [String: [Int]]
    @Binding var homeSelection: String!
    @Binding var guestSelection: String!
    
    
    var body: some View {
        VStack {
            Spacer().frame(height: 75)
            VStack {
                Text("Game Setup").font(.title2)
                Form {
                    VStack(alignment: .leading) {
                        List {
                            Picker("NFHS", selection: $isNFHSGame) {
                                Text("NFHS").tag(true)
                                Text("NCAA").tag(false)
                            }.pickerStyle(.segmented).frame(width: 200)
                        }
                        List {
                            Picker("Format", selection: $isMensGame) {
                                Text("Men").tag(true)
                                Text("Women").tag(false)
                            }.pickerStyle(.segmented).frame(width: 200)
                        }
                        List {
                            Picker("Select Home Team", selection: $homeSelection) {
                                ForEach(mensTeam ? menTeams : womenTeams, id: \.self) { team in
                                    Text(team.name!).tag(team.name)
                                }
                            }
                        }
                        List {
                            Picker("Select Guest Team", selection: $guestSelection) {
                                ForEach(mensTeam ? menTeams : womenTeams, id: \.self) { team in
                                    Text(team.name!).tag(team.name)
                                }
                            }
                        }
                        Button("Start Game") {
                            mensTeam = isMensGame
                            teamFouls["home"] = Array(repeating: 0, count: isMensGame || isNFHSGame ? 3 : 5)
                            teamFouls["guest"] = Array(repeating: 0, count: isMensGame || isNFHSGame ? 3 : 5)
                            dismiss()
                        }.buttonStyle(.borderedProminent)
                    }
                }
            }
            VStack {
                Text("New Team").font(.title2)
                Form {
                    VStack(alignment: .leading) {
                        HStack {
                            List {
                                Picker("Format", selection: $mensTeam) {
                                    Text("Men").tag(true)
                                    Text("Women").tag(false)
                                }.pickerStyle(.segmented).frame(width: 200)
                            }
                            TextField("School Name", text: $schoolName).textFieldStyle(.roundedBorder).disableAutocorrection(true).textInputAutocapitalization(.words)
                        }
                        HStack {
                            TextField("Mascot", text: $mascot).textFieldStyle(.roundedBorder).disableAutocorrection(true)
                            TextField("Year", text: $year).keyboardType(.numberPad).textFieldStyle(.roundedBorder)
                        }
                        Button("Save Team") {
                            let team = Team(context: viewContext)
                            team.id = UUID()
                            team.mascot = mascot
                            team.name = schoolName
                            team.year = Int16(year)!
                            team.men = mensTeam
                            
                            do {
                                try viewContext.save()
                            } catch {
                                
                            }
                            schoolName = ""
                            mascot = ""
                            year = ""
                        }.buttonStyle(.borderedProminent)
                    }
                }
            }
        }
    }
}

struct NewGameSheetView_Previews: PreviewProvider {
    @State private static var previewIsMensGame = true
    @State private static var previewIsNFHSGame = false
    @State private static var previewTeamFouls: [String: [Int]] = ["home": [0,0,0]]
    @State private static var previewHomeSelection: String! = "Webster"
    @State private static var previewGuestSelection: String! = "Webster"
    
    static var previews: some View {
        NewGameSheetView(isNFHSGame: $previewIsNFHSGame, isMensGame: $previewIsMensGame, teamFouls: $previewTeamFouls, homeSelection: $previewHomeSelection, guestSelection: $previewGuestSelection).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
