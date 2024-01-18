//
//  TypeIdentifiable.swift
//  ios-contact-manager-ui
//
//  Created by 강창현 on 1/17/24.
//

import Foundation

protocol TypeIdentifiable {
    static var identifier: String { get }
}

extension TypeIdentifiable {
    static var identifier: String {
        return String(describing: self)
    }
}
