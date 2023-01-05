//
//  PlayerRow.swift
//  Announcer
//
//  Created by John Sextro on 12/27/22.
//

import SwiftUI
import CoreData

struct PlayerRow : View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var playerItem: Person
    @State var player: Player
    @State var isHomeTeam: Bool
    @State var isEditMode: Bool = false
    
    @Binding var team: [Person]
    @Binding var activeQuarter: Int
    @Binding var teamFouls: [String: [Int]]

    
    private func foulEvent(incValue: Int) {
        playerItem.personalFouls += incValue
        if isHomeTeam {
            teamFouls["home"]![activeQuarter] += incValue
        } else {
            teamFouls["guest"]![activeQuarter] += incValue
        }
    }
    
    var body: some View {
        HStack {
            if (isEditMode) {
                TextField("Jersey", text: $playerItem.jerseyNumber).textFieldStyle(.roundedBorder).keyboardType(.numberPad).frame(width: 45)
                TextField("Name", text: $playerItem.fullName).textFieldStyle(.roundedBorder).disableAutocorrection(true).frame(minWidth: 100, idealWidth: 200, maxWidth: 400, alignment: .leading).submitLabel(.done).onSubmit {
                    do {
                        self.isEditMode = false
                        player.jersey = playerItem.jerseyNumber
                        player.name = playerItem.fullName
                        try viewContext.save()
                    } catch {
                        self.isEditMode = false
                    }
                }
            } else {
                Text(playerItem.jerseyNumber).frame(width: 45)
                Text(playerItem.fullName).frame(minWidth: 100, idealWidth: 200, maxWidth: 400, alignment: .leading)
                Image(systemName: "minus.square.fill").onTapGesture {
                    foulEvent(incValue: -1)
                }
                Text(String(playerItem.personalFouls))
                Image(systemName: "plus.square.fill").onTapGesture {
                    foulEvent(incValue: 1)
                }
            }

        }.swipeActions(allowsFullSwipe: false) {
            Button {
                self.isEditMode = true
            } label: {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.blue)
            
            Button(role: .destructive) {
                team.removeAll(where: {$0.id == player.id})
                viewContext.delete(player)
                do {
                    try viewContext.save()
                } catch {
                    // handle the Core Data error
                }
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
    }
}
