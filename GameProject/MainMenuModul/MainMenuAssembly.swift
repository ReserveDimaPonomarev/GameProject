//
//  MainMenuAssembly.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 12.09.2023.
//

import UIKit

final class MainMenuAssembly{
    func configurate(_ vc: MainMenuDisplayLogic) {
        let presenter = MainMenuPresenter()
        let router = MainMenuRouter()
        vc.presenter = presenter
        presenter.viewController = vc
        presenter.router = router
        router.presenter = presenter
    }
}
