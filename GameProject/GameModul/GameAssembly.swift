//
//  GameAssembly.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 12.09.2023.
//

import UIKit

final class GameAssembly{
    func configurate(_ vc: GameDisplayLogic) {
        let presenter = GamePresenter()
        let router = GameRouter()
        let animation = GameplayLogic()
        vc.animationDelegate = animation
        vc.presenter = presenter
        presenter.viewController = vc
        presenter.router = router
        router.presenter = presenter
    }
}
