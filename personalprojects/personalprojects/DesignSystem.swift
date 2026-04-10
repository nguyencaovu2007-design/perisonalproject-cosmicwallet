//
//  DesignSystem.swift
//  personalprojects
//
//  Created by Nguyen on 18/3/26.
//

import SwiftUI
import Combine

extension Color {
    static let appPrimary = Color(red: 0.00, green: 0.48, blue: 1.00)
    static let appSecondary = Color(red: 0.20, green: 0.60, blue: 1.00)
    
    static let appBackground    = Color("AppBackground")
    static let appSecondaryBG   = Color("AppSecondaryBG")
    static let appTertiaryBG    = Color("AppTertiaryBG")
    static let appGroupedBG     = Color("AppGroupedBG")
    static let appCardBG        = Color("AppCardBG")
    
    // LaBel Colors
    
    static let appLabel = Color("AppLabel")
    static let appSecondaryLabel = Color("AppSecondaryLabel")
    static let appTertiaryLabel = Color("AppTertiaryLabel")
    static let appPlaceholder = Color("AppPlaceholder")
    
    static let appSeparator = Color("AppSeparator")
    
    // System Colors
    
    static let appGreen = Color(red: 0.20, green: 0.78, blue: 0.35)
    static let appRed = Color(red: 1.00, green: 0.23, blue: 0.19)
    static let appOrange = Color(red: 1.00, green: 0.58, blue: 0.00)
    static let appPurple = Color(red: 0.69, green: 0.32, blue: 1.00)
    static let appTeal = Color(red: 0.19, green: 0.82, blue: 0.75)
    static let appIndigo = Color(red: 0.35, green: 0.35, blue: 0.84)
    
    static let ewalletRed = appPrimary
    static let ewalletPink = appSecondary
    static let ewalletLightPink = appPrimary.opacity(0.12)
    static let ewalletDark = appLabel
    static let ewalletCardBG = appCardBG
    static let ewalletGray = appSecondaryLabel
    static let ewalletLightGray = appGroupedBG
    static let ewalletGreen = appGreen
    static let ewalletBlue = appPrimary
    
    
    // Mode ligt and dark
    extension Color {
        init(light: Color, dark: Color) {
            self = Color(UIColor { traiCollection in traiCollection.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
            })
        }
    }
    
    struct AppFont {
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
        static let title1 = Font.system(size: 28, weight: .bold, design: .rounded)
        static let title2 = Font.system(size: 22, weight: .bold, design: .rounded)
        static let title3 = Font.system(size: 20, weight: .semibold, design: .rounded)
        static let headline = Font.system(size: 17, weight: .semibold, design: .default)
        static let body = Font.system(size: 17, weight: .regular, design: .default)
        static let callout = Font.system(size: 16, weight: .regular, design: .default)
        static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
        static let footnote = Font.system(size: 13, weight: .regular, design: .default)
        static let caption1 = Font.system(size: 12, weight: .regular, design: .default)
        static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
        
        // Numberic
        static let ewalletLarge = Font.system(size: 34, weight: .bold, design: .rounded)
        static let ewalletMedium = Font.system(size: 22, weight: .semibold, design: .rounded)
        static let ewalletSmall = Font.system(size: 15, weight: .medium, design: .rounded)
        
    }
    
    // Spacing, Radius
    
    struct AppSpacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 12
        static let lg: CGFloat = 16
        static let xl: CGFloat = 20
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
    }
    
    struct AppRadius {
        static let sm: CGFloat = 10
        static let md: CGFloat = 14
        static let lg: CGFloat = 20
        static let xl: CGFloat = 28
        static let pill: CGFloat = 999
    }
    
    extension View {
        func appCardShadow() -> some View {
            self.shadow(color: .black.opacity(0.08), radius: 20, x: 0, y: 4)
                .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 1)
        }
        func appElevatedShadow() -> some View {
            self.shadow(color: .black.opacity(0.12), radius: 30, x: 0, y: 8)
                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
        }
        func appButtonShadow() -> some View {
            self.shadow(color: .black.opacity(0.35), radius: 12, x: 0, y: 6)
        }
    }
    
    extension Double {
        var vndFormatted: String {
            let abs = Swift.abs(Int(self))
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.groupingSeparator = "."
            let num = formatter.string(from: NSNumber(value: abs)) ?? "\(abs)"
            return "\(num)"
        }
        
        var vndCompar: String {
            let abs = Swift.abs(self)
            switch abs {
            case 1_000_000_000...:
                return String(format: "%.1fT đ", abs / 1_000_000_000)
            case 1_000_000...:
                return String(format: "%.1fM đ", abs / 1_000_000)
            case 1_000...:
                return String(format: "%.0fK đ", abs / 1_000)
            default:
                return vndFormatted
            }
        }
    }
}
