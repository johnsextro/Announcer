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
    
    //    @FetchRequest(
    //        sortDescriptors: [NSSortDescriptor(keyPath: \Team.year, ascending: false)],
    //        animation: .default) private var teams: FetchedResults<Team>
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Player.jersey, ascending: true)],
        animation: .default) private var players: FetchedResults<Player>
    
    @State private var teamFouls = ["home": [0,0,0,0,0], "guest": [0,0,0,0,0]]
    @State private var activeQuarter = 0
    @State private var newPlayerJersey = ""
    @State private var newPlayerFullname = ""
    
    @State private var homeTeam: [Person] = []
    @State private var guestTeam: [Person] = []
    
    @State private var homeSortOrder = [KeyPathComparator(\Person.jerseyNumber)]
    @State private var guestSortOrder = [KeyPathComparator(\Person.jerseyNumber)]
    
    fileprivate func CreatePlayerHeader() -> some View {
        return HStack (alignment: .top) {
            Text("##").frame(width: 45)
            Text("Name").frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
            Text("PF").frame(width: 45)
        }.padding(Edge.Set.Element.all, 5).foregroundColor(Color.blue)
    }
    
    fileprivate func determineRowColor(_ homeRowCount: Int, home: Bool) -> Color {
        var rowColor: Color = Color.clear
        if homeRowCount % 2 != 0 {
            rowColor = home==true ? Color.blue : Color.yellow
        }
        return rowColor
    }
    
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
        VStack() {
            HStack {
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
            HStack (alignment: .top){
                VStack (alignment: .leading) {
                    CreatePlayerHeader()
                    Divider()
                    ForEach(Array(zip(homeTeam.indices, homeTeam.sorted(using: homeSortOrder))), id: \.0) { homeIndex, player in
                        ZStack {
                            Rectangle().foregroundColor(determineRowColor(homeIndex, home: true)).frame(maxWidth: .infinity).opacity(0.40)
                            HStack {
                                Text(player.jerseyNumber).frame(width: 45)
                                if player.edit {
                                    TextField("", text: $homeTeam.first(where: { $0.id == player.id })!.fullName)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding(.leading, 5).font(.system(size: 20))
                                        .autocapitalization(.words)
                                        .disableAutocorrection(true)
                                        .onSubmit {
                                            for index in 0..<homeTeam.count {
                                                if homeTeam[index].id == player.id {
                                                    homeTeam[index].edit.toggle()
                                                }
                                            }
                                        }
                                } else {
                                    Text(player.fullName).frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading).onLongPressGesture {
                                        withAnimation {
                                            for index in 0..<homeTeam.count {
                                                if homeTeam[index].id == player.id {
                                                    homeTeam[index].edit.toggle()
                                                }
                                            }
                                        }
                                    }
                                }
                                Text(String(player.personalFouls)).frame(width: 45).onTapGesture {
                                    for index in 0..<homeTeam.count {
                                        if homeTeam[index].id == player.id {
                                            homeTeam[index].personalFouls+=1
                                        }
                                    }
                                    teamFouls["home"]![activeQuarter]+=1
                                }
                            }.frame(maxWidth: .infinity).padding(Edge.Set.Element.all, 5)
                        }.fixedSize(horizontal: false, vertical: true)
                    }
                }
                VStack (alignment: .leading) {
                    CreatePlayerHeader()
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
                                        .autocapitalization(.words)
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
                            }.frame(maxWidth: .infinity).padding(Edge.Set.Element.all, 5)
                        }.fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            Spacer()
            Divider()
            HStack (alignment: .top){
                Collapsible(
                    label: { Text("Add Player") },
                    content: {
                        Form {
                            HStack {
                                TextField("##", text: $newPlayerJersey).frame(width: 45)
                                TextField("Full Name", text: $newPlayerFullname)
                            }
                            HStack {
                                Spacer()
                                Button("Save") {
                                    homeTeam.append(Person(fullName: newPlayerFullname, jerseyNumber: newPlayerJersey, personalFouls: 0, edit: false))
                                    newPlayerJersey = String(Int(newPlayerJersey)! + 1)
                                    newPlayerFullname = ""
                                }.buttonStyle(.borderedProminent)
                            }
                        }
                    }
                )
                Collapsible(
                    label: { Text("Add Player") },
                    content: {
                        Form {
                            HStack {
                                TextField("##", text: $newPlayerJersey).frame(width: 45)
                                TextField("Full Name", text: $newPlayerFullname)
                            }
                            HStack {
                                Spacer()
                                Button("Save") {
                                    guestTeam.append(Person(fullName: newPlayerFullname, jerseyNumber: newPlayerJersey, personalFouls: 0, edit: false))
                                    newPlayerJersey = ""
                                    newPlayerFullname = ""
                                }.buttonStyle(.borderedProminent)
                            }
                        }.fixedSize(horizontal: false, vertical: false)
                    }
                )
            }
            Rectangle().frame(maxHeight: .infinity).foregroundColor(Color.gray)
        }.onAppear {
            for index in 0..<players.count {
                let player: Player = players[index]
                if (player.team == "Webster") {
                    homeTeam.append(Person(fullName: player.fullname!, jerseyNumber: player.jersey!, personalFouls: 0, edit: false))
                } else {
                    guestTeam.append(Person(fullName: player.fullname!, jerseyNumber: player.jersey!, personalFouls: 0, edit: false))
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
