//
//  RocksConfigure.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 14.09.2023.
//

import UIKit

private extension Int {
    static let rocksAnimateDuration: Double = 10
    static let delayNeededToCreateNewRock = 5
}

class RocksCreator: UIView {
    
    private var arrayOfRocks = [UIView]()

    // MARK: - Init

    init() {
        super.init(frame: UIScreen.main.bounds)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError((String.errorWhenInitNotImplemented))
    }
    
    func createRocks() {
        createLeftRock()
        createRightRocks()
    }
    
    //    MARK: - create array of right rocks

    private func createRightRocks() {
        let randomRocksWidth = Int.random(in: 0...Int.rocksWidth)
        let rightRocksView = UIView()
        rightRocksView.backgroundColor = .red
        self.addSubview(rightRocksView)
        rightRocksView.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.top)
            $0.right.equalToSuperview()
            $0.height.equalTo(Int.rocksHeight)
            $0.width.equalTo(randomRocksWidth)
        }
        self.layoutIfNeeded()
        arrayOfRocks.append(rightRocksView)
        animateRocks(randomRocksWidth)
    }
    
    //    MARK: - create array of left rocks

    private func createLeftRock() {
        let randomRocksWidth = Int.random(in: 0...Int.rocksWidth)
        let leftRocksView = UIView()
        leftRocksView.backgroundColor = .red
        self.addSubview(leftRocksView)
        leftRocksView.snp.makeConstraints {
            $0.bottom.equalTo(self.snp.top)
            $0.left.equalToSuperview()
            $0.height.equalTo(Int.rocksHeight)
            $0.width.equalTo(randomRocksWidth)
        }
        self.layoutIfNeeded()
        arrayOfRocks.append(leftRocksView)
        animateRocks(randomRocksWidth)
    }
    
    //    MARK: - animate both left and right rocks

    private func animateRocks(_ randomIntPosition: Int) {  // анимирует скалу
        guard let currentEnemy = arrayOfRocks.last else { return }
        if currentEnemy.frame.minX == 0 {
            UIView.animate(withDuration: Int.rocksAnimateDuration, delay: 0, options: .curveLinear) { [weak self] in
                guard let self = self else { return }
                currentEnemy.snp.remakeConstraints {
                    $0.bottom.equalToSuperview().offset(Int.rocksHeight)
                    $0.height.equalTo(Int.rocksHeight)
                    $0.width.equalTo(randomIntPosition)
                }
                self.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: Int.rocksAnimateDuration, delay: 0, options: .curveLinear) { [weak self] in
                guard let self = self else { return }
                currentEnemy.snp.remakeConstraints {
                    $0.bottom.equalToSuperview().offset(Int.rocksHeight)
                    $0.height.equalTo(Int.rocksHeight)
                    $0.right.equalToSuperview()
                    $0.width.equalTo(randomIntPosition)
                }
                self.layoutIfNeeded()
            }
        }
    }
    
    //    MARK: - get array of rocks XY positions

    private func makeArrayOfRocksXYPositions() -> [RocksPositionModel]? {  //создает ХУ скалы
        var arrayOfRocksXYPosition = [RocksPositionModel]()
        for eachRocksIndex in arrayOfRocks.indices {
            
            let rock = arrayOfRocks[eachRocksIndex]
            guard let layer = rock.layer.presentation() else { return nil }
            let rockXPosition = Int(layer.frame.midX)
            let rockYPosition = Int(layer.frame.maxY)
            arrayOfRocksXYPosition.append(RocksPositionModel(x: rockXPosition, y: rockYPosition, view: rock))
        }
        return arrayOfRocksXYPosition
    }
    
    //    MARK: - timer to get position of each rock in time

    @objc func getPositionOfRocks() {
        //  также необходимо реализовать функцию уничтожения самолета если он попал в скалы, проверить диапазон значений у вражеских самолетов чтобы не появились в месте скал
        
        guard let arrayOfRocksXY = makeArrayOfRocksXYPositions() else { return }
        for each in arrayOfRocksXY {
            if each.y >= Int(self.frame.height) + Int.rocksHeight {
                if arrayOfRocks.contains(where: { $0 == each.view }) {
                    each.view.isHidden = true
                    each.view.removeFromSuperview()
                    arrayOfRocks.removeAll(where: {$0 == each.view})
                    
                }
            }
        }
        if arrayOfRocksXY.count == 0 {
            createRocks()
        }
        if (arrayOfRocksXY.last?.y ?? 0) > Int(arrayOfRocks.last?.frame.height ?? 0) - Int.delayNeededToCreateNewRock  {
            createRocks()
        }
    }
}
