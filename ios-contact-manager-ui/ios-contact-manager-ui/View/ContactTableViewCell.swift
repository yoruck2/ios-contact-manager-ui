//
//  ContactTableViewCell.swift
//  ios-contact-manager-ui
//
//  Created by dopamint on 1/5/24.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    static let identifier: String = "contactCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    func setUpCell(contact: Contact) {
        titleLabel.text = contact.nameAndAge
        subtitleLabel.text = contact.phoneNumber
    }
}
