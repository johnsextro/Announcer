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
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack (alignment: .top, spacing: 10){
                VStack (alignment: .leading) {
                    createPlayerHeader()
                    
                    ForEach(homeTeam.sorted(using: homeSortOrder)) { team in
                        HStack () {
                            Text(team.jerseyNumber).frame(width: 45)
                            Text(team.fullName).frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
                            Text(String(team.personalFouls)).frame(width: 45).onTapGesture {
                                withAnimation (.easeIn(duration: 0.3)) {
                                    for index in 0..<homeTeam.count {
                                        if homeTeam[index].id == team.id {
                                            homeTeam[index].personalFouls+=1
                                        }
                                    }
                                }
                            }
                        }.padding(Edge.Set.Element.all, 5)
                                                                      
                    }
                }
                VStack (alignment: .leading) {
                    createPlayerHeader()
                    
                    ForEach(guestTeam.sorted(using: guestSortOrder)) { team in
                        HStack () {
                            Text(team.jerseyNumber).frame(width: 45)
                            Text(team.fullName).frame(minWidth: 100, idealWidth: 200, maxWidth: 400, minHeight: nil, idealHeight: nil, maxHeight: nil, alignment: .leading)
                            Text(String(team.personalFouls)).frame(width: 45).onTapGesture {
                                withAnimation (.easeIn(duration: 0.3)) {
                                    for index in 0..<guestTeam.count {
                                        if guestTeam[index].id == team.id {
                                            guestTeam[index].personalFouls+=1
                                        }
                                    }
                                }
                            }
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
