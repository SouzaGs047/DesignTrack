//
//  ColorExtensions.swift
//  TesteColorPicker
//
//  Created by HENRIQUE LEAL PEREIRA DOS SANTOS on 30/01/25.
//
import SwiftUI

extension Color {

    func toHex(includeAlpha: Bool = false) -> String? {
        guard let components = UIColor(self).cgColor.components else { return nil }
        
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
        
        if includeAlpha, components.count >= 4 {
            let a = Int(components[3] * 255)
            return String(format: "#%02X%02X%02X%02X", r, g, b, a)
        }
        
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}

extension Color {
    init?(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            print("Erro: Código hexadecimal inválido - \(hex)")
            return nil
        }
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        let a = hexSanitized.count == 8 ? Double((rgb >> 24) & 0xFF) / 255.0 : 1.0
        
        guard !(r.isNaN || g.isNaN || b.isNaN || a.isNaN) else {
            print("Erro: Valores de cor inválidos (NaN) - \(hex)")
            return nil
        }
        
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
