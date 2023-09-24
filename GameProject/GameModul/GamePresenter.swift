//
//  GamePresenter.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 12.09.2023.
//

import UIKit

private extension Int {
    static let lowSpeed: Double = 6
    static let averageSpeed: Double = 4
    static let highSpeed: Double = 2
}

//MARK: - MVP Protocol

protocol GamePresentationProtocol: AnyObject{
    var viewController: GameDisplayLogic? {get set}
    var router: GameRouterProtocol? {get set}
    func makeGameConfigurations() -> Double
    var scoreNumber: Int { get set }
}

class GamePresenter: GamePresentationProtocol {
    weak var viewController: GameDisplayLogic?
    var router: GameRouterProtocol?
    var numbersOfLives = Int.numberOfLives
    var scoreNumber = Int()
    
    //MARK: - makeFirstConfigurationForStartingGame

    func makeGameConfigurations() -> Double {
        decreaseNumberOfLives()
        increaseNumberOfkills()
        let speed = viewController?.playerSettings.speed
        switch speed {
        case .low: return Int.lowSpeed
        case .average: return Int.averageSpeed
        case .high: return Int.highSpeed
        case .none: return Int.lowSpeed
        }
    }
    
    //MARK: - Decrease number of lives and logic when no lives left

    private func decreaseNumberOfLives() {
        viewController?.animationDelegate.gotHit = { [weak self] flag in
            guard let self = self else { return }
            if flag == true {
                self.numbersOfLives -= 1
                self.viewController?.updateValues(countOfLives: self.numbersOfLives)
                self.switcherToChooseRightAlert()
                self.viewController?.animationDelegate.planesConfigure.viewOfPlayersPlane.transform = CGAffineTransform(translationX: self.viewController?.view.frame.minX ?? 0, y: 0)
            }
        }
    }
    
    //MARK: - Alert switcher depended from number of lives
    
    private func switcherToChooseRightAlert() {
        switch numbersOfLives {
        case 0: self.router?.makeDiedAlert()
        case 0..<Int.numberOfLives: self.router?.makeAlertHowMuchLivesLeft(numbersOfLives)
        default: break
        }
    }
    
    //MARK: - Increase number of kills and update UIElements on screen

    private func increaseNumberOfkills() {
        viewController?.animationDelegate.enemyGotHit = { [weak self] in
            guard let self = self else { return }
            self.scoreNumber += 1
            self.viewController?.updateScoreValues(countOfScores: self.scoreNumber)
        }
    }
}


