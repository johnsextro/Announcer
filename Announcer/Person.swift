//
//  Person.swift
//  Announcer
//
//  Created by John Sextro on 12/21/22.
//

import Foundation

struct Person: Identifiable {
    var fullName: String
    var jerseyNumber: String
    var id: UUID
    var personalFouls: Int
}
