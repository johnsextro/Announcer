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
    
    fileprivate func createPlayerTable(players: inout [Person], sortOrder: Binding<[KeyPathComparator<ContentView.Person>]>) -> some View {
        return Table(players, selection: $selection, sortOrder: sortOrder) {
            TableColumn("##", value:\.jerseyNumber).width(45)
            TableColumn("Name", value: \.fullName)
            TableColumn("PF") { players in
                Text(String(players.personalFouls))
            }.width(35)
            
        }
    }
    
    var body: some View {
        var homeTable = Table(homeTeam, selection: $selection, sortOrder: $homeSortOrder) {
            TableColumn("##", value:\.jerseyNumber).width(45)
            TableColumn("Name", value: \.fullName)
            TableColumn("PF") { homeTeam in
                Text(String(homeTeam.personalFouls))
            }.width(35)
        }.onChange(of: homeSortOrder) { newOrder in
            homeTeam.sort(using: newOrder)
        }
        
        var guestTable = Table(guestTeam, selection: $selection, sortOrder: $guestSortOrder) {
            TableColumn("##", value:\.jerseyNumber).width(45)
            TableColumn("Name", value: \.fullName)
            TableColumn("PF") { visitingTeam in
                Text(String(visitingTeam.personalFouls))
            }.width(35)
        }.onChange(of: guestSortOrder) { newOrder in
            guestTeam.sort(using: newOrder)
        }
        
            VStack() {
                HStack() {
                    Text("Home")
                    Button("Foul") {
                        if let unwrapped = selection {
                            for index in 0..<guestTeam.count {
                                if guestTeam[index].id == unwrapped {
                                    guestTeam[index].personalFouls+=1
                                }
                            }
                        }
                    }
                }
                HStack (alignment: .bottom, spacing: 10){
                    homeTable
                    guestTable
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
