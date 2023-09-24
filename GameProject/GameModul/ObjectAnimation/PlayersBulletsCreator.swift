//
//  BulletConfigure.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 15.09.2023.
//

import Foundation
import UIKit

private extension Int {
    static let bulletsAnimateDuration: Double = 3
}

class PlayersBulletsCreator: UIView {
    
    var arrayOfPlayerBullets = [UIView?]()

    // MARK: - Init

    init() {
        
        super.init(frame: UIScreen.main.bounds)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError((String.errorWhenInitNotImplemented))
    }
    
    //    MARK: - create array of players bullets

    func createBullet(position: Int) {                 //создает новый патрон при каждом нажатии на "Огонь"
        let bullet = UIView()
        self.addSubview(bullet)
        bullet.backgroundColor = .black
        bullet.snp.updateConstraints {
            $0.size.equalTo(Int.bulletsWidthHeigh)
            $0.centerX.equalTo(position)
            $0.bottom.equalToSuperview().inset(Int.planesWidthHeight)
        }
        arrayOfPlayerBullets.append(bullet)  // добавляет каждый патрон в массив всех патронов
        self.layoutIfNeeded()
        
        animateBullet(position: position)
    }
    
    //    MARK: - animate players bullets

    private func animateBullet(position: Int) {              // анимирует движение каждого патрон из массива патронов
        guard let bullet = arrayOfPlayerBullets.last else { return }
        UIView.animate(withDuration: Int.bulletsAnimateDuration, delay: 0, options: .curveLinear) { [weak self] in
            guard let self = self else { return }
            bullet?.snp.remakeConstraints {
                $0.size.equalTo(Int.bulletsWidthHeigh)
                $0.bottom.equalTo(self.snp.top)
                $0.left.equalTo(position)
            }
            self.layoutIfNeeded()
        }
    }
    
    //    MARK: - get array of players bullets XY positions

    func makeArrayOfBulletsXYPositions() -> [BulletsPositionModel]? {       // создает массив патронов с XY значениями их положения на экране
        var arrayOfBulletsXYPositions = [BulletsPositionModel]()
        for eachPlayerBulletIndex in arrayOfPlayerBullets.indices {
            guard let bullet = arrayOfPlayerBullets[eachPlayerBulletIndex] else { return nil }
            guard let layer = bullet.layer.presentation() else { return nil }
            let bulletXPosition = Int(layer.frame.midX)
            let bulletYPosition = Int(layer.frame.midY)
            arrayOfBulletsXYPositions.append(BulletsPositionModel(x: bulletXPosition, y: bulletYPosition, view: bullet))
        }
        return arrayOfBulletsXYPositions
    }
}
