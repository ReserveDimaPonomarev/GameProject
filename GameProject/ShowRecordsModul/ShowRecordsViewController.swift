//
//  ShowRecordsViewController.swift
//  GameProject
//
//  Created by Дмитрий Пономарев on 21.09.2023.
//


import UIKit

private extension Int {
    static let xOffsetForRecordsLabel = 150
    static let xOffsetForTableView = 50
    static let yInsetForTableView = 50
}

//MARK: - MVP Protocol

protocol ShowRecordsDisplayLogic: UIViewController {
    var presenter: ShowRecordsPresentationProtocol? {get set}
}

class ShowRecordsViewController: UIViewController, ShowRecordsDisplayLogic {
    
    //MARK: - MVP Properties
    
    var presenter: ShowRecordsPresentationProtocol?
    
    //MARK: - UI properties
    
    private let tableView = UITableView()
    private let recordsLabel = UILabel()

    
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
        let assembly = ShowRecordsAssembly()
        assembly.configurate(self)
    }
  
    //MARK: - View lifecycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        addViews()
        setupViews()
        makeConstraints()
    }
}

//MARK: - Private methods

private extension ShowRecordsViewController {
    
    //MARK: - addViews
    
    func addViews() {
        view.addSubview(recordsLabel)
        view.addSubview(tableView)
    }
    
    //MARK: - makeConstraints
    
    func makeConstraints() {
        recordsLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(Int.xOffsetForRecordsLabel)
        }
        tableView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(Int.yInsetForTableView)
            $0.top.equalTo(recordsLabel.snp.bottom).offset(Int.xOffsetForTableView)
            $0.bottom.equalToSuperview()
        }
    }
    
    //MARK: - setupViews
    
    func setupViews() {
        view.backgroundColor = .systemGray4
        tableView.backgroundColor = .systemGray4
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.register(CustomPlayerResultsCell.self, forCellReuseIdentifier: CustomPlayerResultsCell.identifier)
        recordsLabel.makeCustomLabelForShowRecordsVC()
    }
}

//MARK: - Extension UITableViewDataSource

extension ShowRecordsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.userResultsArray.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomPlayerResultsCell.identifier, for: indexPath) as? CustomPlayerResultsCell,
              let exampleOfCell = presenter?.userResultsArray else {
            return UITableViewCell() }
        let cellWithModel = exampleOfCell[indexPath.row]
        cell.configureView(cellWithModel)
        return cell
    }
}
