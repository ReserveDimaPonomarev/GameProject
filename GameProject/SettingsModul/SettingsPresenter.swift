//
//  SettingsPresenter.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 12.09.2023.
//

import UIKit

protocol SettingsPresentationProtocol: AnyObject{
    var viewController: SettingsDisplayLogic? {get set}
    var router: SettingsRouterProtocol? {get set}
    func nextColor() -> UIColor
    func previousColor() -> UIColor
    func increaseSpeed() -> String
    func decreaseSpeed() -> String
    func currentSpeed() -> PlayerSettingsModel.Speed
    func currentColor() -> UIColor
    func currentName(_: String)
    func enteredCurrentName() -> String 
}

class SettingsPresenter: SettingsPresentationProtocol {
    
    weak var viewController: SettingsDisplayLogic?
    var router: SettingsRouterProtocol?
    private var inputedTextInTextField = String()
    private var choosenPositionOfSpeed = Int()
    private var choosenPositionOfColor = Int()
    private let arrayOfSpeed = [PlayerSettingsModel.Speed.low, PlayerSettingsModel.Speed.average, PlayerSettingsModel.Speed.high]
    private let arrayOfColors: [UIColor] = [.red, .yellow, .gray, .blue, .cyan]
    
    //MARK: - setupColor

    func nextColor() -> UIColor {
        if arrayOfColors.count == choosenPositionOfColor + 1 {
            choosenPositionOfColor = 0
            return arrayOfColors[choosenPositionOfColor]
        } else {
            choosenPositionOfColor += 1
            return arrayOfColors[choosenPositionOfColor]
        }
    }
    
    func previousColor() -> UIColor {
        if choosenPositionOfColor == 0 {
            choosenPositionOfColor = arrayOfColors.count - 1
            return arrayOfColors[choosenPositionOfColor]
        } else {
            choosenPositionOfColor -= 1
            return arrayOfColors[choosenPositionOfColor]
        }
    }
    
    func currentColor() -> UIColor {
        arrayOfColors[choosenPositionOfColor]
    }
    
    //MARK: - setupSpeed

    func increaseSpeed() -> String {
        if choosenPositionOfSpeed == arrayOfSpeed.count - 1 {
            return "\(arrayOfSpeed[choosenPositionOfSpeed].rawValue)"
        } else {
            choosenPositionOfSpeed += 1
            return "\(arrayOfSpeed[choosenPositionOfSpeed].rawValue)"
        }
    }
    
    func decreaseSpeed() -> String {
        if choosenPositionOfSpeed == 0 {
            choosenPositionOfSpeed = arrayOfSpeed.count - 1
            return "\(arrayOfSpeed[choosenPositionOfSpeed].rawValue)"
        } else { choosenPositionOfSpeed -= 1
            return "\(arrayOfSpeed[choosenPositionOfSpeed].rawValue)"
        }
    }
    
    func currentSpeed() -> PlayerSettingsModel.Speed {
        arrayOfSpeed[choosenPositionOfSpeed]
    }
    
    //MARK: - setupName

    func currentName(_ name: String) {
        inputedTextInTextField = name
    }
    
    func enteredCurrentName() -> String {
        inputedTextInTextField
    }
}
