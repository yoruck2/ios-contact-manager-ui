//
//  Contact.swift
//  ios-contact-manager-ui
//
//  Created by dopamint on 1/2/24.
//

import Foundation

struct Contact: Decodable {
    
    // MARK: - Properties
    var id = UUID().uuidString
    let name: String
    let phoneNumber: String
    let age: Int
    
    var nameAndAge: String {
        return self.name + "(\(self.age))"
    }
}
