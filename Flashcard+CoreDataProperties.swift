//
//  Flashcard+CoreDataProperties.swift
//  Project
//
//  Created by  User on 15.05.2025.
//
//

import Foundation
import CoreData


extension Flashcard {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Flashcard> {
        return NSFetchRequest<Flashcard>(entityName: "Flashcard")
    }

    @NSManaged public var definition: String?
    @NSManaged public var id: UUID?
    @NSManaged public var term: String?
    @NSManaged public var definitionToLanguage: Language?
    @NSManaged public var flashcardToCourse: Course?
    @NSManaged public var termToLanguage: Language?
    @NSManaged public var createdAt: Date
    
    public var course: Course{
        let course = flashcardToCourse
        return course
    }
}

extension Flashcard : Identifiable {

}
