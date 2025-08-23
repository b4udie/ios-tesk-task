//
//  UICollectionView+Registration.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 24.08.2025.
//

import UIKit

extension UICollectionView {
    // MARK: Register Cell
    func register<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: String(describing: cellType))
    }
    
    // MARK: Register Supplementary View (Header/Footer)
    func register<T: UICollectionReusableView>(_ viewType: T.Type,
                                               forSupplementaryViewOfKind kind: String) {
        register(viewType,
                 forSupplementaryViewOfKind: kind,
                 withReuseIdentifier: String(describing: viewType))
    }
    
    // MARK: Dequeue Cell
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: String(describing: T.self),
            for: indexPath
        ) as? T else {
            fatalError("Could not dequeue cell with type \(T.self)")
        }
        return cell
    }
    
    // MARK: Dequeue Supplementary View
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
        ofKind kind: String,
        for indexPath: IndexPath
    ) -> T {
        guard let view = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: String(describing: T.self),
            for: indexPath
        ) as? T else {
            fatalError("Could not dequeue supplementary view with type \(T.self)")
        }
        return view
    }
}
