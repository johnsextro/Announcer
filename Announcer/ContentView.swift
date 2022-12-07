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
        let givenName: String
        let familyName: String
        var jerseyNumber: String
        let id = UUID()
        var personalFouls: Int
        var fullName: String {
            get{("\(givenName) \(familyName)")}
        }
    }
    @State private var homeTeam = [
        Person(givenName: "Juan", familyName: "Chavez", jerseyNumber: "5", personalFouls: 0),
        Person(givenName: "Mei", familyName: "Chen", jerseyNumber: "15", personalFouls: 0),
        Person(givenName: "Tom", familyName: "Clark", jerseyNumber: "20", personalFouls: 0),
        Person(givenName: "Gita", familyName: "Kumar", jerseyNumber: "25", personalFouls: 0)
    ]
    @State private var guestTeam = [
        Person(givenName: "Kate", familyName: "Rolfes", jerseyNumber: "23", personalFouls: 0),
        Person(givenName: "Emily", familyName: "Wilson", jerseyNumber: "35", personalFouls: 0),
        Person(givenName: "Julie", familyName: "Baudendistel", jerseyNumber: "15", personalFouls: 0),
        Person(givenName: "Claire", familyName: "Williams", jerseyNumber: "2", personalFouls: 0)
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
    
    fileprivate func createPlayerRow(_ player: ContentView.Person) -> some View {
        return HStack () {
            Text(player.jerseyNumber).frame(width: 45)
            Text(player.fullName).frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
        }
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
    
    var body: some View {
        var rowCount = 0
        VStack() {
            HStack {
                Grid(alignment: .topLeading, horizontalSpacing: 0, verticalSpacing: 15) {
                    GridRow {
                        Text("Quarter")
                        Text("Q1").border(.blue)
                        Text("Q2").border(.blue)
                        Text("Q3").border(.blue)
                        Text("Q4").border(.blue)
                    }
                    GridRow {
                        Text("Team Fouls")
                        Text("1").border(.blue)
                        Text("0").border(.blue)
                        Text("").border(.blue)
                    }
                }.frame(maxWidth: .infinity).font(Font.title2)
                    
                Grid() {
                    GridRow {
                        Text("Q1")
                        Text("Q2")
                        Text("Q3")
                        Text("Q4")
                    }
                    GridRow {
                        Text("1")
                    }
                }.frame(maxWidth: .infinity)
            }
            HStack (alignment: .top){
                VStack (alignment: .leading) {
                    createPlayerHeader()
                    Divider()
                    ForEach(homeTeam.sorted(using: homeSortOrder)) { player in
                        ZStack {
                            Rectangle().foregroundColor(determineRowColorRed(&rowCount)).frame(maxWidth: .infinity).opacity(0.40)
                            HStack {
                                createPlayerRow(player)
                                Text(String(player.personalFouls)).frame(width: 45).onTapGesture {
                                    for index in 0..<homeTeam.count {
                                        if homeTeam[index].id == player.id {
                                            homeTeam[index].personalFouls+=1
                                        }
                                    }
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
                            Rectangle().foregroundColor(determineRowColorYellow(&rowCount)).frame(maxWidth: .infinity).opacity(0.40)
                            HStack {
                                createPlayerRow(player)
                                Text(String(player.personalFouls)).frame(width: 45).onTapGesture {
                                    for index in 0..<guestTeam.count {
                                        if guestTeam[index].id == player.id {
                                            guestTeam[index].personalFouls+=1
                                        }
                                    }
                                }
                            }.frame(maxWidth: .infinity).padding(Edge.Set.Element.all, 5)
                        }.fixedSize(horizontal: false, vertical: true)
                    }
                }
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
