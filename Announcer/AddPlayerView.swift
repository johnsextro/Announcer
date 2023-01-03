//
//  AddPlayerView.swift
//  Announcer
//
//  Created by John Sextro on 12/21/22.
//

import SwiftUI

struct AddPlayerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var newPlayerJersey = ""
    @State private var newPlayerFullname = ""
    
    @Binding var team: [Person]
    var teamname: String
    var teamSortOrder = [KeyPathComparator(\Person.jerseyNumber)]
    
    
    var body: some View {
        
        DisclosureGroup("Add Player") {
            VStack (alignment: .leading) {
                TextField("##", text: $newPlayerJersey).frame(width: 45).keyboardType(.numberPad).textFieldStyle(.roundedBorder)
                TextField("Full Name", text: $newPlayerFullname).textFieldStyle(.roundedBorder).disableAutocorrection(true)
                Button("Save") {
                    var nextNumber: String
                    switch newPlayerJersey {
                    case "5", "15", "25", "35", "45" : nextNumber = String(Int(newPlayerJersey)! + 5)
                    default : nextNumber = String(Int(newPlayerJersey)! + 1)
                    }
                    let playerToPersist = Player(context: viewContext)
                    playerToPersist.team = teamname
                    playerToPersist.name = newPlayerFullname
                    playerToPersist.jersey = newPlayerJersey
                    playerToPersist.id = UUID()
                    do {
                        try viewContext.save()
                    } catch {
                        // handle the Core Data error
                    }
                    team.append(Person(fullName: newPlayerFullname, jerseyNumber: newPlayerJersey, id: playerToPersist.id!, personalFouls: 0, edit: false))
                    newPlayerJersey = nextNumber
                    newPlayerFullname = ""
                    team = team.sorted(using: teamSortOrder)
                }.buttonStyle(.borderedProminent)
            }
        }
    }
}

struct AddPlayerView_Previews: PreviewProvider {
    @State static var previewteam: [Person] = []
    static var previewTeamName: String = "HARVARD"
    
    static var previews: some View {
        HStack {
            AddPlayerView(team: $previewteam, teamname: previewTeamName).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
