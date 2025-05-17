//
//  Course+CoreDataProperties.swift
//  Project
//
//  Created by  User on 15.05.2025.
//
//

import Foundation
import CoreData

extension Course {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
        return NSFetchRequest<Course>(entityName: "Course")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var title: String?
    @NSManaged public var id: UUID?
    @NSManaged public var lastViewedFlashcardId: UUID?
    @NSManaged public var courseToFlashcard: Set<Flashcard>?

    public var flashcards: [Flashcard]{
        guard let set = courseToFlashcard else { return [] }

        return set.sorted { (card1, card2) in
            let date1 = card1.createdAt ?? .distantPast // Nếu card1.createdAt là nil, dùng .distantPast
            let date2 = card2.createdAt ?? .distantPast // Nếu card2.createdAt là nil, dùng .distantPast
            return date1 < date2 // So sánh hai giá trị Date không optional
        }
    }
}

// MARK: Generated accessors for courseToFlashcard
extension Course {

    @objc(addCourseToFlashcardObject:)
    @NSManaged public func addToCourseToFlashcard(_ value: Flashcard)

    @objc(removeCourseToFlashcardObject:)
    @NSManaged public func removeFromCourseToFlashcard(_ value: Flashcard)

    @objc(addCourseToFlashcard:)
    @NSManaged public func addToCourseToFlashcard(_ values: NSSet)

    @objc(removeCourseToFlashcard:)
    @NSManaged public func removeFromCourseToFlashcard(_ values: NSSet)

}

extension Course : Identifiable {

}
