//
//  AddContatctViewController.swift
//  ios-contact-manager-ui
//
//  Created by 강창현 on 1/8/24.
//

import UIKit

final class AddContactViewController: UIViewController, TypeIdentifiable {
    
    // MARK: - Properties
    
    private let contactManager: ContactManager
    
    @IBOutlet weak private var nameTextField: UITextField!
    @IBOutlet weak private var ageTextField: UITextField!
    @IBOutlet weak private var phoneNumberTextField: UITextField!
    
    // MARK: - Init
    init?(contactManager: ContactManager, coder: NSCoder) {
        self.contactManager = contactManager
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
    
    // MARK: - Helper
    private func setUpTextField() {
        nameTextField.keyboardType = .default
        ageTextField.keyboardType = .numberPad
        phoneNumberTextField.keyboardType = .phonePad
        phoneNumberTextField.addTarget(self, 
                                       action: #selector(phoneNumberTextFieldEditingChanged),
                                       for: .editingChanged)
    }
    
    @objc 
    private func phoneNumberTextFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text?.replacingOccurrences(of: "-", with: "") else { return }
        textField.text = text.formattedPhoneNumber
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
                                      dismiss(animated: true)})
                  ])
    }
    
    @IBAction private func tappedSaveButton(_ sender: UIBarButtonItem) {
        let inputValidator = InputValidator()
        let validation = inputValidator.validateInput(nameTextField: nameTextField,
                                                      ageTextField: ageTextField,
                                                      phoneNumberTextField: phoneNumberTextField)
        switch validation {
        case .success(let contact):
            contactManager.addContact(contact: contact)
            dismiss(animated: true) {
                NotificationCenter.default.post(name: .updateContactUI, 
                                                object: nil)
            }
        case .failure(let error):
            makeAlert(message: error.localizedDescription,
                      actions: [UIAlertAction(title: "확인",
                                              style: .default)])
        }
    }
}
