//
//  AnimationModels.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 12.09.2023.
//

import UIKit

struct EnemiesPositionModel {
    var x: ClosedRange<Int>
    var y: ClosedRange<Int>
    var view: UIView
}

struct BulletsPositionModel {
    let x: Int
    let y: Int
    let view: UIView
}

struct EnemiesBulletsPositionModel {
    let x: Int
    let y: Int
    let view: UIView
}

struct PlayersPlanePositionModel {
    var x: ClosedRange<Int>
    var y: ClosedRange<Int>
    let view: UIView
}
struct RocksPositionModel {
    let x: Int
    let y: Int
    let view: UIView
}
