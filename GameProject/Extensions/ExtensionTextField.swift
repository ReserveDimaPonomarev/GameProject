//
//  ExtensionTextField.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 11.09.2023.
//

import UIKit

extension UITextField {
    func makeTextField() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 20
        self.placeholder = "Whats your name"
        self.textColor = .black
        self.font = .systemFont(ofSize: 20)
        self.returnKeyType = .done
        self.textAlignment = .center
    }
}
