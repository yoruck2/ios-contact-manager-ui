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
        if filteredContacts.isEmpty {
            contacts.remove(at: index)
        } else {
            let contactIndices = contacts.indices
            let indexOfContactToBeDeleted = contactIndices.filter {
                filterdContactIDMatches(contact: filteredContact(row: index), at: $0)
            }
            updateContacts(at: indexOfContactToBeDeleted) { [weak self] in
                self?.contacts.remove(at: $0)
                self?.filteredContacts.remove(at: $0)
            }
        }
    }
    
    func editContact(contact: Contact) {
        let contactIndices = contacts.indices
        let indexOfContactToBeEdited: [Int]
        
        if filteredContacts.isEmpty {
            indexOfContactToBeEdited = contactIndices.filter {
                filterdContactIDMatches(contact: contact, at: $0)
            }
            updateContacts(at: indexOfContactToBeEdited) { [weak self] in
                self?.contacts[$0] = contact
            }
        } else {
            indexOfContactToBeEdited = contactIndices.filter {
                filterdContactIDMatches(contact: contact, at: $0) &&
                originContactIDMatches(contact: contact, at: $0)
            }
            updateContacts(at: indexOfContactToBeEdited) { [weak self] in
                self?.filteredContacts[$0] = contact
                self?.contacts[$0] = contact
            }
        }
    }
    
    func filterContacts(by searchText: String) {
        filteredContacts = contacts.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
}

// MARK: - Private Methods
extension ContactManager {
    private func filterdContactIDMatches(contact: Contact, at index: Int) -> Bool {
        guard let filteredContact = filteredContacts.isEmpty ? contacts[safe: index] : filteredContacts[safe: index] else { return false }
        return filteredContact.id == contact.id
    }
    
    private func originContactIDMatches(contact: Contact, at index: Int) -> Bool {
        guard let originContact = contacts[safe: index] else { return false }
        return originContact.id == contact.id
    }
    
    private func updateContacts(at indices: [Int], completion: ((_ index: Int) -> Void)? = nil) {
        indices.forEach { completion?($0) }
    }
    
    private func updateFilteredContacts(at indices: [Int], with contact: Contact) {
        indices.forEach { filteredContacts[$0] = contact }
    }
}
