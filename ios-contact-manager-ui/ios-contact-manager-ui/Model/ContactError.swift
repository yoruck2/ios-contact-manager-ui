//
//  ContactError.swift
//  ios-contact-manager-ui
//
//  Created by 강창현 on 1/9/24.
//

import Foundation

enum ContactError: LocalizedError {
    case nameInputError
    case ageInputError
    case phoneNumberInputError
    
    var errorDescription: String? {
        switch self {
        case .nameInputError:
            return "입력한 이름 정보가 잘못되었습니다"
        case .ageInputError:
            return "입력한 나이 정보가 잘못되었습니다"
        case .phoneNumberInputError:
            return "입력한 연락처 정보가 잘못되었습니다"
        }
    }
}
