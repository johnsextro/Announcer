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
    
    var body: some View {
        Collapsible(
            label: { Text("Add Player") },
            content: {
                Form {
                    HStack {
                        TextField("##", text: $newPlayerJersey).frame(width: 45).keyboardType(.numberPad)
                        TextField("Full Name", text: $newPlayerFullname)
                    }
                    HStack {
                        Spacer()
                        Button("Save") {
                            team.append(Person(fullName: newPlayerFullname, jerseyNumber: newPlayerJersey, personalFouls: 0, edit: false))
                            var nextNumber: String
                            switch newPlayerJersey {
                                case "5", "15", "25", "35", "45" : nextNumber = String(Int(newPlayerJersey)! + 5)
                                default : nextNumber = String(Int(newPlayerJersey)! + 1)
                            }
                            newPlayerJersey = nextNumber
                            newPlayerFullname = ""
                            let playerToPersist = Player(context: viewContext)
                            playerToPersist.team = teamname
                            playerToPersist.fullname = newPlayerFullname
                            playerToPersist.jersey = newPlayerJersey
                            playerToPersist.id = UUID()
                            do {
                                try viewContext.save()
                            } catch {
                                // handle the Core Data error
                            }
                            
                        }.buttonStyle(.borderedProminent)
                    }
                }.fixedSize(horizontal: false, vertical: false)
            }
        )
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
