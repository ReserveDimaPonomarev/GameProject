//
//  ShowRecordsPresenter.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 21.09.2023.
//

import UIKit

private extension String {
    static let keyForUserDefault = "Results"
}

private extension Int {
    static let limitOfShownResults = 5
}

protocol ShowRecordsPresentationProtocol: AnyObject{
    var viewController: ShowRecordsDisplayLogic? {get set}
    var userResultsArray: [PlayerResultModel] {get set}
}

class ShowRecordsPresenter: ShowRecordsPresentationProtocol {
    weak var viewController: ShowRecordsDisplayLogic?
    
    var userResultsArray: [PlayerResultModel] {
        get {
            return makeSpecifiedArrayFromArrayInUserDefaults()
        }
        set {
            UserDefaults.standard.saveData(someData: newValue, key: String.keyForUserDefault)
        }
    }
    
    //MARK: - makeSpecifiedArrayFromInputtedData
    
    private func makeSpecifiedArrayFromArrayInUserDefaults() -> [PlayerResultModel] {
        guard let savedArrayInUserDefaults = UserDefaults.standard.readDataFromArray(type: PlayerResultModel.self, key: String.keyForUserDefault) else { return [] }
        var sortedSavedArray = savedArrayInUserDefaults.sorted(by: { $0.numberOfScore > $1.numberOfScore })
        if sortedSavedArray.count > Int.limitOfShownResults {
            sortedSavedArray.removeLast()
            UserDefaults.standard.saveData(someData: sortedSavedArray, key: String.keyForUserDefault)
        }
        return sortedSavedArray
    }
}
