//
//  Course.swift
//  Project
//
//  Created by  User on 08.05.2025.
//

import Foundation
import CoreData

class Course: NSManagedObject, Identifiable{
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var createdAt: Date
    
    @NSManaged public var flashcards: Set<Flashcard>
}
