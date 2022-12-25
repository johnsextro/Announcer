//
//  Persistence.swift
//  Announcer
//
//  Created by John Sextro on 11/24/22.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show some error here
            }
        }
    }

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for index in 0..<15 {
            let homeplayer = Player(context: viewContext)
            homeplayer.id = UUID()
            homeplayer.jersey = "\(index)"
            homeplayer.name = "Webster Name\(index)"
            homeplayer.team = "Webster"
        }

        for index in 0..<15 {
            let guestplayer = Player(context: viewContext)
            guestplayer.id = UUID()
            guestplayer.jersey = "\(index)"
            guestplayer.name = "Fontbonne Name\(index)"
            guestplayer.team = "Fontbonne"
        }
        
        for index in 0..<15 {
            let umslplayer = Player(context: viewContext)
            umslplayer.id = UUID()
            umslplayer.jersey = "\(index)"
            umslplayer.name = "UMSL Name\(index)"
            umslplayer.team = "UMSL"
        }
        
        let webstermen = Team(context: viewContext)
        webstermen.id = UUID()
        webstermen.men = false
        webstermen.name = "Webster"
        webstermen.year = 2023
        webstermen.mascot = "Gorloks"
        
        let fontbonnemen = Team(context: viewContext)
        fontbonnemen.id = UUID()
        fontbonnemen.men = true
        fontbonnemen.name = "Fontbonne"
        fontbonnemen.year = 2022
        fontbonnemen.mascot = "Griffins"

        let umslmen = Team(context: viewContext)
        umslmen.id = UUID()
        umslmen.men = true
        umslmen.name = "UMSL"
        umslmen.year = 2022
        umslmen.mascot = "Tritons"
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Announcer")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
