//
//  PlayerRow.swift
//  Announcer
//
//  Created by John Sextro on 12/27/22.
//

import SwiftUI
import CoreData

struct PlayerRow : View {
    let playerItem: Person
    var foulEvent: ((UUID) -> Void)

    var body: some View {
        HStack {
            Text(playerItem.jerseyNumber).frame(width: 45)
            Text(playerItem.fullName).frame(minWidth: 100, idealWidth: 200, maxWidth: 400, alignment: .leading)
            Image(systemName: "minus.square.fill").onTapGesture {
                foulEvent(playerItem.id)
            }
            Text(String(playerItem.personalFouls))
            Image(systemName: "plus.square.fill")
        }
    }
}
