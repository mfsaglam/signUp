//
//  SignUpButtonCell.swift
//  signup
//
//  Created by Fatih Sağlam on 2.07.2022.
//

import UIKit

class SignUpButtonCell: UITableViewCell {

    let signUpButton = BigButton(color: .systemBlue, title: "Sign Up")
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            signUpButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            signUpButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            signUpButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            signUpButton.heightAnchor.constraint(equalTo: self.heightAnchor)
            
        ])
    }

}
