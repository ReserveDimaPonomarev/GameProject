//
//  SetupViewController.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 11.09.2023.
//


import UIKit

struct PlayerResultModel: Encodable, Decodable {
    let name: String
    let numberOfScore: Int
}

struct PlayerSettingsModel {
    let colorOfPlane: UIColor
    let playersName: String
    let speed: Speed
    
    enum Speed: String {
        typealias RawValue = String
        case low = "low"
        case average = "average"
        case high = "high"
    }
}
