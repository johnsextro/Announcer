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
    @State private var mensGame: Bool = true
    
    @State private var activeQuarter = 0
    @State private var teamFouls = ["home": [0,0,0], "guest": [0,0,0]]
    
    @State private var homeSortOrder = [KeyPathComparator(\Person.jerseyNumber)]
    @State private var guestSortOrder = [KeyPathComparator(\Person.jerseyNumber)]
    
    fileprivate func CreatePlayerHeader() -> some View {
        return HStack (alignment: .top) {
            Text("##").frame(width: 75)
            Text("Name").frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
            Text("PF").frame(width: 90)
        }.padding(Edge.Set.Element.all, 5).foregroundColor(Color.blue)
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
                homeTeam.append(Person(fullName: player.name ?? "missing", jerseyNumber: player.jersey!, personalFouls: 0, edit: false))
            } else if (player.team == guestSelection) {
                guestTeam.append(Person(fullName: player.name ?? "missing", jerseyNumber: player.jersey!, personalFouls: 0, edit: false))
            }
        }
    }
    
    private func foulDecrement(playerId: (UUID)) {
        for index in 0..<homeTeam.count {
            if homeTeam[index].id == playerId {
                homeTeam[index].personalFouls-=1
            }
        }
        teamFouls["home"]![activeQuarter]-=1
    }

    private func foulIncrement(playerId: (UUID)) {
        for index in 0..<homeTeam.count {
            if homeTeam[index].id == playerId {
                homeTeam[index].personalFouls+=1
            }
        }
        teamFouls["home"]![activeQuarter]+=1
    }
    
    var body: some View {
        VStack() {
            Spacer().frame(height: 50)
                .sheet(isPresented: $showingSheet, onDismiss: loadPlayers) {
                    NewGameSheetView(mensGame: $mensGame, teamFouls: $teamFouls, homeSelection: $homeSelection, guestSelection: $guestSelection)
                }
            Group {
                HStack {
                    TeamFoulsView(activeQuarter: $activeQuarter, teamFouls: $teamFouls, mensgame: self.mensGame)
                }
                Divider()
                HStack {
                    Text(teams.first(where: { $0.name == homeSelection})?.mascot ?? "").frame(maxWidth: .infinity).font(.title)
                    Text(teams.first(where: { $0.name == guestSelection})?.mascot ?? "").frame(maxWidth: .infinity).font(.title)
                }
                HStack {
                    CreatePlayerHeader()
                    CreatePlayerHeader()
                    
                }
            }
            HStack (alignment: .top){
                VStack (alignment: .leading) {
                    Divider()
                    List {
                        ForEach(Array(zip(homeTeam.indices, homeTeam.sorted(using: homeSortOrder))), id: \.0) { homeIndex, player in
                            PlayerRow(playerItem: player, foulDecrement: {_ in self.foulDecrement(playerId: player.id)}, foulIncrement: {_ in self.foulIncrement(playerId: player.id)})
                                .listRowBackground(determineRowColor(homeIndex, home: true))
                            //                            ZStack {
                            //                                Rectangle().foregroundColor(determineRowColor(homeIndex, home: true)).frame(maxWidth: .infinity).opacity(0.40)
                            //                                HStack {
                            //                                    Text(player.jerseyNumber).frame(width: 45)
                            //                                    if player.edit {
                            //                                        TextField("", text: $homeTeam.first(where: { $0.id == player.id })!.fullName)
                            //                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            //                                            .padding(.leading, 5).font(.system(size: 20))
                            //                                            .disableAutocorrection(true)
                            //                                            .onSubmit {
                            //                                                for index in 0..<homeTeam.count {
                            //                                                    if homeTeam[index].id == player.id {
                            //                                                        homeTeam[index].edit.toggle()
                            //                                                    }
                            //                                                }
                            //                                            }
                            //                                    } else {
                            //                                        Text(player.fullName).frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading).onLongPressGesture {
                            //                                            withAnimation {
                            //                                                for index in 0..<homeTeam.count {
                            //                                                    if homeTeam[index].id == player.id {
                            //                                                        homeTeam[index].edit.toggle()
                            //                                                    }
                            //                                                }
                            //                                            }
                            //                                        }
                            //                                    }
                            //                                    Text(String(player.personalFouls)).frame(width: 45).onTapGesture {
                            //                                        for index in 0..<homeTeam.count {
                            //                                            if homeTeam[index].id == player.id {
                            //                                                homeTeam[index].personalFouls+=1
                            //                                            }
                            //                                        }
                            //                                        teamFouls["home"]![activeQuarter]+=1
                            //                                    }
                            //                                }.frame(maxWidth: .infinity).padding(Edge.Set.Element.all, 3)
                            //                            }.fixedSize(horizontal: false, vertical: true)
                        }
                    }.listStyle(.inset)
                }
                VStack (alignment: .leading) {
                    Divider()
                    ForEach(Array(zip(guestTeam.indices, guestTeam.sorted(using: guestSortOrder))), id: \.0) { guestIndex, player in
                        ZStack {
                            Rectangle().foregroundColor(determineRowColor(guestIndex, home: false)).frame(maxWidth: .infinity).opacity(0.40)
                            HStack {
                                Text(player.jerseyNumber).frame(width: 45)
                                if player.edit {
                                    TextField("", text: $guestTeam.first(where: { $0.id == player.id })!.fullName)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.leading, 5).font(.system(size: 20))
                                        .disableAutocorrection(true)
                                        .onSubmit {
                                            for index in 0..<guestTeam.count {
                                                if guestTeam[index].id == player.id {
                                                    guestTeam[index].edit.toggle()
                                                }
                                            }
                                        }
                                } else {
                                    Text(player.fullName).frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading).onLongPressGesture {
                                        withAnimation {
                                            for index in 0..<guestTeam.count {
                                                if guestTeam[index].id == player.id {
                                                    guestTeam[index].edit.toggle()
                                                }
                                            }
                                        }
                                    }
                                }
                                Text(String(player.personalFouls)).frame(width: 45).onTapGesture {
                                    for index in 0..<guestTeam.count {
                                        if guestTeam[index].id == player.id {
                                            guestTeam[index].personalFouls+=1
                                        }
                                    }
                                    teamFouls["guest"]![activeQuarter]+=1
                                }
                            }.frame(maxWidth: .infinity).padding(Edge.Set.Element.all, 3)
                        }
                    }
                }
            }
            Group {
                Spacer()
                Divider()
                HStack {
                    AddPlayerView(team: $homeTeam, teamname: self.homeSelection)
                    Spacer().frame(width: 40)
                    AddPlayerView(team: $guestTeam, teamname: self.guestSelection)
                }.padding(Edge.Set.Element.all, 15)
                Spacer().frame(height: 25)
                Button("Reset Game") {
                    showingSheet.toggle()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
