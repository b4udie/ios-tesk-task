//
//  DesignSystem.swift
//  TransactionsTestTask
//
//  Created by Val Bratkevich on 22.08.2025.
//

import UIKit

struct DesignSystem {
    struct Colors {
        static let primaryBlue = UIColor(red: 0.2, green: 0.6, blue: 1.0, alpha: 1.0)
        static let primaryPurple = UIColor(red: 0.4, green: 0.2, blue: 0.8, alpha: 1.0)
        static let primaryPink = UIColor(red: 0.8, green: 0.2, blue: 0.6, alpha: 1.0)
        static let secondaryGreen = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 1.0)
        static let secondaryGreen90 = UIColor(red: 0.2, green: 0.8, blue: 0.4, alpha: 0.9)
        static let secondaryDarkGreen = UIColor(red: 0.1, green: 0.6, blue: 0.3, alpha: 1.0)
        static let backgroundDark = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)
        static let backgroundMedium = UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 1.0)
        static let backgroundLight = UIColor(red: 0.1, green: 0.2, blue: 0.4, alpha: 1.0)
        static let textWhite = UIColor.white
        static let textWhiteAlpha90 = UIColor.white.withAlphaComponent(0.9)
        static let textWhiteAlpha70 = UIColor.white.withAlphaComponent(0.7)
        static let textWhiteAlpha60 = UIColor.white.withAlphaComponent(0.6)
        static let textWhiteAlpha50 = UIColor.white.withAlphaComponent(0.5)
        static let successGreen = UIColor.systemGreen
        static let errorRed = UIColor.systemRed
        static let glassWhiteAlpha15 = UIColor.white.withAlphaComponent(0.15)
        static let glassWhiteAlpha10 = UIColor.white.withAlphaComponent(0.1)
        static let glassWhiteAlpha05 = UIColor.white.withAlphaComponent(0.05)
        static let glassWhiteAlpha20 = UIColor.white.withAlphaComponent(0.2)
    }
    
    struct Shadows {
        static let shadowColor = UIColor.black
        static let shadowColorGreen = Colors.secondaryGreen
        
        struct Header {
            static let offset = CGSize(width: 0, height: 8)
            static let radius: CGFloat = 20
            static let opacity: Float = 0.3
        }
        
        struct Button {
            static let offset = CGSize(width: 0, height: 8)
            static let radius: CGFloat = 15
            static let opacity: Float = 0.4
        }
        
        struct Card {
            static let offset = CGSize(width: 0, height: 4)
            static let radius: CGFloat = 8
            static let opacity: Float = 0.15
        }
    }
    
    struct Gradients {
        static let mainBackground: [CGColor] = [
            Colors.backgroundDark.cgColor,
            Colors.backgroundMedium.cgColor,
            Colors.backgroundLight.cgColor
        ]
        
        static let headerBackground: [CGColor] = [
            Colors.primaryBlue.cgColor,
            Colors.primaryPurple.cgColor,
            Colors.primaryPink.cgColor
        ]
        
        static let buttonBackground: [CGColor] = [
            Colors.secondaryGreen.cgColor,
            Colors.secondaryDarkGreen.cgColor
        ]
        
        static let cardBackground: [CGColor] = [
            Colors.glassWhiteAlpha10.cgColor,
            Colors.glassWhiteAlpha05.cgColor
        ]
    }
    
    struct CornerRadius {
        static let small: CGFloat = 12
        static let medium: CGFloat = 16
        static let large: CGFloat = 20
        static let extraLarge: CGFloat = 25
    }
    
    struct Spacing {
        static let small: CGFloat = 4
        static let medium: CGFloat = 8
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
    }
    
    struct BorderWidth {
        static let thin: CGFloat = 1
        static let medium: CGFloat = 2
    }
}

extension UIColor {
    static let primaryBlue = DesignSystem.Colors.primaryBlue
    static let primaryPurple = DesignSystem.Colors.primaryPurple
    static let primaryPink = DesignSystem.Colors.primaryPink
    static let secondaryGreen = DesignSystem.Colors.secondaryGreen
    static let secondaryDarkGreen = DesignSystem.Colors.secondaryDarkGreen
    static let backgroundDark = DesignSystem.Colors.backgroundDark
    static let backgroundMedium = DesignSystem.Colors.backgroundMedium
    static let backgroundLight = DesignSystem.Colors.backgroundLight
    static let textColorWhite = DesignSystem.Colors.textWhite
    static let textColorWhiteAlpha90 = DesignSystem.Colors.textWhiteAlpha90
    static let textColorWhiteAlpha70 = DesignSystem.Colors.textWhiteAlpha70
    static let textColorWhiteAlpha50 = DesignSystem.Colors.textWhiteAlpha50
    static let successGreen = DesignSystem.Colors.successGreen
    static let errorRed = DesignSystem.Colors.errorRed
    static let glassWhiteAlpha15 = DesignSystem.Colors.glassWhiteAlpha15
    static let glassWhiteAlpha10 = DesignSystem.Colors.glassWhiteAlpha10
    static let glassWhiteAlpha05 = DesignSystem.Colors.glassWhiteAlpha05
    static let glassWhiteAlpha20 = DesignSystem.Colors.glassWhiteAlpha20
    static let shadowColor = DesignSystem.Shadows.shadowColor
    static let shadowColorGreen = DesignSystem.Shadows.shadowColorGreen
}

extension CALayer {
    func applyHeaderShadow() {
        shadowColor = DesignSystem.Shadows.shadowColor.cgColor
        shadowOffset = DesignSystem.Shadows.Header.offset
        shadowRadius = DesignSystem.Shadows.Header.radius
        shadowOpacity = DesignSystem.Shadows.Header.opacity
    }
    
    func applyButtonShadow() {
        shadowColor = DesignSystem.Shadows.shadowColorGreen.cgColor
        shadowOffset = DesignSystem.Shadows.Button.offset
        shadowRadius = DesignSystem.Shadows.Button.radius
        shadowOpacity = DesignSystem.Shadows.Button.opacity
    }
    
    func applyCardShadow() {
        shadowColor = DesignSystem.Shadows.shadowColor.cgColor
        shadowOffset = DesignSystem.Shadows.Card.offset
        shadowRadius = DesignSystem.Shadows.Card.radius
        shadowOpacity = DesignSystem.Shadows.Card.opacity
    }
}

extension CAGradientLayer {
    func applyMainBackgroundGradient() {
        colors = DesignSystem.Gradients.mainBackground
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 1, y: 1)
    }
    
    func applyHeaderBackgroundGradient() {
        colors = DesignSystem.Gradients.headerBackground
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 1, y: 1)
    }
    
    func applyButtonBackgroundGradient() {
        colors = DesignSystem.Gradients.buttonBackground
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 1, y: 1)
    }
    
    func applyCardBackgroundGradient() {
        colors = DesignSystem.Gradients.cardBackground
        startPoint = CGPoint(x: 0, y: 0)
        endPoint = CGPoint(x: 1, y: 1)
    }
}
