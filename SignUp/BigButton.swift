//
//  BigButton.swift
//  signup
//
//  Created by Fatih Sağlam on 2.07.2022.
//

import UIKit

class BigButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(color: UIColor, title: String) {
            super.init(frame: .zero)
            setTitle(title, for: .normal)
            backgroundColor = color
            configure()
        }
    
    private func configure() {
        layer.cornerRadius = 10
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
