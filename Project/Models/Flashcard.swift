//
//  Flashcard.swift
//  Project
//
//  Created by  User on 08.05.2025.
//

import Foundation
import CoreData

class Flashcard: NSManagedObject, Identifiable{
    @NSManaged public var id: UUID
    @NSManaged public var term: String
    @NSManaged public var definition: String
    
    @NSManaged public var course: Course
    
    @NSManaged public var termLanguage: Language
    @NSManaged public var definitionLanguage: Language
}
