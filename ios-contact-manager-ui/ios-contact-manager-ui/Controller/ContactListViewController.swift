//
//  ViewController.swift
//  ios-contact-manager-ui
//
//  Created by dopamint on 1/2/24.
//

import UIKit

final class ContactListViewController: UIViewController, UpdateContactDelegate {
    
    // MARK: - Properties
    @IBOutlet weak private var contactTableView: UITableView!
    private var contactManager: ContactManager
    
    // MARK: - Init
    required init?(coder: NSCoder) {
        contactManager = ContactManager(contacts: [])
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        contactManager.loadData()
    }
    
    // MARK: - Helper
    private func setupTableView() {
        contactTableView.dataSource = self
        contactTableView.delegate = self
    }
    
    func updateTableView() {
        contactTableView.reloadData()
    }
    
    @IBAction private func tappedAddContactButton(_ sender: UIBarButtonItem) {
        guard
            let addContactViewController = storyboard?.instantiateViewController(identifier: AddContactViewController.identifier, creator: { coder in
                return AddContactViewController(contactManager: self.contactManager, delegate: self, coder: coder)
            })
        else {
            return
        }
        // let addContactViewController = AddContactViewController() 와 같은 구조.. ContactList뷰컨에서 인스턴스를 생성하고 있기 때문에 참조관계 발생 ( 강한참조 + 1)
        present(addContactViewController, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension ContactListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactManager.contactsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell: ContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier) as? ContactTableViewCell
        else {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewErrorCell.identifier, 
                                                                      for: indexPath)
            cell.textLabel?.text = "내용을 불러오는데 실패했습니다."
            return cell
        }
        let contact = contactManager.contact(row: indexPath.row)
        cell.setUpCell(with: contact)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ContactListViewController: UITableViewDataSource {
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
