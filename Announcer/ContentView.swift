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
    @State private var selection: Person.ID?
    
    var body: some View {
        var homeTable: Table = Table(homeTeam, selection: $selection, sortOrder: $homeSortOrder) {
            TableColumn("##", value: \.jerseyNumber).width(45)
            TableColumn("Name", value: \.fullName)
            TableColumn("PF") { homeTeam in Text(String(homeTeam.personalFouls))
            }.width(35)
        }
        
//        var guestTable: Table = Table(guestTeam, selection: $selection, sortOrder: $guestSortOrder) {
//            TableColumn("##", value:\.jerseyNumber).width(45)
//            TableColumn("Name", value: \.fullName)
//            TableColumn("PF") { guestTeam in
//                Text(String(guestTeam.personalFouls))
//            }.width(35)
//        }
        
            VStack() {
                HStack() {
                    Text("Home")
                    Button("Foul") {
                        if let unwrapped = selection {
                            for index in 0..<guestTeam.count {
                                if guestTeam[index].id == unwrapped {
                                    selection = nil
                                    
                                    guestTeam[index].personalFouls+=1
                                }
                            }
                        }
                    }
                }
                HStack (alignment: .top, spacing: 10){
                    homeTable.onChange(of: homeSortOrder) { newOrder in
                        homeTeam.sort(using: newOrder)
                    }
                    VStack (alignment: .leading) {
                        HStack (alignment: .top) {
                            Text("##").frame(width: 45)
                            Text("Name").frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
                            Text("PF").frame(width: 45)
                        }.padding(Edge.Set.Element.all, 5)
                        ForEach(guestTeam) { team in
                            HStack () {
                                Text(team.jerseyNumber).frame(width: 45)
                                Text(team.fullName).frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
                                Text(String(team.personalFouls)).frame(width: 45)
                            }.padding(Edge.Set.Element.all, 5)
                        }
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
