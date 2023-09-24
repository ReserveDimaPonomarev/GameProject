//
//  GameViewController.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 06.09.2023.
//

import UIKit
import SnapKit

private extension String {
    static let letsGoText = "Lets go "
    static let totalScoreText = "Total score: "
    static let livesLeftText = "Lives: "
    static let fireText = "Fire"
    static let startText = "Start"
    static let turnText = "Turn"
}

private extension Int {
    static let indentForButtonsWidthHeight: CGFloat = 25
    static let xyInsetForButtons: CGFloat = 50
    static let xyInsetForUpperLabels: CGFloat = 10
    static let alphaComponent: CGFloat = 0.8
}

//MARK: - MVP Protocol

protocol GameDisplayLogic: UIViewController {
    var presenter: GamePresentationProtocol? {get set}
    var animationDelegate: GamePlayLogicProtocol! { get set }
    func updateValues(countOfLives: Int)
    func updateScoreValues(countOfScores: Int)
    var playerSettings: PlayerSettingsModel { get set }
}

class GameViewController: UIViewController {
    
    //MARK: - MVP Properties
    
    var presenter: GamePresentationProtocol?
    var animationDelegate: GamePlayLogicProtocol!
    
    //MARK: - UI properties
    
    private let scoreLabel = UILabel()
    private let livesLeftLabel = UILabel()
    private let buttonStart = UIButton()
    private let panGestureButton = UIButton()
    private let buttonFire = UIButton()
    var playerSettings: PlayerSettingsModel

    
    // MARK: - Init
    
    init(playerSettings: PlayerSettingsModel) {
        self.playerSettings = playerSettings
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError(String.errorWhenInitNotImplemented)
    }
    
    // MARK: - Setup
    
    private func setup() {
        let assembly = GameAssembly()
        assembly.configurate(self)
    }
    
    //MARK: - View lifecycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        addViews()
        setupViews()
        makeConstraints()
        setupAction()
        setupNavBar()
    }
}

//MARK: - Private methods

private extension GameViewController {
    
    //MARK: - addViews
    
    func addViews() {
        if let enemiesAnimation = animationDelegate as? GameplayLogic {
            self.view.addSubview(enemiesAnimation)
        }
        view.addSubview(livesLeftLabel)
        view.addSubview(buttonStart)
        view.addSubview(scoreLabel)
        view.addSubview(panGestureButton)
        view.addSubview(buttonFire)
    }
    
    //MARK: - makeConstraints
    
    func makeConstraints() {
        scoreLabel.snp.makeConstraints {
            $0.top.left.equalTo(view.safeAreaLayoutGuide).inset(Int.xyInsetForUpperLabels)
        }
        livesLeftLabel.snp.makeConstraints {
            $0.top.equalTo(scoreLabel)
            $0.right.equalToSuperview().inset(Int.xyInsetForUpperLabels)
        }
        buttonStart.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(buttonStart.intrinsicContentSize.width + Int.indentForButtonsWidthHeight)
            $0.height.equalTo(buttonStart.intrinsicContentSize.height + Int.indentForButtonsWidthHeight)
        }
        panGestureButton.snp.makeConstraints {
            $0.right.bottom.equalToSuperview().inset(Int.xyInsetForButtons)
            $0.width.equalTo(buttonFire.intrinsicContentSize.width + Int.indentForButtonsWidthHeight)
            $0.height.equalTo(buttonFire.intrinsicContentSize.height + Int.indentForButtonsWidthHeight)
        }
        buttonFire.snp.makeConstraints {
            $0.left.bottom.equalToSuperview().inset(Int.xyInsetForButtons)
            $0.width.equalTo(buttonFire.intrinsicContentSize.width + Int.indentForButtonsWidthHeight)
            $0.height.equalTo(buttonFire.intrinsicContentSize.height + Int.indentForButtonsWidthHeight)
        }
    }
    
    //MARK: - setupViews
    
    func setupViews() {
        title = String.letsGoText + playerSettings.playersName
        view.backgroundColor = .systemGray4
        
        animationDelegate.planesConfigure.viewOfPlayersPlane.backgroundColor = playerSettings.colorOfPlane
        animationDelegate.enemyConfigure.speed = presenter?.makeGameConfigurations() ?? 0
        scoreLabel.makeCustomLabelInSettingsVCAndGameVC(text: String.totalScoreText + "\(Int())")
        livesLeftLabel.makeCustomLabelInSettingsVCAndGameVC(text: String.livesLeftText + "\(Int.numberOfLives)")
        buttonFire.makeCustomButtonInGameVC(text: String.fireText)
        buttonStart.makeCustomButton(text: String.startText)
        panGestureButton.makeCustomButtonInGameVC(text: String.turnText)
        panGestureButton.isEnabled = false
        buttonFire.isEnabled = false
    }
    
    //MARK: - objc method
    
    @objc func pressStartGame() {
        animationDelegate?.startGame()
        buttonStart.isHidden = true
        buttonFire.isEnabled = true
        panGestureButton.isEnabled = true
        buttonFire.alpha = Int.alphaComponent
        panGestureButton.alpha = Int.alphaComponent
    }
    
    @objc func pressFire() {
        animationDelegate?.createBullet()
    }
    
    @objc func userTappedLeftBarButtonToShowMainMenu() {
        presenter?.router?.showMainMenu()
    }
    
    @objc func gesturePan(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            let translation = gesture.translation(in: view)
            animationDelegate.planesConfigure.viewOfPlayersPlane.transform = CGAffineTransform(translationX: (translation.x * 2), y: 0)
        }
    }
    
    //MARK: - setupAction
    
    func setupAction() {
        buttonFire.addTarget(self, action: #selector(pressFire), for: .touchUpInside)
        buttonStart.addTarget(self, action: #selector(pressStartGame), for: .touchDown)
        panGestureButton.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(gesturePan)))
    }
    
    //MARK: - setupNavBar

    func setupNavBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(userTappedLeftBarButtonToShowMainMenu))
    }
}

//MARK: - extension GameDisplayLogic

extension GameViewController: GameDisplayLogic {
    
    func updateValues(countOfLives: Int) {
        livesLeftLabel.text = String.livesLeftText + "\(countOfLives)"
    }
    
    func updateScoreValues(countOfScores: Int) {
        scoreLabel.text = String.totalScoreText + "\(countOfScores)"
    }
}


