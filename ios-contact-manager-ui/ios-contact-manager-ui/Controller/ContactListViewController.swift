//
//  ViewController.swift
//  ios-contact-manager-ui
//
//  Created by dopamint on 1/2/24.
//

import UIKit

final class ContactListViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak private var contactTableView: UITableView!
    
    private var contactManager: ContactManager
    private var isFiltered: Bool = false
    
    // MARK: - Init
    required init?(coder: NSCoder) {
        contactManager = ContactManager(contacts: [])
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setUpSearch()
        contactManager.loadData()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTableView),
                                               name: .updateContactUI,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    // MARK: - Helper
    
    private func setUpSearch() {
        let contactSearchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = contactSearchController
        navigationItem.hidesSearchBarWhenScrolling = false
        contactSearchController.searchBar.delegate = self
        contactSearchController.searchBar.placeholder = "이름을 입력해주세요."
    }
    
    private func setupTableView() {
        contactTableView.dataSource = self
        contactTableView.delegate = self
    }
    
    @objc
    private func updateTableView() {
        contactTableView.insertRows(at: [IndexPath(row: contactManager.contactRow,
                                                   section: 0)],
                                    with: .automatic)
    }
    
    @IBAction private func tappedAddContactButton(_ sender: UIBarButtonItem) {
        guard
            let contactManageViewController = storyboard?.instantiateViewController(identifier: ContactManageViewController.identifier,
                                                                                 creator: { coder in
                return ContactManageViewController(contactManager: self.contactManager,
                                                   navigationBarTitle: "새 연락처", coder: coder)
            })
        else {
            return
        }
        present(contactManageViewController, animated: true)
    }
}

// MARK: - UITableViewDelegate
extension ContactListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltered ? contactManager.filteredContactsCount : contactManager.contactsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell: ContactTableViewCell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier,
                                                                           for: indexPath) as? ContactTableViewCell
        else {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewErrorCell.identifier,
                                                                      for: indexPath)
            cell.textLabel?.text = "내용을 불러오는데 실패했습니다."
            return cell
        }
        let contact = isFiltered ? contactManager.filteredContact(row: indexPath.row) : contactManager.contact(row: indexPath.row)
        cell.setUpCell(with: contact)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let contactManageViewController = storyboard?.instantiateViewController(identifier: ContactManageViewController.identifier,
                                                                                    creator: { coder in
                return ContactManageViewController(contactManager: self.contactManager, contact: self.contactManager.contact(row: indexPath.row), navigationBarTitle: "연락처 변경", coder: coder)
            })
        else {
            return
        }
        navigationController?.pushViewController(contactManageViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource
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

// MARK: - UISearchBarDelegate
extension ContactListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchText.lowercased()
        isFiltered = !text.isEmpty
        contactManager.filteredContacts(by: text)
        contactTableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFiltered = false
        contactTableView.reloadData()
    }
}
