//
//  MainViewController.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 22.08.2025.
//

import UIKit
import Combine

final class MainViewController: UIViewController {
    // MARK: - Constants
    
    private enum Constants {
        static let balanceTitle: String = "💰 Bitcoin Balance"
        static let defaultBalanceTitle: String = "0.0 BTC"
        static let defaultBitcoinRateTitle: String = "BTC: $0.00"
        static let addIncomeTitle: String = "💎 + Add Income"
        static let addTransactionTitle: String = "📝 Add Transaction"
    }
    
    // MARK: - Private Properties

    private let viewModel: MainViewModel

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerView = UIView()
    private let balanceLabel = UILabel()
    private let addIncomeButton = UIButton()
    private let bitcoinRateLabel = UILabel()
    private let addTransactionButton = UIButton()
    private let transactionsTableView = UITableView()
    private let backgroundGradient = CAGradientLayer()
    private let headerGradient = CAGradientLayer()
    private let addButtonGradient = CAGradientLayer()

    private var groups: [TransactionGroupViewModel] = []
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle

    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindOutputs()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        backgroundGradient.frame = view.bounds
        headerGradient.frame = headerView.bounds
        headerGradient.cornerRadius = DesignSystem.CornerRadius.large
        addButtonGradient.frame = addTransactionButton.bounds
        addButtonGradient.cornerRadius = DesignSystem.CornerRadius.extraLarge
        headerView.layer.shadowPath = UIBezierPath(roundedRect: headerView.bounds, cornerRadius: DesignSystem.CornerRadius.large).cgPath
        CATransaction.commit()
    }
}

// MARK: Bind outputs + actions

private extension MainViewController {
    func bindOutputs() {
        viewModel.output.balance
            .receive(on: DispatchQueue.main)
            .sink { [weak self] balance in
                self?.balanceLabel.text = String(format: "%.4f BTC", balance)
            }
            .store(in: &cancellables)

        viewModel.output.bitcoinRate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rate in
                self?.bitcoinRateLabel.text = String(format: "BTC: $%.2f", rate)
            }
            .store(in: &cancellables)

        viewModel.output.transactionGroups
            .receive(on: DispatchQueue.main)
            .sink { [weak self] groups in
                self?.groups = groups
                self?.transactionsTableView.reloadData()
            }
            .store(in: &cancellables)
    }

    @objc
    func addTransactionTapped() {
        viewModel.inputs.addTransactionTap()
    }
    
    @objc
    func addIncomeTapped() {
        viewModel.inputs.addIncomeTap()
    }
}

// MARK: - UI

private extension MainViewController {
    func setupUI() {
        setupGradientBackground()
        setupScrollView()
        setupHeaderView()
        setupAddTransactionButton()
        setupTransactionsTableView()
    }
    
    func setupGradientBackground() {
        backgroundGradient.applyMainBackgroundGradient()
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setupHeaderView() {
        contentView.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        setupHeaderGradient()
        setupBalanceSection()
        setupBitcoinRateSection()
        setupHeaderConstraints()
    }
    
    func setupHeaderGradient() {
        headerGradient.applyHeaderBackgroundGradient()
        headerGradient.masksToBounds = true
        headerView.layer.insertSublayer(headerGradient, at: 0)
        headerView.layer.cornerRadius = DesignSystem.CornerRadius.large
        headerView.layer.masksToBounds = false
        headerView.layer.applyHeaderShadow()
    }
    
    func setupBalanceSection() {
        let balanceStackView = UIStackView()
        balanceStackView.axis = .vertical
        balanceStackView.spacing = DesignSystem.Spacing.medium
        balanceStackView.alignment = .center
        
        let balanceTitleLabel = UILabel()
        balanceTitleLabel.text = Constants.balanceTitle
        balanceTitleLabel.textColor = .textColorWhiteAlpha90
        balanceTitleLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        balanceLabel.textColor = .textColorWhite
        balanceLabel.font = .systemFont(ofSize: 36, weight: .bold)
        balanceLabel.text = Constants.defaultBalanceTitle
        balanceLabel.shadowColor = .shadowColor
        balanceLabel.shadowOffset = CGSize(width: 0, height: 2)
        
        var config = UIButton.Configuration.filled()
        config.title = Constants.addIncomeTitle
        config.baseBackgroundColor = .glassWhiteAlpha20
        config.baseForegroundColor = .textColorWhite
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(
            top: DesignSystem.Spacing.medium,
            leading: DesignSystem.Spacing.large,
            bottom: DesignSystem.Spacing.medium,
            trailing: DesignSystem.Spacing.large
        )

        addIncomeButton.configuration = config
        addIncomeButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        addIncomeButton.layer.cornerRadius = DesignSystem.CornerRadius.large
        addIncomeButton.layer.borderWidth = DesignSystem.BorderWidth.thin
        addIncomeButton.layer.borderColor = DesignSystem.Colors.glassWhiteAlpha20.cgColor
        addIncomeButton.layer.masksToBounds = true
        addIncomeButton.addTarget(self, action: #selector(addIncomeTapped), for: .touchUpInside)
        
        balanceStackView.addArrangedSubview(balanceTitleLabel)
        balanceStackView.addArrangedSubview(balanceLabel)
        balanceStackView.addArrangedSubview(addIncomeButton)
        
        headerView.addSubview(balanceStackView)
        balanceStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            balanceStackView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            balanceStackView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            balanceStackView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: DesignSystem.Spacing.large),
            addIncomeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupBitcoinRateSection() {
        let rateContainer = UIView()
        rateContainer.backgroundColor = .glassWhiteAlpha15
        rateContainer.layer.cornerRadius = DesignSystem.CornerRadius.medium
        rateContainer.layer.borderWidth = DesignSystem.BorderWidth.thin
        rateContainer.layer.borderColor = DesignSystem.Colors.glassWhiteAlpha20.cgColor
        
        bitcoinRateLabel.textColor = .textColorWhite
        bitcoinRateLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        bitcoinRateLabel.textAlignment = .center
        bitcoinRateLabel.text = Constants.defaultBitcoinRateTitle
        
        rateContainer.addSubview(bitcoinRateLabel)
        bitcoinRateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(rateContainer)
        rateContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            rateContainer.topAnchor.constraint(equalTo: headerView.topAnchor, constant: DesignSystem.Spacing.large),
            rateContainer.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -DesignSystem.Spacing.large),
            rateContainer.heightAnchor.constraint(equalToConstant: 30),
            
            bitcoinRateLabel.topAnchor.constraint(equalTo: rateContainer.topAnchor, constant: 0),
            bitcoinRateLabel.bottomAnchor.constraint(equalTo: rateContainer.bottomAnchor, constant: 0),
            bitcoinRateLabel.leadingAnchor.constraint(equalTo: rateContainer.leadingAnchor, constant: 12),
            bitcoinRateLabel.trailingAnchor.constraint(equalTo: rateContainer.trailingAnchor, constant: -12)
        ])
    }
    
    func setupHeaderConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DesignSystem.Spacing.large),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DesignSystem.Spacing.large),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DesignSystem.Spacing.large),
            headerView.heightAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    func setupAddTransactionButton() {
        contentView.addSubview(addTransactionButton)
        addTransactionButton.translatesAutoresizingMaskIntoConstraints = false
        
        addTransactionButton.setTitle(Constants.addTransactionTitle, for: .normal)
        addButtonGradient.applyButtonBackgroundGradient()
        addButtonGradient.masksToBounds = true
        addTransactionButton.layer.insertSublayer(addButtonGradient, at: 0)
        addTransactionButton.layer.cornerRadius = DesignSystem.CornerRadius.extraLarge
        addTransactionButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        addTransactionButton.setTitleColor(.textColorWhite, for: .normal)
        addTransactionButton.addTarget(self, action: #selector(addTransactionTapped), for: .touchUpInside)
        addTransactionButton.layer.applyButtonShadow()
        
        NSLayoutConstraint.activate([
            addTransactionButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: DesignSystem.Spacing.extraLarge),
            addTransactionButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addTransactionButton.heightAnchor.constraint(equalToConstant: 55),
            addTransactionButton.widthAnchor.constraint(equalToConstant: 220)
        ])
    }
    
    func setupTransactionsTableView() {
        contentView.addSubview(transactionsTableView)
        transactionsTableView.translatesAutoresizingMaskIntoConstraints = false
        transactionsTableView.delegate = self
        transactionsTableView.dataSource = self
        transactionsTableView.register(TransactionCell.self)
        transactionsTableView.register(TransactionHeaderView.self)
        transactionsTableView.separatorStyle = .none
        transactionsTableView.backgroundColor = .clear
        transactionsTableView.showsVerticalScrollIndicator = false
        
        NSLayoutConstraint.activate([
            transactionsTableView.topAnchor.constraint(equalTo: addTransactionButton.bottomAnchor, constant: DesignSystem.Spacing.extraLarge),
            transactionsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DesignSystem.Spacing.large),
            transactionsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DesignSystem.Spacing.large),
            transactionsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            transactionsTableView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        groups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groups[section].transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TransactionCell = tableView.dequeueReusableCell(for: indexPath)
        let viewModel = groups[indexPath.section].transactions[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView: TransactionHeaderView = tableView.dequeueReusableHeaderFooter()
        headerView.configure(with: groups[section].date)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == groups[indexPath.section].transactions.count - 1 {
            viewModel.inputs.loadMore()
        }
    }
}
