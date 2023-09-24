//
//  ExtensionSaveButton.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 11.09.2023.
//

import UIKit

extension UIButton {
    func makeNextPreviouseButton(setTitle: String) {
        self.setTitle(setTitle, for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
    }
    
    func makeCustomButton(text: String) {
        self.setTitle(text, for: .normal)
        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        self.layer.borderColor = UIColor.white.cgColor
        self.backgroundColor = .systemGray2
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
    }
    
    func makeCustomButtonInGameVC(text: String) {
        makeCustomButton(text: text)
        self.isOpaque = false
        self.alpha = 0.5
        self.titleLabel?.numberOfLines = 0
    }
}
