//
//  String+.swift
//  ios-contact-manager-ui
//
//  Created by 강창현 on 1/12/24.
//

extension String {
    var formattedPhoneNumber: String {
        let count = self.count
        let divider: Character = "-"
        var phoneNumber = self
        
        if phoneNumber.hasPrefix("02") {
            switch count {
            case 3...5:
                phoneNumber.insert(divider, at: phoneNumber.index(phoneNumber.startIndex, offsetBy: 2))
            case 6...9:
                phoneNumber.insert(divider, at: phoneNumber.index(phoneNumber.startIndex, offsetBy: 2))
                phoneNumber.insert(divider, at: phoneNumber.index(phoneNumber.endIndex, offsetBy: 5 - count))
            case 10:
                phoneNumber.insert(divider, at: phoneNumber.index(phoneNumber.startIndex, offsetBy: 2))
                phoneNumber.insert(divider, at: phoneNumber.index(phoneNumber.endIndex, offsetBy: -4))
            default:
                break
            }
        } else if phoneNumber.hasPrefix("15") || phoneNumber.hasPrefix("16") || phoneNumber.hasPrefix("18") {
            switch count {
            case 5...9:
                phoneNumber.insert(divider, at: phoneNumber.index(phoneNumber.startIndex, offsetBy: 4))
            default:
                break
            }
        } else {
            switch count {
            case 4...6:
                phoneNumber.insert(divider, at: phoneNumber.index(phoneNumber.startIndex, offsetBy: 3))
            case 7...10:
                phoneNumber.insert(divider, at: phoneNumber.index(phoneNumber.startIndex, offsetBy: 3))
                phoneNumber.insert(divider, at: phoneNumber.index(phoneNumber.endIndex, offsetBy: 6 - count))
            case 11:
                phoneNumber.insert(divider, at: phoneNumber.index(phoneNumber.startIndex, offsetBy: 3))
                phoneNumber.insert(divider, at: phoneNumber.index(phoneNumber.endIndex, offsetBy: -4))
            default:
                break
            }
        }
        
        return phoneNumber
    }
}
