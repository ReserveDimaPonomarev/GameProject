//
//  MainMenuPresenter.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 12.09.2023.
//

import UIKit

protocol MainMenuPresentationProtocol: AnyObject{
    var viewController: MainMenuDisplayLogic? {get set}
    var router: MainMenuRouterProtocol? {get set}
}

class MainMenuPresenter: MainMenuPresentationProtocol {
    weak var viewController: MainMenuDisplayLogic?
    var router: MainMenuRouterProtocol?
    
}
