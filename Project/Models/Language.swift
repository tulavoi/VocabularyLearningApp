//
//  Language.swift
//  Project
//
//  Created by  User on 07.05.2025.
//

import Foundation
import CoreData

class Language: NSManagedObject, Identifiable {
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var code: String
}
