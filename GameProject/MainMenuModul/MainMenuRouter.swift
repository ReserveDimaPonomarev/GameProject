//
//  MainMenuRouter.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 12.09.2023.
//

import UIKit

protocol MainMenuRouterProtocol: AnyObject {
    var presenter: MainMenuPresentationProtocol? {get set}
    func startGame(playerSettings: PlayerSettingsModel)
    func showRecords()
    func showSettings()
    func setRecordInShowRecordsVC(result: PlayerResultModel)
}

class MainMenuRouter: MainMenuRouterProtocol {
    weak var presenter: MainMenuPresentationProtocol?
    
    //MARK: - showGameVC

    func startGame(playerSettings: PlayerSettingsModel) {
        let controller = GameViewController(playerSettings: playerSettings)
        presenter?.viewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - showRecordsVC

    func showRecords() {
        let showRecordsVC = ShowRecordsViewController()
        presenter?.viewController?.navigationController?.pushViewController(showRecordsVC, animated: true)
    }
    
    //MARK: - showSettingsVC

    func showSettings() {
        let controller = SettingsViewController()
        presenter?.viewController?.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: - sendResultsToRecordVC

    func setRecordInShowRecordsVC(result: PlayerResultModel) {
        let showRecordsVC = ShowRecordsViewController()
        showRecordsVC.presenter?.userResultsArray.append(result)
    }
}

