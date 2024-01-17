//
//  ContactManager.swift
//  ios-contact-manager-ui
//
//  Created by dopamint on 1/2/24.
//

import UIKit

final class ContactManager {
    
    // MARK: - Properties
    private var contacts: [Contact]
    private var filteredContacts: [Contact] = []
    
    var contactsCount: Int {
        return contacts.count
    }
    
    var filteredContactsCount: Int {
        return filteredContacts.count
    }
    
    var contactRow: Int {
        return contactsCount - 1
    }
    
    // MARK: - Init
    init(contacts: [Contact]) {
        self.contacts = contacts
    }
    
    // MARK: - Helper
    func contact(row: Int) -> Contact {
        return contacts[row]
    }
    
    func filteredContact(row: Int) -> Contact {
        return filteredContacts[row]
    }
    
    func loadData() {
        let jsonDecoder: JSONDecoder = JSONDecoder()
        guard
            let dataAsset: NSDataAsset = NSDataAsset(name: "contacts")
        else {
            return
        }
        do {
            contacts = try jsonDecoder.decode([Contact].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func addContact(contact: Contact) {
        contacts.append(contact)
    }
    
    func deleteContact(index: Int) {
        guard 
            !filteredContacts.isEmpty
        else {
            contacts.remove(at: index)
            return
        }
        let contactIndices = contacts.indices
        let indexOfContactToBeEdited = contactIndices.filter {
            guard let editingContact = contacts[safe: $0] else { return false }
            return editingContact.id == filteredContacts[index].id
        }
        indexOfContactToBeEdited.forEach { contacts.remove(at: $0) }
        filteredContacts.remove(at: index)
    }
    
    func editContact(contact: Contact) {
        let contactIndices = contacts.indices
        let indexOfContactToBeEdited = contactIndices.filter {
            guard let editingContact = contacts[safe: $0] else { return false }
            return editingContact.id == contact.id
        }
        indexOfContactToBeEdited.forEach { contacts[$0] = contact }
    }
    
    func filteredContacts(by searchText: String) {
        filteredContacts = contacts.filter { 
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
}

