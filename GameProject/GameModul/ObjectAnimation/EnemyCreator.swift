//
//  EnemiesConfigure.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 15.09.2023.
//

import Foundation

//
//  EnemyMaker.swift
//  GameApp
//
//  Created by Дмитрий Пономарев on 14.09.2023.
//

import UIKit

private extension Int {
    static let indentFromSuperviewBorders = 90
}

class EnemyCreator: UIView {
    
    var arrayOfEnemies = [UIView]()
    
    var bulletConfigure = EnemiesBulletCreator()
    var speed = Double()

    // MARK: - Init

    init() {
        super.init(frame: UIScreen.main.bounds)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError((String.errorWhenInitNotImplemented))
    }
    
    //MARK: - timer to create enemy

    @objc func makeAnimatedEnemyInEachTimeIntervals()  { //создает врага каждые 2 секунды с рандомным числом
        let randomPosition = Int.random(in: Int(-self.frame.midX) + Int.indentFromSuperviewBorders...Int(self.frame.midX) - Int.indentFromSuperviewBorders)
        createEnemyIn(randomPosition)
    }
    
    //    MARK: - create array of enemy
    
    private func createEnemyIn(_ randomPosition: Int) {          //создает нового врага каждые 2 секунды
        let enemy = UIView()
        self.addSubview(enemy)
        enemy.backgroundColor = .green
        enemy.snp.makeConstraints {
            $0.centerX.equalToSuperview().offset(randomPosition)
            $0.size.equalTo(Int.planesWidthHeight)
            $0.top.equalToSuperview().offset(-Int.planesWidthHeight)
        }
        self.addSubview(bulletConfigure)
        bulletConfigure.speed = speed
        bulletConfigure.createEnemiesBulletsFor(enemy, enemiesPosition: randomPosition)
        arrayOfEnemies.append(enemy)
        self.layoutIfNeeded()
        
        animateEnemyIn(randomPosition)
    }
    
    //    MARK: - animate enemy

    private func animateEnemyIn(_ randomIntPosition: Int) {     // анимирует движение каждого врага из массива врагов и рандомным местом появления на экране
        guard let currentEnemy = arrayOfEnemies.last else { return }
        UIView.animate(withDuration: speed, delay: 0, options: .curveLinear) { [weak self] in
            guard let self = self else { return }
            currentEnemy.snp.remakeConstraints {
                $0.bottom.equalToSuperview().offset(currentEnemy.bounds.height)
                $0.centerX.equalToSuperview().offset(randomIntPosition)
                $0.size.equalTo(Int.planesWidthHeight)
            }
            self.layoutIfNeeded()
        }
    }
    
    //    MARK: - get array of enemies XY positions

    func makeArrayOfEnemiesXYPositions() -> [EnemiesPositionModel]? {    // создает массив врагов с XY значениями их положения на экране
        var arrayOfEnemiesXYPositions = [EnemiesPositionModel]()
        for eachEnemyIndex in arrayOfEnemies.indices {
            guard let layer = arrayOfEnemies[eachEnemyIndex].layer.presentation() else { return nil }
            let closedRangeX = Int(layer.frame.minX)...Int(layer.frame.maxX)
            let closedRangeY = Int(layer.frame.minY)...Int(layer.frame.maxY)
            arrayOfEnemiesXYPositions.append(EnemiesPositionModel(x: closedRangeX, y: closedRangeY, view: arrayOfEnemies[eachEnemyIndex]))
        }
        return arrayOfEnemiesXYPositions
    }
}
