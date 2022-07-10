//
//  ViewController.swift
//  signup
//
//  Created by Fatih Sağlam on 2.07.2022.
//

import UIKit
import Combine

//SIGN UP FORM RULES
// -email adress must be valid (contain @ and .)
// -password must be at least 8 characters
// -password can not be 'password'
// -password confirmation must match
// -must agree to terms
// -BONUS: - email adress must remove spaces, lowercased

class SignUpViewController: UITableViewController {
    
    var emailAdressCell = UITableViewCell()
    var passwordCell = UITableViewCell()
    var passwordConfirmationCell = UITableViewCell()
    var agreeTermsCell = TermsAndConditionsCell()
    var signUpButtonCell = SignUpButtonCell()
    
    var emailAdressField = UITextField()
    var passwordField = UITextField()
    var passwordConfirmationField = UITextField()
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Subjects
    
    private var emailSubject = CurrentValueSubject<String, Never>("")
    private var passwordSubject = CurrentValueSubject<String, Never>("")
    private var passwordConfirmationSubject = CurrentValueSubject<String, Never>("")
    private var agreeToTermsSubject = CurrentValueSubject<Bool, Never>(false)
    
    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    private func emailIsValid(_ email: String) -> Bool {
        email.contains("@") && email.contains(".")
    }
    
    //Publishers
    
    private var formIsValid: AnyPublisher<Bool, Never> {
        emailIsValid
    }
    
    private var emailIsValid: AnyPublisher<Bool, Never> {
        emailSubject
            .map { [weak self] in self?.emailIsValid($0) }
            .replaceNil(with: false)
            .eraseToAnyPublisher()
    }
    
    @objc func emailDidChange() {
        emailSubject.send(emailAdressField.text ?? "")
    }
    
    @objc func passwordDidChange() {
        passwordSubject.send(passwordField.text ?? "")
    }
    
    @objc func passwordConfirmationDidChange() {
        passwordConfirmationSubject.send(passwordConfirmationField.text ?? "")
    }
    
    @objc func agreeSwitchDidChange() {
        agreeToTermsSubject.send(agreeTermsCell.termsConditionsSwitch.isOn)
    }
    
    private func configureTableView() {
        tableView.rowHeight = 44
        
        emailAdressCell.backgroundColor = .systemBackground
        passwordCell.backgroundColor = .systemBackground
        passwordConfirmationCell.backgroundColor = .systemBackground
        agreeTermsCell.backgroundColor = .systemBackground
        signUpButtonCell.backgroundColor = .systemBackground
        signUpButtonCell.delegate = self
        
        emailAdressField.frame = emailAdressCell.contentView.bounds.insetBy(dx: 15, dy: 0)
        passwordField.frame = passwordCell.contentView.bounds.insetBy(dx: 15, dy: 0)
        passwordConfirmationField.frame = passwordConfirmationCell.contentView.bounds.insetBy(dx: 15, dy: 0)
        
        emailAdressField.placeholder = "Email Adress"
        emailAdressField.autocorrectionType = .no
        emailAdressField.keyboardType = .emailAddress
        emailAdressField.autocapitalizationType = .none
        passwordField.placeholder = "Password"
        passwordField.autocorrectionType = .no
        passwordField.autocapitalizationType = .none
        passwordField.isSecureTextEntry = true
        passwordConfirmationField.placeholder = "Passsword Confirmation"
        passwordConfirmationField.autocorrectionType = .no
        passwordConfirmationField.autocapitalizationType = .none
        passwordConfirmationField.isSecureTextEntry = true
        
        emailAdressCell.addSubview(emailAdressField)
        passwordCell.addSubview(passwordField)
        passwordConfirmationCell.addSubview(passwordConfirmationField)
    }
    
    private func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        title = "Sign Up"
        
        emailAdressField.addTarget(self, action: #selector(emailDidChange), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
        passwordConfirmationField.addTarget(self, action: #selector(passwordConfirmationDidChange), for: .editingChanged)
        
        formIsValid
            .assign(to: \.isEnabled, on: signUpButtonCell.signUpButton)
            .store(in: &cancellables)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                return emailAdressCell
            case 1:
                return passwordCell
            case 2:
                return passwordConfirmationCell
            default:
                return emailAdressCell
            }
            
        case 1:
            switch indexPath.row {
            case 0:
                return agreeTermsCell
            default:
                return agreeTermsCell
            }
        case 2:
            switch indexPath.row {
            case 0:
                signUpButtonCell.delegate = self
                return signUpButtonCell
            default:
                return signUpButtonCell
            }
        default:
            return signUpButtonCell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "ENTER YOUR DETAILS"
        case 1:
            return "TERMS AND CONDITIONS"
        case 2:
            return ""
        default:
            return ""
        }
    }
}

extension SignUpViewController: SignUpButtonCellDelegate {
    func didTapButton() {
        print("button tapped")
    }
}

