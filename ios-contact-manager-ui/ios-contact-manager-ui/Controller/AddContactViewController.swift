//
//  AddContatctViewController.swift
//  ios-contact-manager-ui
//
//  Created by 강창현 on 1/8/24.
//

import UIKit

final class AddContactViewController: UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
    private let contactManager: ContactManager
    
    @IBOutlet weak private var nameTextField: UITextField!
    @IBOutlet weak private var ageTextField: UITextField!
    @IBOutlet weak private var phoneNumberTextField: UITextField!
    
    init?(contactManager: ContactManager, coder: NSCoder) {
        self.contactManager = contactManager
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextField()
    }
    
    private func setUpTextField() {
        nameTextField.keyboardType = .default
        ageTextField.keyboardType = .numberPad
        phoneNumberTextField.keyboardType = .numberPad
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
            dismiss(animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("updateUI"), object: nil)
        case .failure(let error):
            makeAlert(message: error.localizedDescription,
                      actions: [UIAlertAction(title: "확인",
                                              style: .default)])
        }
    }
}

extension AddContactViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}