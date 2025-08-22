//
//  TransactionCell.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 22.08.2025.
//

import UIKit

final class TransactionCell: UITableViewCell {
    // MARK: - Private Properties
    
    private let containerView = UIView()
    private let categoryIconLabel = UILabel()
    private let categoryLabel = UILabel()
    private let amountLabel = UILabel()
    private let timeLabel = UILabel()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let gradientLayer = containerView.layer.sublayers?.first as? CAGradientLayer {
            gradientLayer.frame = containerView.bounds
        }
    }
    
    // MARK: - Public Methods
    
    func configure(with transaction: Transaction) {
        switch transaction.type {
        case .income:
            categoryIconLabel.text = "💰"
            categoryLabel.text = "Income"
        case .expense(let transactionCategory):
            categoryIconLabel.text = transactionCategory.icon
            categoryLabel.text = transactionCategory.displayName
        }
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        timeLabel.text = formatter.string(from: transaction.date)
        
        switch transaction.type {
        case .income:
            amountLabel.text = String(format: "+%.4f BTC", transaction.amount)
            amountLabel.textColor = .successGreen
        case .expense:
            amountLabel.text = String(format: "-%.4f BTC", transaction.amount)
            amountLabel.textColor = .errorRed
        }
    }
}

// MARK: - Private Methods

private extension TransactionCell {
    func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        setupContainerView()
        setupCategoryIcon()
        setupLabels()
        setupConstraints()
    }
    
    func setupContainerView() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.applyCardBackgroundGradient()
//        containerView.layer.insertSublayer(gradientLayer, at: 0)
        containerView.layer.cornerRadius = DesignSystem.CornerRadius.medium
        containerView.layer.borderWidth = DesignSystem.BorderWidth.thin
        containerView.layer.borderColor = DesignSystem.Colors.glassWhiteAlpha10.cgColor
        containerView.layer.applyCardShadow()
        containerView.backgroundColor = DesignSystem.Colors.glassWhiteAlpha05
//        DispatchQueue.main.async {
//            gradientLayer.frame = self.containerView.bounds
//        }
    }
    
    func setupCategoryIcon() {
        let iconContainer = UIView()
        iconContainer.backgroundColor = .glassWhiteAlpha15
        iconContainer.layer.cornerRadius = DesignSystem.CornerRadius.large
        iconContainer.layer.borderWidth = DesignSystem.BorderWidth.thin
        iconContainer.layer.borderColor = DesignSystem.Colors.glassWhiteAlpha20.cgColor
        
        containerView.addSubview(iconContainer)
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        
        categoryIconLabel.font = .systemFont(ofSize: 20)
        categoryIconLabel.textAlignment = .center
        
        iconContainer.addSubview(categoryIconLabel)
        categoryIconLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: DesignSystem.Spacing.large),
            iconContainer.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 40),
            iconContainer.heightAnchor.constraint(equalToConstant: 40),
            
            categoryIconLabel.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            categoryIconLabel.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor)
        ])
    }
    
    func setupLabels() {
        containerView.addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        categoryLabel.textColor = .textColorWhite
        
        containerView.addSubview(amountLabel)
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.font = .systemFont(ofSize: 18, weight: .bold)
        amountLabel.textAlignment = .right
        
        containerView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.font = .systemFont(ofSize: 12, weight: .medium)
        timeLabel.textColor = .textColorWhiteAlpha70
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DesignSystem.Spacing.small),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DesignSystem.Spacing.medium),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DesignSystem.Spacing.medium),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DesignSystem.Spacing.small),
            
            categoryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 72),
            categoryLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: DesignSystem.Spacing.large),
            categoryLabel.trailingAnchor.constraint(equalTo: amountLabel.leadingAnchor, constant: -12),
            
            amountLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -DesignSystem.Spacing.large),
            amountLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: DesignSystem.Spacing.large),
            amountLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80),
            
            timeLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: DesignSystem.Spacing.small),
            timeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -DesignSystem.Spacing.large)
        ])
    }
}
