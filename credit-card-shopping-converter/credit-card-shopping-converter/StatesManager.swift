//
//  EstatesManager.swift
//  credit-card-shopping-converter
//
//  Created by Marcos Matsuda on 30/08/2018.
//  Copyright © 2018 Marcos Matsuda. All rights reserved.
//
import CoreData

class StatesManager{
    
    static let shared = StatesManager()
    var states: [States] = []
    
    func loadStates(with context: NSManagedObjectContext){
        
        let fetchRequest: NSFetchRequest<States> = States.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            states = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteStates(index: Int, context: NSManagedObjectContext ){
        let state = states[index]
        context.delete(state)
        do{
            try context.save()
        }catch{
            print(error.localizedDescription)
        }
    }
    

}

