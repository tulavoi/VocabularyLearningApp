//
//  LanguageViewModel.swift
//  Project
//
//  Created by  User on 07.05.2025.
//

import Foundation
import CoreData

class LanguageViewModel: ObservableObject {
    @Published var openChooseLanguage: Bool = false
    @Published var choosingForTerm: Bool = true
    @Published var languages: [Language] = []
    
    // Context thao tác với Core Data (được inject từ bên ngoài)
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        preloadLanguagesIfNeeded()
        fetchLanguages()
    }
    
    // Lấy dữ liệu Language từ Core Data và cập nhật lên biến published
    func fetchLanguages() {
        let request: NSFetchRequest<Language> = Language.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Language.name, ascending: true)]
        do {
            languages = try context.fetch(request)
        } catch {
            print("Error fetching languages: \(error)")
        }
    }
    
    // Tạo dữ liệu mặc định nếu chưa có
    func preloadLanguagesIfNeeded(){
        let request: NSFetchRequest<Language> = Language.fetchRequest()
        request.fetchLimit = 1
        do {
            let count = try context.count(for: request)
            if count == 0 {
                let defaultLanguages = [
                    ("Tiếng Việt", "vi"),
                    ("Tiếng Anh", "en"),
                    ("Tiếng Nhật", "ja"),
                    ("Tiếng Hàn", "ko"),
                    ("Tiếng Pháp", "fr"),
                    ("Tiếng Trung", "zh"),
                    ("Tiếng Ý", "it"),
                    ("Tiếng Nga", "ru"),
                    ("Tiếng Đức", "de")
                ]
                
                // Tạo đối tượng Language và gán thuộc tính
                for (name, code) in defaultLanguages {
                    let lang = Language(context: context)
                    lang.name = name
                    lang.code = code
                }
                
                // Lưu vào Core Data và cập nhật danh sách
                try context.save()
                fetchLanguages()
            }
        }
        catch {
            print("Error preloading languages: \(error)")
        }
    }
}

