//
//  TransactionHeaderView.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 22.08.2025.
//

import UIKit

final class TransactionHeaderView: UITableViewHeaderFooterView {
    // MARK: - Private Properties
    
    private let dateLabel = UILabel()
    
    // MARK: - Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(with dateString: String) {
        dateLabel.text = dateString
    }
}

// MARK: - Private Methods

private extension TransactionHeaderView {
    func setupUI() {
        contentView.backgroundColor = .clear
        
        setupHeaderContainer()
        setupDateLabel()
        setupConstraints()
    }
    
    func setupHeaderContainer() {
        let headerContainer = UIView()
        headerContainer.backgroundColor = .glassWhiteAlpha10
        headerContainer.layer.cornerRadius = DesignSystem.CornerRadius.small
        headerContainer.layer.borderWidth = DesignSystem.BorderWidth.thin
        headerContainer.layer.borderColor = DesignSystem.Colors.glassWhiteAlpha15.cgColor
        
        contentView.addSubview(headerContainer)
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DesignSystem.Spacing.medium),
            headerContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DesignSystem.Spacing.medium),
            headerContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DesignSystem.Spacing.small),
            headerContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -DesignSystem.Spacing.small)
        ])
        
        headerContainer.addSubview(dateLabel)
    }
    
    func setupDateLabel() {
        dateLabel.font = .systemFont(ofSize: 16, weight: .bold)
        dateLabel.textColor = .textColorWhite
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DesignSystem.Spacing.extraLarge),
            dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
