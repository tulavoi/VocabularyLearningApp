//
//  CourseViewModel.swift
//  Project
//
//  Created by  User on 05.05.2025.
//

import Foundation
import CoreData

class CourseViewModel: ObservableObject {
    @Published var openAddCourse: Bool = false
    @Published var openCourseDetail: Bool = false
    
    @Published var courseTitle: String = ""
    @Published var createdAt: Date = Date()
    @Published var selectedCourse: Course? = nil
    
    @Published var flashcards: [FlashcardViewModel] = []
    
    @Published var termLanguage: Language? = nil
    @Published var definitionLanguage: Language? = nil
    
    func addFlashcardViewModel() {
        flashcards.append(FlashcardViewModel())
    }
    
    func removeFlashcardViewModel(at index: Int) {
        flashcards.remove(at: index)
    }
    
    init(){
        // Tạo sẵn 2 flashcard cho user nhập
        addFlashcardViewModel()
        addFlashcardViewModel()
    }
    
    // Tạo mới học phần
    func addCourse(context: NSManagedObjectContext) -> Bool{
        let newCourse = Course(context: context)
        newCourse.id = UUID()
        newCourse.title = courseTitle
        newCourse.createdAt = createdAt
        
        for flashcardModel in flashcards {
            flashcardModel.addFlashcard(context: context, course: newCourse, termLanguage: termLanguage, definitionLanguage: definitionLanguage)
        }

        if let _ = try? context.save() {
            return true
        }
        return false
    }
    
    func deleteCourse(context: NSManagedObjectContext, course: Course) -> Bool {
        context.delete(course)
        
        if let _ = try? context.save() {
            return true
        }
        return false
    }
    
    func validateCourseCreation() -> String? {
        if courseTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return "Thêm tiêu đề để hoàn thành học phần"
        }

        if termLanguage == nil && definitionLanguage == nil {
             return "Bạn cần chọn ngôn ngữ cho thuật ngữ và định nghĩa"
        } else if termLanguage == nil {
            return "Bạn cần chọn ngôn ngữ cho thuật ngữ"
        } else if definitionLanguage == nil {
            return "Bạn cần chọn ngôn ngữ cho định nghĩa."
        }

        return nil
    }
}
