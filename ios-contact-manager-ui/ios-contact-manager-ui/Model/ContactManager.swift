//
//  ContactManager.swift
//  ios-contact-manager-ui
//
//  Created by dopamint on 1/2/24.
//

import UIKit

final class ContactManager {
    var contacts: [Contact]
    
    var contactsCount: Int {
        return contacts.count
    }
    
    init(contacts: [Contact]) {
        self.contacts = contacts
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
        contacts.remove(at: index)
    }
    
    func editContact(contact: Contact) {
        let contactTdices = contacts.indices
        let willEditContactID = contactTdices.filter { contacts[$0].id == contact.id }
        willEditContactID.forEach { contacts[$0] = contact }
    }
}
