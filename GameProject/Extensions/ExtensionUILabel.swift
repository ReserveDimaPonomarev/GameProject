//
//  ExtensionUILabel.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 12.09.2023.
//

import UIKit

extension UILabel {
    func makeCustomLabelForMainMenuVC() {
        self.text = "Main menu"
        self.font = .boldSystemFont(ofSize: 40)
    }
    
    func makeCustomLabelForShowRecordsVC() {
        self.text = "Records:"
        self.font = .boldSystemFont(ofSize: 30)
    }
    
    func makeCustomLabelInSettingsVCAndGameVC(text: String) {
        self.text = text
        self.textAlignment = .center
        self.adjustsFontSizeToFitWidth = true
        self.font = .systemFont(ofSize: 30)
    }
}
