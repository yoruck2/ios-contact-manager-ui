//
//  InputValidator.swift
//  ios-contact-manager-ui
//
//  Created by 강창현 on 1/9/24.
//

import UIKit

struct InputValidator {
    
    // MARK: - Helper
    func validateInput(nameTextField: UITextField,
                       ageTextField: UITextField,
                       phoneNumberTextField: UITextField) -> Result<Contact, Error> {
        do {
            let name = try validateNameInput(nameTextField: nameTextField)
            let age = try validateAgeInput(ageTextField: ageTextField)
            let phoneNumber = try validatePhoneNumberInput(phoneNumberTextField: phoneNumberTextField)
            return .success(Contact(name: name, phoneNumber: phoneNumber, age: age))
        } catch {
            return .failure(error)
        }
    }
    
    private func validateNameInput(nameTextField: UITextField) throws -> String {
        guard
            let name = nameTextField.text,
            name.isEmpty == false
        else {
            throw ContactError.nameInputError
        }
        let trimmedName = name.replacingOccurrences(of: " ", with: "")
        return trimmedName
    }
    
    private func validateAgeInput(ageTextField: UITextField) throws -> Int {
        guard
            let age = ageTextField.text,
            let convertAgeToInt = UInt(age),
            convertAgeToInt < 1000
        else {
            throw ContactError.ageInputError
        }
        return Int(convertAgeToInt)
    }
    
    private func validatePhoneNumberInput(phoneNumberTextField: UITextField) throws -> String {
        guard
            let phoneNumber = phoneNumberTextField.text,
            !phoneNumber.isEmpty,
            phoneNumber.count >= 9
        else {
            throw ContactError.phoneNumberInputError
        }
        return phoneNumber
    }
}
