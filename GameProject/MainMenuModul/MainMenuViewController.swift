//
//  MainMenuViewController.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 12.09.2023.
//


import UIKit
import SnapKit


private extension String {
    static var startGameText = "Start game"
    static var showRecordsText = "Show records"
    static var settingsText = "Settings"
    static var unknownedPlayerText = "Unknowned"
}

private extension Int {
    static let spacingBetweenButtons: CGFloat = 30
}

//MARK: - MVP Protocol

protocol MainMenuDisplayLogic: UIViewController {
    var presenter: MainMenuPresentationProtocol? {get set}
    func provideResultsToPutInRecords(result: PlayerResultModel)
    func getGameSettings(playersSettings: PlayerSettingsModel)
}

final class MainMenuViewController: UIViewController {
    
    //MARK: - MVP Properties
    
    var presenter: MainMenuPresentationProtocol?
    
    //MARK: - UI properties
    
    private let stackView = UIStackView()
    private let labelMainMenu = UILabel()
    private let buttonStartGame = UIButton()
    private let buttonShowRecords = UIButton()
    private let buttonSettings = UIButton()
    private var playersSettings: PlayerSettingsModel?

    // MARK: - Init
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        let assembly = MainMenuAssembly()
        assembly.configurate(self)
    }
    
    //MARK: - View lifecycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        addViews()
        setupViews()
        makeConstraints()
        setupAction()
    }
}

//MARK: - Private methods

private extension MainMenuViewController {
    
    //MARK: - addViews
    
    func addViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(labelMainMenu)
        stackView.addArrangedSubview(buttonStartGame)
        stackView.addArrangedSubview(buttonShowRecords)
        stackView.addArrangedSubview(buttonSettings)
    }
    
    //MARK: - makeConstraints
    
    func makeConstraints() {
        
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    //MARK: - setupViews
    
    func setupViews() {
        view.backgroundColor = .systemGray4
        labelMainMenu.makeCustomLabelForMainMenuVC()
        stackView.axis = .vertical
        stackView.spacing = Int.spacingBetweenButtons
        buttonStartGame.makeCustomButton(text: String.startGameText)
        buttonShowRecords.makeCustomButton(text: String.showRecordsText)
        buttonSettings.makeCustomButton(text: String.settingsText)
    }
    
    //MARK: - setupAction

    func setupAction() {
        buttonStartGame.addTarget(self, action: #selector(pressStartGame), for: .touchDown)
        buttonShowRecords.addTarget(self, action: #selector(pressShowRecords), for: .touchDown)
        buttonSettings.addTarget(self, action: #selector(pressSettings), for: .touchDown)
    }
    
    //MARK: - objc method
    
    @objc func pressStartGame() {
        presenter?.router?.startGame(playerSettings: playersSettings ?? PlayerSettingsModel(colorOfPlane: .red, playersName: "Unknown", speed: .low))
    }
    @objc func pressShowRecords() {
        presenter?.router?.showRecords()
    }
    @objc func pressSettings() {
        presenter?.router?.showSettings()
    }
}

//MARK: - Extension MainMenuDisplayLogic

extension MainMenuViewController: MainMenuDisplayLogic {
    
    func getGameSettings(playersSettings: PlayerSettingsModel) {
        self.playersSettings = PlayerSettingsModel(colorOfPlane: playersSettings.colorOfPlane,
                                                   playersName: playersSettings.playersName,
                                                   speed: playersSettings.speed)
    }
    
    func provideResultsToPutInRecords(result: PlayerResultModel) {
        presenter?.router?.setRecordInShowRecordsVC(result: result)
        
    }
}
