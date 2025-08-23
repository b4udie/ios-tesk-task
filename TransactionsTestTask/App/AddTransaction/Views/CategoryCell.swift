//
//  CategoryCell.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 22.08.2025.
//

import UIKit

final class CategoryCell: UICollectionViewCell {
    // MARK: - Private Properties

    private let containerView = UIView()
    private let iconLabel = UILabel()
    private let titleLabel = UILabel()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    
        containerView.backgroundColor = DesignSystem.Colors.glassWhiteAlpha15
        containerView.layer.borderColor = DesignSystem.Colors.glassWhiteAlpha20.cgColor
        titleLabel.textColor = .white
    }
    
    // MARK: - Public Methods

    func configure(with category: TransactionCategory, isSelected: Bool) {
        iconLabel.text = category.icon
        titleLabel.text = category.displayName
        titleLabel.textColor = .white

        if isSelected {
            containerView.backgroundColor = DesignSystem.Colors.secondaryGreen90
            containerView.layer.borderColor = DesignSystem.Colors.secondaryGreen.cgColor
        } else {
            containerView.backgroundColor = DesignSystem.Colors.glassWhiteAlpha15
            containerView.layer.borderColor = DesignSystem.Colors.glassWhiteAlpha20.cgColor
        }
    }
}

// MARK: - Private Methods

private extension CategoryCell {
    func setupUI() {
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = DesignSystem.CornerRadius.medium
        containerView.layer.borderWidth = DesignSystem.BorderWidth.medium
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.layer.applyCardShadow()
        
        containerView.addSubview(iconLabel)
        containerView.addSubview(titleLabel)
        
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        iconLabel.font = .systemFont(ofSize: 28)
        iconLabel.textAlignment = .center
        
        titleLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 2
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            iconLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -4),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
    }
}
