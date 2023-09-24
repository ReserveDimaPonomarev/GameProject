//
//  SettingsViewController.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 12.09.2023.
//


import UIKit

private extension String {
    static let enterNameText = "Enter your name"
    static let chooseColorText = "Choose color"
    static let chooseSpeedText = "Choose speed"
    static let unknownedPlayerText = "Unknowned"
    static let previouse = "<-"
    static let next = "->"
    static let saveText = "Save"
}

private extension Int {
    static let spacingBetweenButtons: CGFloat = 30
    static let xOffsetMainStackView = 200
    static let widthMainStackView = 30
    static let xOffsetsaveButton = 30
    static let sizeSaveButton = 100

}

protocol SettingsDisplayLogic: UIViewController {
    var presenter: SettingsPresentationProtocol? {get set}
}

class SettingsViewController: UIViewController, SettingsDisplayLogic {
    
    //MARK: - MVP Properties
    
    var presenter: SettingsPresentationProtocol?
    
    //MARK: - UI properties
    
    private let mainStackView = UIStackView()
    private let enterNameLabel = UILabel()
    private let enterNameTextField = UITextField()
    private let colorStackView = UIStackView()
    private let chooseColorLabel = UILabel()
    private let buttonNextPlanesColor = UIButton()
    private let buttonPreviousPlanesColor = UIButton()
    private let viewOfPlanesColor = UIView()
    private let chooseSpeedLabel = UILabel()
    private let speedStackView = UIStackView()
    private let buttonDecreaseSpeed = UIButton()
    private let buttonIncreaseSpeed = UIButton()
    private let labelOfSpeed = UILabel()
    private let saveButton = UIButton()
        
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
        let assembly = SettingsAssembly()
        assembly.configurate(self)
    }
    
    //MARK: - View lifecycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        addViews()
        makeConstraints()
        setupViews()
        setupAction()
    }
}

//MARK: - Private methods

private extension SettingsViewController {
    
    //MARK: - addViews
    
    func addViews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(enterNameLabel)
        mainStackView.addArrangedSubview(enterNameTextField)
        mainStackView.addArrangedSubview(chooseColorLabel)
        mainStackView.addArrangedSubview(colorStackView)
        colorStackView.addArrangedSubview(buttonPreviousPlanesColor)
        colorStackView.addArrangedSubview(viewOfPlanesColor)
        colorStackView.addArrangedSubview(buttonNextPlanesColor)
        mainStackView.addArrangedSubview(chooseSpeedLabel)
        speedStackView.addArrangedSubview(buttonDecreaseSpeed)
        speedStackView.addArrangedSubview(labelOfSpeed)
        speedStackView.addArrangedSubview(buttonIncreaseSpeed)
        mainStackView.addArrangedSubview(speedStackView)
        view.addSubview(saveButton)
    }
    
    //MARK: - makeConstraints
    
    func makeConstraints() {
        mainStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Int.xOffsetMainStackView)
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().inset(Int.widthMainStackView)
        }
        colorStackView.snp.makeConstraints {
            $0.top.equalTo(chooseColorLabel.snp.bottom)
        }
        speedStackView.snp.makeConstraints {
            $0.top.equalTo(chooseSpeedLabel.snp.bottom)
        }
        saveButton.snp.makeConstraints {
            $0.top.equalTo(mainStackView.snp.bottom).offset(Int.xOffsetsaveButton)
            $0.size.equalTo(Int.sizeSaveButton)
            $0.centerX.equalToSuperview()
        }
    }
    
    //MARK: - setupViews
    
    func setupViews() {
        view.backgroundColor = .systemGray4
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillProportionally
        enterNameLabel.makeCustomLabelInSettingsVCAndGameVC(text: String.enterNameText)
        enterNameTextField.makeTextField()
        enterNameTextField.delegate = self
        chooseColorLabel.makeCustomLabelInSettingsVCAndGameVC(text: String.chooseColorText)
        colorStackView.axis = .horizontal
        colorStackView.distribution = .fillEqually
        buttonPreviousPlanesColor.makeNextPreviouseButton(setTitle: String.previouse)
        buttonNextPlanesColor.makeNextPreviouseButton(setTitle: String.next)
        speedStackView.axis = .horizontal
        speedStackView.distribution = .fillEqually
        chooseSpeedLabel.makeCustomLabelInSettingsVCAndGameVC(text: String.chooseSpeedText)
        buttonIncreaseSpeed.makeNextPreviouseButton(setTitle: String.next)
        buttonDecreaseSpeed.makeNextPreviouseButton(setTitle: String.previouse)
        viewOfPlanesColor.makeViewOfPlanesColorOnSettingsVC(color: (presenter?.currentColor())!)
        labelOfSpeed.makeCustomLabelInSettingsVCAndGameVC(text: (presenter?.currentSpeed().rawValue)!)
        saveButton.makeCustomButton(text: String.saveText)

    }
    
    //MARK: - setupAction

    func setupAction() {
        buttonPreviousPlanesColor.addTarget(self, action: #selector(previousColor), for: .touchDown)
        buttonNextPlanesColor.addTarget(self, action: #selector(nextColor), for: .touchDown)
        buttonIncreaseSpeed.addTarget(self, action: #selector(increaseSpeed), for: .touchDown)
        buttonDecreaseSpeed.addTarget(self, action: #selector(decreaseSpeed), for: .touchDown)
        saveButton.addTarget(self, action: #selector(saveConfigurations), for: .touchDown)
    }
    
    //MARK: - objc method
    
    @objc func previousColor() {
        viewOfPlanesColor.backgroundColor = presenter?.previousColor()
    }

    @objc func nextColor() {
        viewOfPlanesColor.backgroundColor = presenter?.nextColor()
    }
    
    @objc func increaseSpeed() {
        labelOfSpeed.text = presenter?.increaseSpeed()
    }

    @objc func decreaseSpeed() {
        labelOfSpeed.text = presenter?.decreaseSpeed()
    }
    
    @objc func saveConfigurations() {
        presenter?.router?.showMainMenuVC()
    }
}

//MARK: - extension UITextFieldDelegate

extension SettingsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        presenter?.currentName(textField.text ?? String())
        textField.endEditing(true)
        return true
    }
}

