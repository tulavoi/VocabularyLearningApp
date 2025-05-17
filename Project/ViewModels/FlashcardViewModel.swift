//
//  FlashcardViewModel.swift
//  Project
//
//  Created by  User on 08.05.2025.
//

import Foundation
import CoreData

class FlashcardViewModel: ObservableObject {
    @Published var id = UUID()
    @Published var term: String = ""
    @Published var definition: String = ""
    @Published var createdAt: Date = Date()
    
    // MARK: Thêm flashcard
    func addFlashcard(context: NSManagedObjectContext, course: Course, termLanguage: Language?, definitionLanguage: Language?) {
        guard !term.isEmpty, !definition.isEmpty else { return }

        let flashcard = Flashcard(context: context)
        flashcard.id = UUID()
        flashcard.term = term
        flashcard.definition = definition
        flashcard.createdAt = createdAt
        flashcard.flashcardToCourse = course
        flashcard.termToLanguage = termLanguage
        flashcard.definitionToLanguage = definitionLanguage
    }
}
