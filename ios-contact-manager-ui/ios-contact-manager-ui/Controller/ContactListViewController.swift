//
//  ViewController.swift
//  ios-contact-manager-ui
//
//  Created by dopamint on 1/2/24.
//

import UIKit

final class ContactListViewController: UIViewController {
    
    @IBOutlet weak var contactTableView: UITableView!
    private var contactManager: ContactManager
    
    required init?(coder: NSCoder) {
        contactManager = ContactManager(contacts: [])
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contactTableView.dataSource = self
        self.contactTableView.delegate = self
        loadData()
    }
    
    private func loadData() {
        let jsonDecoder: JSONDecoder = JSONDecoder()
        guard
            let dataAsset: NSDataAsset = NSDataAsset(name: "contacts")
        else {
            return
        }
        
        do {
            self.contactManager.contacts = try jsonDecoder.decode([Contact].self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension ContactListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactManager.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier: String = "contactCell"
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let contact: Contact = contactManager.contacts[indexPath.row]
        cell.textLabel?.text = contact.nameAndAge
        cell.detailTextLabel?.text = contact.phoneNumber
        
        return cell
    }
}
