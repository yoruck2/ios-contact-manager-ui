//
//  AddContatctViewController.swift
//  ios-contact-manager-ui
//
//  Created by 강창현 on 1/8/24.
//

import UIKit

class ContactManageViewController: UIViewController {
    
    // MARK: - Properties
    static var identifier: String {
        return String(describing: self)
    }
    private let contactManager: ContactManager
    private let contact: Contact?
    private let navigationBarTitle: String?
    
    @IBOutlet weak var contactNavigationItem: UINavigationItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    // MARK: - Init
    init?(contactManager: ContactManager, contact: Contact? = nil, navigationBarTitle: String, coder: NSCoder) {
        self.contactManager = contactManager
        self.contact = contact
        self.navigationBarTitle = navigationBarTitle
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contactNavigationItem.title = navigationBarTitle
    }
    
    // MARK: - Helper
    func setUpTextField() {
        
        nameTextField.keyboardType = .default
        ageTextField.keyboardType = .numberPad
        phoneNumberTextField.keyboardType = .phonePad
        phoneNumberTextField.addTarget(self, 
                                       action: #selector(phoneNumberTextFieldEditingChanged),
                                       for: .editingChanged)
        guard let contact = contact else { return }
        nameTextField.text = contact.name
        ageTextField.text = String(contact.age)
        phoneNumberTextField.text = contact.phoneNumber
    }
    
    @objc
    private func phoneNumberTextFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text?.replacingOccurrences(of: "-", with: "") else { return }
        textField.text = text.formattingPhoneNumber()
    }
    
    @IBAction private func tappedCancelButton(_ sender: UIBarButtonItem) {
        makeAlert(message: "정말로 취소하시겠습니까?",
                  actions: [
                    UIAlertAction(title: "아니오",
                                  style: .cancel),
                    UIAlertAction(title: "예",
                                  style: .destructive,
                                  handler: { [weak self] _ in
                                      guard let self else { return }
                                      guard contact != nil else {
                                          dismiss(animated: true)
                                          return
                                      }
                                      navigationController?.popViewController(animated: true)
                                  })
                  ])
    }
    
    @IBAction private func tappedSaveButton(_ sender: UIBarButtonItem) {
        let inputValidator = InputValidator()
        let validation = inputValidator.validateInput(nameTextField: nameTextField,
                                                      ageTextField: ageTextField,
                                                      phoneNumberTextField: phoneNumberTextField)
        switch validation {
        case .success(var newContact):
            guard let contact = contact else {
                contactManager.addContact(contact: newContact)
                dismiss(animated: true) {
                    NotificationCenter.default.post(name: .updateContactUI,
                                                    object: nil)
                }
                return
            }
            newContact.id = contact.id
            contactManager.editContact(contact: newContact)
            navigationController?.popViewController(animated: true)
            
        case .failure(let error):
            makeAlert(message: error.localizedDescription,
                      actions: [UIAlertAction(title: "확인",
                                              style: .default)])
        }
    }
}
