//
//  TermsAndConditionsCell.swift
//  signup
//
//  Created by Fatih Sağlam on 2.07.2022.
//

import UIKit

protocol TermsAndConditionsCellDelegate: AnyObject {
    func didSwitchTapped()
}

class TermsAndConditionsCell: UITableViewCell {
    
    let termsConditionsLabel = UILabel()
    let termsConditionsSwitch = UISwitch()
    
    weak var delegate: TermsAndConditionsCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        selectionStyle = .none
        termsConditionsLabel.translatesAutoresizingMaskIntoConstraints = false
        termsConditionsSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        termsConditionsSwitch.addTarget(self, action: #selector(agreeSwitchDidChange), for: .touchUpInside)
        
        contentView.addSubview(termsConditionsLabel)
        contentView.addSubview(termsConditionsSwitch)
        
        termsConditionsLabel.text = "I agree to the Terms"
        
        NSLayoutConstraint.activate([
            termsConditionsSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            termsConditionsSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            termsConditionsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            termsConditionsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    @objc func agreeSwitchDidChange() {
        delegate?.didSwitchTapped()
    }
    
}
