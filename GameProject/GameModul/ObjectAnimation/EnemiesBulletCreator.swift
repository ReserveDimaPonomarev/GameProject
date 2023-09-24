//
//  EnemiesBulletConfigure.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 15.09.2023.
//

import UIKit

private extension Int {
    static let bullets: Double = 3
    static let pointsFasterThenPlane: Double = 2
    static let bulletsInitialPosition = Int(Int.planesWidthHeight / 2)
}

class EnemiesBulletCreator: UIView {
    
    var arrayOfEnemyBullets = [UIView?]()
    var speed = Double()

    // MARK: - Init

    init() {
        super.init(frame: UIScreen.main.bounds)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError((String.errorWhenInitNotImplemented))
    }
    
    //    MARK: - create enemies bullets

    func createEnemiesBulletsFor(_ currentEnemy: UIView, enemiesPosition: Int) { // создает вражеский патрон
        let enemiesBullet = UIView()
        self.addSubview(enemiesBullet)
        enemiesBullet.backgroundColor = .red
        enemiesBullet.snp.makeConstraints {
            $0.top.equalTo(currentEnemy.snp.bottom).inset(Int.bulletsWidthHeigh)
            $0.size.equalTo(Int.bulletsWidthHeigh)
            $0.centerX.equalTo(currentEnemy)
        }
        self.layoutIfNeeded()
        arrayOfEnemyBullets.append(enemiesBullet)       // добавляет патрон в массив всех патронов
        animateEnemiesBulletsIn(enemiesPosition)
    }
    
    //    MARK: - animate enemies bullets
    
    private func animateEnemiesBulletsIn(_ enemiesPosition: Int) { // делает анимацию немного быстрее чтобы пуля двигалась быстрее самолета с начальным положением равным половине самолета
        guard let currentEnemiesBullet = arrayOfEnemyBullets.last else { return }
        UIView.animate(withDuration: speed - Int.pointsFasterThenPlane, delay: 0, options: .curveLinear) { [weak self] in
            guard let self = self else { return }
            currentEnemiesBullet?.snp.remakeConstraints {
                $0.size.equalTo(Int.bulletsWidthHeigh)
                $0.top.equalTo(self.snp.bottom)
                $0.centerX.equalToSuperview().offset(enemiesPosition)
            }
            self.layoutIfNeeded()
        }
    }
    
    //    MARK: - get array of enemies bullets XY positions

    func makeArrayOfEnemiesBulletsXYPositions() -> [EnemiesBulletsPositionModel]? { // создает массив вражеских пуль с XY значениями их положения
        var arrayOfEnemyBulletsXYPositions = [EnemiesBulletsPositionModel]()
        for eachEnemyBulletsIndex in arrayOfEnemyBullets.indices {
            guard let bullet = arrayOfEnemyBullets[eachEnemyBulletsIndex] else { return nil}
            guard let layer = bullet.layer.presentation() else { return nil}
            let bulletXPosition = Int(layer.frame.midX)
            let bulletYPosition = Int(layer.frame.midY)
            arrayOfEnemyBulletsXYPositions.append(EnemiesBulletsPositionModel(x: bulletXPosition, y: bulletYPosition, view: bullet))
        }
        return arrayOfEnemyBulletsXYPositions
    }

}
