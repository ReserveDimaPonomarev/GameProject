//
//  GameRouter.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 12.09.2023.
//

import UIKit

private extension String {
    static var gameOverText = "Game Over"
    static var cancelText = "Cancel"
    static var youDiedText = "You died"
    static var youGotHitText = "You got hit"
    static var livesLeftText = " lives left"
    static var giveNextLifeText = "Ok, give me next life"
}

//MARK: - MVP Protocol

protocol GameRouterProtocol: AnyObject {
    var presenter: GamePresentationProtocol? {get set}
    func makeDiedAlert()
    func makeAlertHowMuchLivesLeft(_ numberOfLivesleft: Int)
    func showMainMenu()
}

class GameRouter: GameRouterProtocol {
    weak var presenter: GamePresentationProtocol?
    
    //MARK: - logic when player died (implement logic to show MainMenu)

    func makeDiedAlert() {
        let alert = UIAlertController(title: String.gameOverText, message: String.youDiedText, preferredStyle: .alert)
        let cancel = UIAlertAction(title: String.cancelText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.showMainMenu()
        }
        alert.addAction(cancel)
        presenter?.viewController?.present(alert, animated: true)
    }
    
    //MARK: - make alert when life spended

    func makeAlertHowMuchLivesLeft(_ number: Int) {
        self.presenter?.viewController?.animationDelegate.makePauseToShowAlert()
        let alert = UIAlertController(title: String.youGotHitText, message: "\(number)" + String.livesLeftText, preferredStyle: .alert)
        let ok = UIAlertAction(title: String.giveNextLifeText, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.viewController?.animationDelegate.playAgain()
        }
        alert.addAction(ok)
        presenter?.viewController?.present(alert, animated: true)
    }
    
    //MARK: - logic to show MainMenu

    
    func showMainMenu() {
        presenter?.viewController?.animationDelegate.endGame()
        guard let mainMenu = presenter?.viewController?.navigationController?.viewControllers.first as? MainMenuDisplayLogic,
            let presenter = presenter,
            let viewController = presenter.viewController else { return }
        
        mainMenu.provideResultsToPutInRecords(result: PlayerResultModel(name: viewController.playerSettings.playersName, numberOfScore: presenter.scoreNumber))
        viewController.navigationController?.popViewController(animated: true)
        
    }
    
    
}
