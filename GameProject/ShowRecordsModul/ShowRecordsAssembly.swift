//
//  ShowRecordsAssembly.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 21.09.2023.
//

import UIKit

final class ShowRecordsAssembly{
    func configurate(_ vc: ShowRecordsDisplayLogic) {
        let presenter = ShowRecordsPresenter()
        vc.presenter = presenter
        presenter.viewController = vc
    }
}
