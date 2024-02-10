//
//  UIColor + ext.swift
//  MixColors
//
//  Created by Polina on 07.02.2024.
//
import UIKit
import Foundation
extension UIColor{
    var name: String? {
        let colorNames = Const.colors
        var shortestDistance: CGFloat = .infinity
        var closestColorName: String? = nil
        
        for (color, name) in colorNames {
            let rgbColor = convertHEXToRGB(color: color)
            guard let rgbColor = rgbColor else {return nil}
            let dist = distance(red: rgbColor.0, green: rgbColor.1, blue: rgbColor.2)
            
            if dist < shortestDistance {
                shortestDistance = dist
                closestColorName = name
            }
        }
        return closestColorName
    }
    
    private func distance(red: CGFloat, green: CGFloat, blue: CGFloat) -> CGFloat{
        var (r, g, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        self.getRed(&r, green: &g, blue: &b, alpha: &a)
        let distance = sqrt(pow(red - r, 2) + pow(green - g, 2) + pow(blue - b, 2))
        return distance
    }
    
    private func convertHEXToRGB(color: String) -> (CGFloat, CGFloat, CGFloat)?{
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var hexSanitized = color.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        let length = hexSanitized.count
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0

        } else {
            return nil
        }
        return(r,g,b)
    }
}

