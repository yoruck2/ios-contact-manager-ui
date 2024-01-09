//
//  ViewController.swift
//  ios-contact-manager-ui
//
//  Created by dopamint on 1/2/24.
//

import UIKit

final class ContactListViewController: UIViewController {
    
    @IBOutlet weak private var contactTableView: UITableView!
    private var contactManager: ContactManager
    
    required init?(coder: NSCoder) {
        contactManager = ContactManager(contacts: [])
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        contactManager.loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: Notification.Name("updateUI"), object: nil)
    }
    
    private func setupTableView() {
        contactTableView.dataSource = self
        contactTableView.delegate = self
    }
    
    @objc
    private func updateUI() {
        contactTableView.reloadData()
    }
    
    @IBAction private func tappedAddContatctButton(_ sender: UIBarButtonItem) {
        guard
            let addContactViewController = storyboard?.instantiateViewController(identifier: AddContactViewController.identifier, creator: { coder in
                return AddContactViewController(contactManager: self.contactManager, coder: coder)
            })
        else {
            return
        }
        present(addContactViewController, animated: true)
    }
}

extension ContactListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactManager.contactsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell: ContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier) as? ContactTableViewCell
        else {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier, for: indexPath)
            cell.textLabel?.text = "내용을 불러오는데 실패했습니다."
            return cell
        }
        let contact = contactManager.contact(row: indexPath.row)
        cell.setUpCell(with: contact)
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _ , _, success in
            guard let self else { return }
            contactManager.deleteContact(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            success(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
