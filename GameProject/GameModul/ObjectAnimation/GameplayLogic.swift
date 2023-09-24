//
//  MatchAnimation.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 06.09.2023.
//
//

import UIKit

private extension Int {
    static let fastInterval = 0.05
    static let intervalToCreateEnemy: Double = 2
}

//MARK: - MVP Protocol

protocol GamePlayLogicProtocol: AnyObject {
    func startGame()
    func createBullet()
    func makePauseToShowAlert()
    func playAgain()
    func endGame()
    var enemyGotHit: (() -> Void)? { get set }
    var gotHit: ((Bool) -> Void)? { get set }
    var planesConfigure: PlanesConfigure { get }
    var enemyConfigure: EnemyCreator { get }
}

class GameplayLogic: UIView, GamePlayLogicProtocol {
    private var timerToUpdatePlayersPlanePosition: Timer?
    private var timerToFindIntersectionsBetweenObjects: Timer?
    private var timerToCreateNewEnemyEachTwoSeconds: Timer?
    private var timerToMakeRocks: Timer?
    private let rocksConfigure = RocksCreator()
    private let bulletConfigure = PlayersBulletsCreator()
    let planesConfigure = PlanesConfigure()
    let enemyConfigure = EnemyCreator()
    var gotHit: ((Bool) -> Void)?
    var enemyGotHit: (() -> Void)?
    
    // MARK: - Init

    init() {
        super.init(frame: UIScreen.main.bounds)
        addViews()
        planesConfigure.createPlane()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError((String.errorWhenInitNotImplemented))
    }
    
    //MARK: - addViews

    func addViews() {
        self.addSubview(planesConfigure)
        self.addSubview(rocksConfigure)
        self.addSubview(enemyConfigure)
        self.addSubview(bulletConfigure)
    }
    
    //MARK: - start timers to begin animation and finding intersections

    func startGame() {
        timerToUpdatePlayersPlanePosition = Timer.scheduledTimer(timeInterval: Int.fastInterval, target: planesConfigure, selector: #selector(planesConfigure.getPositionOfPlayersPlane), userInfo: nil, repeats: true)
        timerToMakeRocks = Timer.scheduledTimer(timeInterval: Int.fastInterval, target: rocksConfigure, selector: #selector(rocksConfigure.getPositionOfRocks), userInfo: nil, repeats: true)
        timerToCreateNewEnemyEachTwoSeconds = Timer.scheduledTimer(timeInterval: Int.intervalToCreateEnemy, target: enemyConfigure, selector: #selector(enemyConfigure.makeAnimatedEnemyInEachTimeIntervals), userInfo: nil, repeats: true)
        timerToFindIntersectionsBetweenObjects = Timer.scheduledTimer(timeInterval: Int.fastInterval, target: self, selector: #selector(findingIntersections), userInfo: nil, repeats: true)
    }
    
    //MARK: - createBullet
    
    func createBullet() {
        bulletConfigure.createBullet(position: planesConfigure.centerOfPlayersPlaneXPositionInRunTime)
    }
    
    //MARK: - makePause and remove some objects from superview seems like new game has begun

    func makePauseToShowAlert() {
        self.rocksConfigure.removeFromSuperview()
        self.enemyConfigure.removeFromSuperview()
        self.bulletConfigure.removeFromSuperview()
    }
    
    //MARK: - add subviews back to screen

    func playAgain() {
        self.addSubview(rocksConfigure)
        self.addSubview(enemyConfigure)
        self.addSubview(bulletConfigure)
    }
    
    //MARK: - stop timers and remove views from superview to start deinit

    func endGame() {
        timerToUpdatePlayersPlanePosition?.invalidate()
        timerToMakeRocks?.invalidate()
        timerToCreateNewEnemyEachTwoSeconds?.invalidate()
        timerToFindIntersectionsBetweenObjects?.invalidate()
        self.planesConfigure.removeFromSuperview()
        self.rocksConfigure.removeFromSuperview()
        self.enemyConfigure.removeFromSuperview()
        self.bulletConfigure.removeFromSuperview()
    }
    
    //  MARK: - FINDING INTERSECTIONS
    
    @objc private func findingIntersections() {
        getIntersectionsBetweenEnemiesBulletsAndPlayersPlane()
        getIntersectionsBetweenEnemiesAndPlayersBullets()
        getIntersectionsBetweenRocksAndPlayersPlane()
    }
    
    private func getIntersectionsBetweenEnemiesBulletsAndPlayersPlane() { // находит пересечения XY положения вражеских пуль и самолета игрока
        guard let arrayOfEnemiesBulletsXYPosition = enemyConfigure.bulletConfigure.makeArrayOfEnemiesBulletsXYPositions() else { return }
        guard let arrayOfPlayersPlaneXYPosition = planesConfigure.makeArrayOfPlayersPlaneXYPositions() else { return }
        for  eachPlayersPlaneXYPosition in arrayOfPlayersPlaneXYPosition {
            for eachEnemiesBulletXYPosition in arrayOfEnemiesBulletsXYPosition  {
                if eachPlayersPlaneXYPosition.y ~= eachEnemiesBulletXYPosition.y && eachPlayersPlaneXYPosition.x ~= eachEnemiesBulletXYPosition.x {
                    gotHit?(true)
                    if enemyConfigure.bulletConfigure.arrayOfEnemyBullets.contains(where: { $0 == eachEnemiesBulletXYPosition.view
                    }) {            // уничтожение вражеской пули при попадании в самолет игрока
                        eachEnemiesBulletXYPosition.view.isHidden = true
                        enemyConfigure.bulletConfigure.arrayOfEnemyBullets.removeAll(where:  {$0 == eachEnemiesBulletXYPosition.view } )
                    }
                }
                if eachEnemiesBulletXYPosition.y > Int(self.frame.height) { // уничтожение пули при вылете за пределы экрана
                    enemyConfigure.bulletConfigure.arrayOfEnemyBullets.removeAll(where: ({  $0 == eachEnemiesBulletXYPosition.view}))
                }
            }
        }
    }
    
    private func getIntersectionsBetweenEnemiesAndPlayersBullets() {         // находит пересечения XY положения врагов и пуль на экране
        guard let arrayOfBulletsXYPosition = bulletConfigure.makeArrayOfBulletsXYPositions() else { return }
        guard let arrayOfEnemiesXYPosition = enemyConfigure.makeArrayOfEnemiesXYPositions() else { return }
        
        for eachEnemiesXYPosition in arrayOfEnemiesXYPosition {
            for eachBulletsXYPosition in arrayOfBulletsXYPosition {
                if eachEnemiesXYPosition.y ~= eachBulletsXYPosition.y && eachEnemiesXYPosition.x ~= eachBulletsXYPosition.x  {
                    enemyGotHit?()
                    if enemyConfigure.arrayOfEnemies.contains(where: {$0 == eachEnemiesXYPosition.view }) {   // уничтожение врага при попадании пули
                        eachEnemiesXYPosition.view.isHidden = true
                        enemyConfigure.arrayOfEnemies.removeAll { $0 == eachEnemiesXYPosition.view }
                    }
                    if bulletConfigure.arrayOfPlayerBullets.contains(where: { $0 == eachBulletsXYPosition.view}) {  // уничтожение пули при попадании во врага
                        eachBulletsXYPosition.view.isHidden = true
                        bulletConfigure.arrayOfPlayerBullets.removeAll { $0 == eachBulletsXYPosition.view }
                    }
                }
                if eachBulletsXYPosition.y < 0 {                // пуля улетела за пределы экрана
                    eachBulletsXYPosition.view.isHidden = true
                    bulletConfigure.arrayOfPlayerBullets.removeAll(where: { $0 == eachBulletsXYPosition.view })
                }
            }
            if eachEnemiesXYPosition.y ~= Int(self.frame.height + Int.planesWidthHeight) {     // враг опустился ниже экрана
                eachEnemiesXYPosition.view.isHidden = true
                enemyConfigure.arrayOfEnemies.removeAll { $0 == eachEnemiesXYPosition.view }
            }
        }
    }
    
    func getIntersectionsBetweenRocksAndPlayersPlane() {
        // уничтожение самолета игрока при попадании в скалы
        guard let arrayOfPlanesXYPosition = planesConfigure.makeArrayOfPlayersPlaneXYPositions() else { return }
        for each in arrayOfPlanesXYPosition {
            if each.x ~= Int(self.frame.minX) + Int.rocksWidth || each.x ~= Int(self.frame.maxX) - Int.rocksWidth {
                gotHit?(true)
            }
        }
    }
}
