//
//  AddTransactionViewController.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 22.08.2025.
//

import UIKit
import Combine

final class AddTransactionViewController: UIViewController {
    // MARK: - Private Properties

    private let viewModel: AddTransactionViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let amountTextField = UITextField()
    private let categoryCollectionView: UICollectionView
    private let addButton = UIButton()
    private var amountContainer: UIView!
    private var categoryContainer: UIView!
    
    private let backgroundGradient = CAGradientLayer()
    private let addButtonGradient = CAGradientLayer()

    private let categoryLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.itemSize = CGSize(width: 100, height: 80)
        return layout
    }()
    
    // MARK: - Lifecycle

    init(viewModel: AddTransactionViewModel) {
        self.viewModel = viewModel
        self.categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: categoryLayout)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
        setupBindings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        backgroundGradient.frame = view.bounds
        addButtonGradient.frame = addButton.bounds
        addButtonGradient.cornerRadius = DesignSystem.CornerRadius.extraLarge
        CATransaction.commit()
    }
        
    // MARK: - Actions

    @objc
    private func cancelTapped() {
        viewModel.cancel()
    }
    
    @objc
    private func addTapped() {
        viewModel.addTransaction()
    }
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension AddTransactionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return TransactionCategory.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        let category = TransactionCategory.allCases[indexPath.item]
        let isSelected = category == viewModel.selectedCategory
        cell.configure(with: category, isSelected: isSelected)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = TransactionCategory.allCases[indexPath.item]
        viewModel.setCategory(category)
        collectionView.reloadData()
    }
}

// MARK: - Private Methods

private extension AddTransactionViewController {
    func setupUI() {
        backgroundGradient.applyMainBackgroundGradient()
        view.layer.insertSublayer(backgroundGradient, at: 0)
        
        navigationItem.title = "💸 New Transaction"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = .textColorWhite
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        setupAmountSection()
        setupCategorySection()
        setupAddButton()
    }

    func setupAmountSection() {
        amountContainer = UIView()
        amountContainer.backgroundColor = .glassWhiteAlpha10
        amountContainer.layer.cornerRadius = DesignSystem.CornerRadius.medium
        amountContainer.layer.borderWidth = DesignSystem.BorderWidth.thin
        amountContainer.layer.borderColor = DesignSystem.Colors.glassWhiteAlpha20.cgColor
        
        contentView.addSubview(amountContainer)
        amountContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let amountLabel = UILabel()
        amountLabel.text = "💰 Amount (BTC)"
        amountLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        amountLabel.textColor = .textColorWhite
        
        amountTextField.placeholder = "0.0"
        amountTextField.keyboardType = .decimalPad
        amountTextField.font = .systemFont(ofSize: 20, weight: .medium)
        amountTextField.borderStyle = .none
        amountTextField.backgroundColor = .glassWhiteAlpha15
        amountTextField.layer.cornerRadius = DesignSystem.CornerRadius.small
        amountTextField.textColor = .textColorWhite
        amountTextField.attributedPlaceholder = NSAttributedString(
            string: "0.0",
            attributes: [NSAttributedString.Key.foregroundColor: DesignSystem.Colors.textWhiteAlpha60]
        )
        amountTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: DesignSystem.Spacing.large, height: 0))
        amountTextField.leftViewMode = .always
        
        amountContainer.addSubview(amountLabel)
        amountContainer.addSubview(amountTextField)
        
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            amountContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: DesignSystem.Spacing.extraLarge),
            amountContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DesignSystem.Spacing.large),
            amountContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DesignSystem.Spacing.large),
            amountContainer.heightAnchor.constraint(equalToConstant: 120),
            
            amountLabel.topAnchor.constraint(equalTo: amountContainer.topAnchor, constant: 20),
            amountLabel.leadingAnchor.constraint(equalTo: amountContainer.leadingAnchor, constant: 20),
            
            amountTextField.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 12),
            amountTextField.leadingAnchor.constraint(equalTo: amountContainer.leadingAnchor, constant: 20),
            amountTextField.trailingAnchor.constraint(equalTo: amountContainer.trailingAnchor, constant: -20),
            amountTextField.bottomAnchor.constraint(equalTo: amountContainer.bottomAnchor, constant: -20),
            amountTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupCategorySection() {
        categoryContainer = UIView()
        categoryContainer.backgroundColor = .glassWhiteAlpha10
        categoryContainer.layer.cornerRadius = DesignSystem.CornerRadius.medium
        categoryContainer.layer.borderWidth = DesignSystem.BorderWidth.thin
        categoryContainer.layer.borderColor = DesignSystem.Colors.glassWhiteAlpha20.cgColor
        
        contentView.addSubview(categoryContainer)
        categoryContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let categoryLabel = UILabel()
        categoryLabel.text = "🏷️ Category"
        categoryLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        categoryLabel.textColor = .textColorWhite
        
        categoryContainer.addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        categoryCollectionView.backgroundColor = .clear
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        categoryCollectionView.showsHorizontalScrollIndicator = false
        
        categoryContainer.addSubview(categoryCollectionView)
        categoryCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryContainer.topAnchor.constraint(equalTo: amountContainer.bottomAnchor, constant: 32),
            categoryContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: DesignSystem.Spacing.large),
            categoryContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -DesignSystem.Spacing.large),
            categoryContainer.heightAnchor.constraint(equalToConstant: 160),

            categoryLabel.topAnchor.constraint(equalTo: categoryContainer.topAnchor, constant: 20),
            categoryLabel.leadingAnchor.constraint(equalTo: categoryContainer.leadingAnchor, constant: 20),

            categoryCollectionView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: DesignSystem.Spacing.large),
            categoryCollectionView.leadingAnchor.constraint(equalTo: categoryContainer.leadingAnchor, constant: 20),
            categoryCollectionView.trailingAnchor.constraint(equalTo: categoryContainer.trailingAnchor, constant: -20),
            categoryCollectionView.bottomAnchor.constraint(equalTo: categoryContainer.bottomAnchor, constant: -20)
        ])
    }
    
    func setupAddButton() {
        contentView.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        addButton.setTitle("✅ Add", for: .normal)
        
        addButtonGradient.applyButtonBackgroundGradient()
        addButtonGradient.masksToBounds = true
        addButton.layer.insertSublayer(addButtonGradient, at: 0)
        
        addButton.layer.cornerRadius = DesignSystem.CornerRadius.extraLarge
        addButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        addButton.setTitleColor(.textColorWhite, for: .normal)
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        addButton.layer.applyButtonShadow()
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: categoryContainer.bottomAnchor, constant: 32),
            addButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 55),
            addButton.widthAnchor.constraint(equalToConstant: 220),
            contentView.bottomAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 24)
        ])
        
        addButton.layoutIfNeeded()
    }
    
    func setupBindings() {
        amountTextField.textPublisher
            .sink { [weak self] text in
                self?.viewModel.amount = text
            }
            .store(in: &cancellables)
        
        viewModel.$isValid
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isValid in
                self?.addButton.isEnabled = isValid
                self?.addButton.alpha = isValid ? 1.0 : 0.6
            }
            .store(in: &cancellables)
    }
}

// MARK: - UITextField Publisher Extension
extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}
