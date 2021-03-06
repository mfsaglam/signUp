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
        configureSubjects()
        configureTableView()
    }
    
    //MARK: - Publishers
    
    private var formIsValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(
            emailIsValid,
            passwordValidAndConfirmed,
            agreeToTermsSubject
            )
        .map { $0.0 && $0.1 && $0.2 }
        .eraseToAnyPublisher()
    }
    
    private func emailIsValid(_ email: String) -> Bool {
        email.contains("@") && email.contains(".com") || email.contains(".cn")
    }
    
    private var formattedEmailAdress: AnyPublisher<String, Never> {
        emailSubject
            .map { $0.lowercased() }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .eraseToAnyPublisher()
    }
    
    private var emailIsValid: AnyPublisher<Bool, Never> {
        formattedEmailAdress
            .map { [weak self] in self?.emailIsValid($0) }
            .replaceNil(with: false)
            .eraseToAnyPublisher()
    }
    
    private var passwordValidAndConfirmed: AnyPublisher<Bool, Never> {
        passwordIsValid.combineLatest(passwordMatchesConfirmation)
            .map { valid, confirmed in
                valid && confirmed
            }
            .eraseToAnyPublisher()
    }
    
    private var passwordIsValid: AnyPublisher<Bool, Never> {
        passwordSubject
            .map {
                $0 != "password" && $0.count >= 8
            }
            .eraseToAnyPublisher()
    }
    
    private var passwordMatchesConfirmation: AnyPublisher<Bool, Never> {
        passwordSubject.combineLatest(passwordConfirmationSubject)
            .map { pass, conf in
                pass == conf
            }
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
    
    private func configureSubjects() {
        formattedEmailAdress
            .filter { [unowned self] in $0 != emailSubject.value }
            .map { $0 as String? }
            .assign(to: \.text, on: emailAdressField)
            .store(in: &cancellables)
        
        setValidColor(field: emailAdressField, publisher: emailIsValid)
        setValidColor(field: passwordField, publisher: passwordIsValid)
        setValidColor(field: passwordConfirmationField, publisher: passwordMatchesConfirmation)
        
        formIsValid
            .assign(to: \.isEnabled, on: signUpButtonCell.signUpButton)
            .store(in: &cancellables)
    }
    
    private func configureTableView() {
        tableView.rowHeight = 44
        
        emailAdressCell.selectionStyle = .none
        passwordCell.selectionStyle = .none
        passwordConfirmationCell.selectionStyle = .none
        
        agreeTermsCell.delegate = self
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
        passwordField.textContentType = .password
        passwordField.isSecureTextEntry = true
        
        passwordConfirmationField.placeholder = "Passsword Confirmation"
        passwordConfirmationField.autocorrectionType = .no
        passwordConfirmationField.autocapitalizationType = .none
        passwordConfirmationField.textContentType = .password
        passwordConfirmationField.isSecureTextEntry = true
        
        emailAdressCell.addSubview(emailAdressField)
        passwordCell.addSubview(passwordField)
        passwordConfirmationCell.addSubview(passwordConfirmationField)
    }
    
    private func configureUI() {
        title = "Sign Up"
        
        emailAdressField.addTarget(self, action: #selector(emailDidChange), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(passwordDidChange), for: .editingChanged)
        passwordConfirmationField.addTarget(self, action: #selector(passwordConfirmationDidChange), for: .editingChanged)
    }
    
    private func setValidColor<P: Publisher>(field: UITextField, publisher: P)
        where P.Output == Bool, P.Failure == Never {
            publisher
                .map { $0 ? UIColor.label : UIColor.systemPink }
                .assign(to: \.textColor, on: field)
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
        let alert = UIAlertController(title: "Welcome!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension SignUpViewController: TermsAndConditionsCellDelegate {
    func didSwitchTapped() {
        agreeToTermsSubject.send(agreeTermsCell.termsConditionsSwitch.isOn)
    }
}

