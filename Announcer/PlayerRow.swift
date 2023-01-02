//
//  PlayerRow.swift
//  Announcer
//
//  Created by John Sextro on 12/27/22.
//

import SwiftUI
import CoreData

struct PlayerRow : View {
    @State var playerItem: Person
    @State var home: Bool
    
    @Binding var team: [Person]
    @Binding var activeQuarter: Int
    @Binding var teamFouls: [String: [Int]]
    
    private func foulEvent(home: Bool, incValue: Int) {
        playerItem.personalFouls += incValue
        if home {
            teamFouls["home"]![activeQuarter] += incValue
        } else {
            teamFouls["guest"]![activeQuarter] += incValue
        }
    }
    
    var body: some View {
        HStack {
            Text(playerItem.jerseyNumber).frame(width: 45)
            Text(playerItem.fullName).frame(minWidth: 100, idealWidth: 200, maxWidth: 400, alignment: .leading)
            Image(systemName: "minus.square.fill").onTapGesture {
                foulEvent(home: home, incValue: -1)
            }
            Text(String(playerItem.personalFouls))
            Image(systemName: "plus.square.fill").onTapGesture {
                foulEvent(home: home, incValue: 1)
            }
        }.swipeActions(allowsFullSwipe: false) {
            Button {

            } label: {
                Label("Mute", systemImage: "pencil")
            }
            .tint(.orange)
            
            Button(role: .destructive) {
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
    }
}
