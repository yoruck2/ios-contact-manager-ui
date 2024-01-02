//
//  ContactManager.swift
//  ios-contact-manager-ui
//
//  Created by dopamint on 1/2/24.
//

import Foundation


struct ContactManager {
    
    private var contacts = [Contact]()
    
    
    mutating func addContact(contact: Contact) {
        contacts.append(contact)
    }
    
    mutating func deleteContact(contact: Contact) {
        contacts.removeAll(where: { $0.id == contact.id } )
    }
    
    mutating func editContact(contact: Contact) {
        contacts.map { $0.id == contact.id }
    }
}

