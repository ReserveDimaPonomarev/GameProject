//
//  ExtensionStackView.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 12.09.2023.
//

import UIKit

extension UIView {
    func makeViewOfPlanesColorOnSettingsVC(color: UIColor) {
        self.backgroundColor = color
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 2
    }
}
