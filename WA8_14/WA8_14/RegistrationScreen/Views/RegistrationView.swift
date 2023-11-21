//
//  RegistrationView.swift
//  WA8_14
//
//  Created by Diya on 11/14/23.
//

import UIKit
import FirebaseAuth

class RegistrationView: UIView {
    
    var titleLabel: UILabel!
    var nameLabel: UILabel!
    var nameTextField: UITextField!
    var emailLabel: UILabel!
    var emailTextField: UITextField!
    var passwordLabel: UILabel!
    var passwordTextField: UITextField!
    var reenterPasswordLabel: UILabel!
    var reenterPasswordTextField: UITextField!
    var createProfileButton: UIButton!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .white
        
        setupTitleLabel()
        setupNameLabel()
        setupNameTextField()
        setupEmailLabel()
        setupEmailTextField()
        setupPasswordLabel()
        setupPasswordTextField()
        setupReenterPasswordLabel()
        setupReenterPasswordTextField()
        setupCreateProfileButton()
        
        initConstraints()
    }
    
    func setupTitleLabel() {
        
        titleLabel = UILabel()
        titleLabel.text = "Create your account with us"
        titleLabel.font = .boldSystemFont(ofSize: 18)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(titleLabel)
    }
    
    func setupNameLabel() {
        
        nameLabel = UILabel()
        nameLabel.text = "Name:"
        nameLabel.font = .boldSystemFont(ofSize: 17)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameLabel)
    }
    
    func setupNameTextField() {
        
        nameTextField = UITextField()
        nameTextField.placeholder = "Enter your name"
        nameTextField.borderStyle = .roundedRect
        
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(nameTextField)
    }
    
    func setupEmailLabel() {
        
        emailLabel = UILabel()
        emailLabel.text = "Email:"
        emailLabel.font = .boldSystemFont(ofSize: 17)
        
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(emailLabel)
    }
    
    func setupEmailTextField() {
        
        emailTextField = UITextField()
        emailTextField.placeholder = "Enter your email"
        emailTextField.borderStyle = .roundedRect
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(emailTextField)
    }
    
    func setupPasswordLabel() {
        
        passwordLabel = UILabel()
        passwordLabel.text = "Password:"
        passwordLabel.font = .boldSystemFont(ofSize: 17)
        
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(passwordLabel)
    }
    
    func setupPasswordTextField() {
        
        passwordTextField = UITextField()
        passwordTextField.placeholder = "Enter your password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(passwordTextField)
    }
    
    func setupReenterPasswordLabel() {
        
        reenterPasswordLabel = UILabel()
        reenterPasswordLabel.text = "Confirm Password:"
        reenterPasswordLabel.font = .boldSystemFont(ofSize: 17)
        
        reenterPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(reenterPasswordLabel)
    }
    
    func setupReenterPasswordTextField() {
        
        reenterPasswordTextField = UITextField()
        reenterPasswordTextField.placeholder = "Re-enter your password"
        reenterPasswordTextField.borderStyle = .roundedRect
        reenterPasswordTextField.isSecureTextEntry = true
        
        reenterPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(reenterPasswordTextField)
    }
    
    func setupCreateProfileButton() {
        
        createProfileButton = UIButton(type: .system)
        createProfileButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        createProfileButton.setTitle("Create Account", for: .normal)
        createProfileButton.backgroundColor = .systemGreen
        createProfileButton.setTitleColor(.white, for: .normal)
        createProfileButton.layer.cornerRadius = 6
        
        createProfileButton.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(createProfileButton)
    }
    
    func initConstraints() {
        
        //view constraints
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            nameLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 10),
            nameTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            emailLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 30),
            emailLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 10),
            emailTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            passwordLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 15),
            passwordTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            reenterPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            reenterPasswordLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            reenterPasswordTextField.topAnchor.constraint(equalTo: reenterPasswordLabel.bottomAnchor, constant: 15),
            reenterPasswordTextField.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor, constant: 10),
            reenterPasswordTextField.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            createProfileButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            createProfileButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            createProfileButton.widthAnchor.constraint(equalToConstant: 150),
            createProfileButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

