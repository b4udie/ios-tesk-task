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
    
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        titleLabel.textColor = .white
    }
    
    // MARK: - Public Methods

    func configure(with category: TransactionCategory, isSelected: Bool) {
        iconLabel.text = category.icon
        titleLabel.text = category.displayName
        
        if isSelected {
            containerView.backgroundColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 0.9)
            containerView.layer.borderColor = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0).cgColor
            titleLabel.textColor = .white
        } else {
            containerView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
            containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
            titleLabel.textColor = .white
        }
    }
}

// MARK: - Private Methods

private extension CategoryCell {
    func setupUI() {
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 16
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.clear.cgColor
        
        // Add subtle shadow
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.15
        
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
