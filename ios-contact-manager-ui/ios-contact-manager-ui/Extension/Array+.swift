//
//  Array+.swift
//  ios-contact-manager-ui
//
//  Created by 강창현 on 1/11/24.
//

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
