//
//  SettingsAssembly.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 12.09.2023.
//

import UIKit

final class SettingsAssembly{
    func configurate(_ vc: SettingsDisplayLogic) {
        let presenter = SettingsPresenter()
        let router = SettingsRouter()
        vc.presenter = presenter
        presenter.viewController = vc
        presenter.router = router
        router.presenter = presenter
    }
}
