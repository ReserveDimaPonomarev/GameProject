//
//  CustomUserResultCell.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 21.09.2023.
//


import UIKit

private extension Int {
    static let xyOffset = 20
}

final class CustomPlayerResultsCell: UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    //MARK: - UI properties
    
    private let playerNameLabel = UILabel()
    private let scoreLabel = UILabel()
    private let stackView = UIStackView()

    //MARK: - init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configureView(_ itemModel: PlayerResultModel) {
        playerNameLabel.text = itemModel.name
        scoreLabel.text = "\(itemModel.numberOfScore)"
    }
}

//MARK: - Private methods

private extension CustomPlayerResultsCell {
    
    //MARK: - setup UI
    
    func setup() {
        setupViews()
        addViews()
        makeConstraints()
    }
    
    //MARK: - addViews
    
    func addViews() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(playerNameLabel)
        stackView.addArrangedSubview(scoreLabel)
    }
    
    //MARK: - makeConstraints
    
    func makeConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(Int.xyOffset)
        }
    }
    
    //MARK: - setupViews
    
    func setupViews() {
        playerNameLabel.numberOfLines = 0
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        contentView.backgroundColor = .systemGray4
        scoreLabel.font = .boldSystemFont(ofSize: 20)
        playerNameLabel.font = .boldSystemFont(ofSize: 20)

    }
}
