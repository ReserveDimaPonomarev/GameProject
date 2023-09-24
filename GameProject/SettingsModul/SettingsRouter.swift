//
//  SettingsRouter.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 12.09.2023.
//

import UIKit

protocol SettingsRouterProtocol: AnyObject {
    var presenter: SettingsPresentationProtocol? {get set}
    func showMainMenuVC()
}

class SettingsRouter: SettingsRouterProtocol {
    weak var presenter: SettingsPresentationProtocol?
    
    //MARK: - pressedSaveToShowMainMenu

    func showMainMenuVC() {
        guard let presenter = presenter,
              let mainMenu = presenter.viewController?.navigationController?.viewControllers.first as? MainMenuDisplayLogic else { return }
        mainMenu.getGameSettings(playersSettings: PlayerSettingsModel(colorOfPlane: presenter.currentColor(), playersName: presenter.enteredCurrentName(), speed: presenter.currentSpeed()))
        presenter.viewController?.navigationController?.popViewController(animated: true)
    }
}
