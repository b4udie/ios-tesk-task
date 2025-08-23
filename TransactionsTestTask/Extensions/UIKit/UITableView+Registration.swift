//
//  UITableView+Registration.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 24.08.2025.
//

import UIKit

extension UITableView {
    // MARK: Register Cell
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: String(describing: cellType))
    }
    
    // MARK: Register Header/Footer
    func register<T: UITableViewHeaderFooterView>(_ viewType: T.Type) {
        register(viewType, forHeaderFooterViewReuseIdentifier: String(describing: viewType))
    }
    
    // MARK: Dequeue Cell
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withIdentifier: String(describing: T.self),
            for: indexPath
        ) as? T else {
            fatalError("Could not dequeue cell with type \(T.self)")
        }
        return cell
    }
    
    // MARK: Dequeue Header/Footer
    func dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(
            withIdentifier: String(describing: T.self)
        ) as? T else {
            fatalError("Could not dequeue header/footer with type \(T.self)")
        }
        return view
    }
}
