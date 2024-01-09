//
//  ContactTableViewCell.swift
//  ios-contact-manager-ui
//
//  Created by dopamint on 1/5/24.
//

import UIKit

final class ContactTableViewCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var subtitleLabel: UILabel!
    
    func setUpCell(with: Contact) {
        titleLabel.text = with.nameAndAge
        subtitleLabel.text = with.phoneNumber
    }
}
