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
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    struct Person: Identifiable {
        var fullName: String
        var jerseyNumber: String
        let id = UUID()
        var personalFouls: Int
        var edit: Bool
        }
    
    @State private var teamFouls = ["home": [0,0,0,0,0], "guest": [0,0,0,0,0]]
    @State private var activeQuarter = 0
    @State private var quarterIndex = 0
    @State private var newPlayerJersey = ""
    @State private var newPlayerFullname = ""
    
    @State private var homeTeam = [
        Person(fullName: "Juan Chavez", jerseyNumber: "5", personalFouls: 0, edit: false),
        Person(fullName: "Mei Chen", jerseyNumber: "15", personalFouls: 0,edit: false),
        Person(fullName: "Tom Clark", jerseyNumber: "20", personalFouls: 0, edit: false),
        Person(fullName: "Gita Kumar", jerseyNumber: "25", personalFouls: 0, edit: false)
    ]

    @State private var guestTeam = [
        Person(fullName: "Kate Rolfes", jerseyNumber: "23", personalFouls: 0, edit: false),
        Person(fullName: "Emily Wilson", jerseyNumber: "35", personalFouls: 0, edit: false),
        Person(fullName: "Julie Baudendistel", jerseyNumber: "15", personalFouls: 0, edit: false),
        Person(fullName: "Claire Williams", jerseyNumber: "2", personalFouls: 0, edit: false)
    ]
    
    @State private var homeSortOrder = [KeyPathComparator(\Person.jerseyNumber)]
    @State private var guestSortOrder = [KeyPathComparator(\Person.jerseyNumber)]

    
    fileprivate func createPlayerHeader() -> some View {
        return HStack (alignment: .top) {
            Text("##").frame(width: 45)
            Text("Name").frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
            Text("PF").frame(width: 45)
        }.padding(Edge.Set.Element.all, 5).foregroundColor(Color.blue)
    }
    
    fileprivate func determineRowColorRed(_ index: inout Int) -> Color {
        var rowColor: Color = Color.clear
        index += 1
        if index % 2 == 0 {
            rowColor = Color.pink
        }
        return rowColor
        
    }
    
    fileprivate func determineRowColorYellow(_ index: inout Int) -> Color {
        var rowColor: Color = Color.clear
        index += 1
        if index % 2 == 0 {
            rowColor = Color.yellow
        }
        return rowColor
        
    }
    
    fileprivate func teamFoulsColor() -> Color {
        quarterIndex += 1
        return quarterIndex < activeQuarter ? Color.black : Color.red
    }
    
    var body: some View {
        var homeRowCount = 0
        var guestRowCount = 0
        VStack() {
            HStack {
                Grid(alignment: .center, horizontalSpacing: 10, verticalSpacing: 15) {
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
                        ForEach(teamFouls["home"]!, id: \.self) {
                            Text("\($0)")
                            }
                    }
                }.frame(maxWidth: .infinity)
                VStack {
                    Button("Next Qtr") {
                        withAnimation {
                            activeQuarter+=1
                        }
                    }.buttonStyle(.bordered)
                }
                Grid(alignment: .center, horizontalSpacing: 15, verticalSpacing: 15) {
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
                        ForEach(teamFouls["guest"]!, id: \.self) {
                                Text("\($0)")
                            }
                    }
                }.frame(maxWidth: .infinity)
            }
            HStack (alignment: .top){
                VStack (alignment: .leading) {
                    createPlayerHeader()
                    Divider()
                    ForEach(homeTeam.sorted(using: homeSortOrder)) { player in
                        ZStack {
                            Rectangle().foregroundColor(determineRowColorRed(&homeRowCount)).frame(maxWidth: .infinity).opacity(0.40)
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
                    createPlayerHeader()
                    Divider()
                    ForEach(guestTeam.sorted(using: guestSortOrder)) { player in
                        ZStack {
                            Rectangle().foregroundColor(determineRowColorYellow(&guestRowCount)).frame(maxWidth: .infinity).opacity(0.40)
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
            HStack {
                Form {
                    TextField("Number", text: $newPlayerJersey)
                    TextField("Full Name", text: $newPlayerFullname)
                    Button("Save") {
                        homeTeam.append(Person(fullName: newPlayerFullname, jerseyNumber: newPlayerJersey, personalFouls: 0, edit: false))
                    }
                }.fixedSize(horizontal: false, vertical: false)
                Form {
                    TextField("Number", text: $newPlayerJersey)
                    TextField("Full Name", text: $newPlayerFullname)
                    Button("Save") {
                        guestTeam.append(Person(fullName: newPlayerFullname, jerseyNumber: newPlayerJersey, personalFouls: 0, edit: false))
                    }
                }.fixedSize(horizontal: false, vertical: false)
            }
            Rectangle().frame(maxHeight: .infinity).foregroundColor(Color.gray)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
