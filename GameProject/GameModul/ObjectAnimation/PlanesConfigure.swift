//
//  SetupPlayersPlane.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 14.09.2023.
//

import UIKit

class PlanesConfigure: UIView {
    
    var viewOfPlayersPlane = UIView()
    var centerOfPlayersPlaneXPositionInRunTime = Int()
    
    // MARK: - Init

    init() {
        super.init(frame: UIScreen.main.bounds)
        self.addSubview(viewOfPlayersPlane)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError((String.errorWhenInitNotImplemented))
    }
    
    //    MARK: - create players plane

    func createPlane() {
        viewOfPlayersPlane.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.size.equalTo(Int.planesWidthHeight)
        }
    }
    
    //    MARK: - Updating players plane position in time

    @objc func getPositionOfPlayersPlane() {
        guard let planesLayer = viewOfPlayersPlane.layer.presentation() else { return }
        let centerXPosition = planesLayer.frame.midX
        centerOfPlayersPlaneXPositionInRunTime = Int(centerXPosition)
    }
    
    //    MARK: - Get array of players plane XY positions

    func makeArrayOfPlayersPlaneXYPositions() -> [PlayersPlanePositionModel]? {
        var arrayOfPlayersPlaneXYPositions = [PlayersPlanePositionModel]()
        guard let layer = viewOfPlayersPlane.layer.presentation() else { return nil}
        let closedRangeX = Int(layer.frame.minX)...Int(layer.frame.maxX)
        let closedRangeY = Int(layer.frame.minY)...Int(layer.frame.maxY)
        arrayOfPlayersPlaneXYPositions.append(PlayersPlanePositionModel(x: closedRangeX, y: closedRangeY, view: viewOfPlayersPlane))
        
        return arrayOfPlayersPlaneXYPositions
    }
}
