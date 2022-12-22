//
//  AddPlayerView.swift
//  Announcer
//
//  Created by John Sextro on 12/21/22.
//

import SwiftUI

struct AddPlayerView: View {

    @State private var newPlayerJersey = ""
    @State private var newPlayerFullname = ""
    
    @Binding var team: [Person]
    
    var body: some View {
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
                            team.append(Person(fullName: newPlayerFullname, jerseyNumber: newPlayerJersey, personalFouls: 0, edit: false))
                            var nextNumber: String
                            switch newPlayerJersey {
                                case "5", "15", "25", "35", "45" : nextNumber = String(Int(newPlayerJersey)! + 5)
                                default : nextNumber = String(Int(newPlayerJersey)! + 1)
                            }
                            newPlayerJersey = nextNumber
                            newPlayerFullname = ""
                        }.buttonStyle(.borderedProminent)
                    }
                }.fixedSize(horizontal: false, vertical: false)
            }
        )
    }
}

struct AddPlayerView_Previews: PreviewProvider {
    @State static var previewteam: [Person] = []

    static var previews: some View {
        HStack {
            AddPlayerView(team: $previewteam)
        }
    }
}
