//
//  TermsAndConditionsCell.swift
//  signup
//
//  Created by Fatih Sağlam on 2.07.2022.
//

import UIKit

class TermsAndConditionsCell: UITableViewCell {
    
    let termsConditionsLabel = UILabel()
    let termsConditionsSwitch = UISwitch()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        termsConditionsLabel.translatesAutoresizingMaskIntoConstraints = false
        termsConditionsSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        termsConditionsSwitch.addTarget(self, action: #selector(agreeSwitchDidChange), for: .editingChanged)
        
        addSubview(termsConditionsLabel)
        addSubview(termsConditionsSwitch)
        
        termsConditionsLabel.text = "Terms and Conditions"
        
        NSLayoutConstraint.activate([
            termsConditionsSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            termsConditionsSwitch.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            termsConditionsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            termsConditionsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    @objc func agreeSwitchDidChange() {
        
    }
    
}
