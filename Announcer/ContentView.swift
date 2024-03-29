//
//  ContentView.swift
//  Announcer
//
//  Created by John Sextro on 11/24/22.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Team.year, ascending: false)],
        animation: .default) private var teams: FetchedResults<Team>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Player.jersey, ascending: true)],
        animation: .default) private var players: FetchedResults<Player>
    
    @State private var homeTeam: [Person] = []
    @State private var guestTeam: [Person] = []
    @State private var showingSheet = true
    @State private var homeSelection: String! = ""
    @State private var guestSelection: String! = ""
    @State private var isMensGame: Bool = true
    @State private var isNFHSGame: Bool = false
    
    @State private var activeQuarter = 0
    @State private var teamFouls = ["home": [0,0,0], "guest": [0,0,0]]
    
    @State private var teamSortOrder = [KeyPathComparator(\Person.jerseyNumber)]
    
    fileprivate func CreatePlayerHeader() -> some View {
        return HStack (alignment: .top) {
            Text("##").frame(width: 45)
            Text("Name").frame(minWidth: 100, idealWidth: 285, maxWidth: 400, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
            Text("PF").frame(width: 75)
        }.foregroundColor(Color.blue)
    }
    
    fileprivate func determineRowColor(_ homeRowCount: Int, home: Bool) -> Color {
        var rowColor: Color = Color.clear
        if homeRowCount % 2 != 0 {
            rowColor = home==true ? Color.blue.opacity(0.40) : Color.yellow
        }
        return rowColor
    }
    
    fileprivate func loadPlayers() {
        homeTeam.removeAll()
        guestTeam.removeAll()
        for index in 0..<players.count {
            let player: Player = players[index]
            if (player.team == homeSelection) {
                homeTeam.append(Person(fullName: player.name ?? "missing", jerseyNumber: player.jersey!, id: player.id!, personalFouls: 0))
            } else if (player.team == guestSelection) {
                guestTeam.append(Person(fullName: player.name ?? "missing", jerseyNumber: player.jersey!, id: player.id!, personalFouls: 0))
            }
            activeQuarter = 0
        }
        homeTeam = homeTeam.sorted(using: teamSortOrder)
        guestTeam = guestTeam.sorted(using: teamSortOrder)
    }
    
    var body: some View {
        VStack() {
            Spacer().frame(height: 10)
                .sheet(isPresented: $showingSheet, onDismiss: loadPlayers) {
                    NewGameSheetView(isNFHSGame: $isNFHSGame, isMensGame: $isMensGame, teamFouls: $teamFouls, homeSelection: $homeSelection, guestSelection: $guestSelection)
                }
            Group {
                Button("Reset Game") {
                    showingSheet.toggle()
                }
                HStack {
                    TeamFoulsView(activeQuarter: $activeQuarter, teamFouls: $teamFouls, isMensGame: self.isMensGame, isNFHS: self.isNFHSGame)
                }
                Divider()
                HStack {
                    Text(teams.first(where: { $0.name == homeSelection})?.mascot ?? "").frame(maxWidth: .infinity).font(.title2)
                    Text(teams.first(where: { $0.name == guestSelection})?.mascot ?? "").frame(maxWidth: .infinity).font(.title2)
                }
            }
            HStack (alignment: .top){
                VStack (alignment: .leading) {
                    List {
                        Section(header: CreatePlayerHeader()) {
                            ForEach(homeTeam) { player in
                                PlayerRow(playerItem: player, player: players.first(where: {$0.id == player.id})!, isHomeTeam: true, team: $homeTeam, activeQuarter: $activeQuarter, teamFouls: $teamFouls)
                            }.onDelete { indexSet in
                                homeTeam.remove(atOffsets: indexSet)
                            }
                        }
                    }.listStyle(.inset)
                }
                VStack (alignment: .leading) {
                    List {
                        Section(header: CreatePlayerHeader()) {
                            ForEach(guestTeam) { player in
                                PlayerRow(playerItem: player, player: players.first(where: {$0.id == player.id})!, isHomeTeam: false, team: $guestTeam, activeQuarter: $activeQuarter, teamFouls: $teamFouls)
                            }.onDelete { indexSet in
                                guestTeam.remove(atOffsets: indexSet)
                            }
                        }
                    }.listStyle(.inset)
                }
            }
            Group {
                Divider()
                HStack {
                    AddPlayerView(team: $homeTeam, teamname: self.homeSelection)
                    Spacer().frame(width: 40)
                    AddPlayerView(team: $guestTeam, teamname: self.guestSelection)
                }.padding(Edge.Set.Element.all, 15)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
