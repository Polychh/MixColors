//
//  ColorViewModel.swift
//  MixColors
//
//  Created by Polina on 05.02.2024.
//


import UIKit
import Combine

protocol ViewModelProtocol {
    var color1: UIColor { get }
    var color2: UIColor { get }
    var language: Language {get}
    var color1Publisher: Published<UIColor>.Publisher { get }
    var color2Publisher: Published<UIColor>.Publisher { get }
    var languagePublisher: Published<Language>.Publisher { get }
    var colorArray: ColorModel {get}
    func mixedColors(color1: UIColor, color2: UIColor) -> UIColor
    func updateColor1(colorIndex: Int)
    func updateColor2(colorIndex: Int)
    func choseSegment(segIndex: Int)
    func saveInitialLang()
}

class ColorViewModel: ViewModelProtocol{
    @Published var color1: UIColor
    @Published var color2: UIColor
    @Published var language: Language
    
    var color1Publisher: Published<UIColor>.Publisher { $color1 }
    var color2Publisher: Published<UIColor>.Publisher { $color2 }
    var languagePublisher: Published<Language>.Publisher { $language }

    private let localeServ: LocaleServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(color1: UIColor = .white, color2: UIColor = .white, language: Language = .russian, localeServ: LocaleServiceProtocol) {
        self.color1 = color1
        self.color2 = color2
        self.language = language
        self.localeServ = localeServ
        observe()
    }
    
    var colorArray = ColorModel(array: [ColorToMix(color: UIColor.black), ColorToMix(color: UIColor.green),ColorToMix(color: UIColor.red), ColorToMix(color: UIColor.blue), ColorToMix(color: UIColor.white), ColorToMix(color: UIColor.gray), ColorToMix(color: UIColor.orange),ColorToMix(color: UIColor.yellow), ColorToMix(color: UIColor.brown),ColorToMix(color: UIColor.purple), ColorToMix(color: UIColor.darkGray),ColorToMix(color: UIColor.link),ColorToMix(color: UIColor.magenta)])
    
    func mixedColors(color1: UIColor, color2: UIColor) -> UIColor{
        let firstColor = self.multiplyColor(color1, by: 0.5)
        let secondColor = self.multiplyColor(color2, by: 0.5)
        let mixedColor = addColor(firstColor, with: secondColor)
        return mixedColor
    }
    
    func updateColor1(colorIndex: Int){
        color1 = colorArray.array[colorIndex].color
    }
    
    func updateColor2(colorIndex: Int){
        color2 = colorArray.array[colorIndex].color
    }
    
    func choseSegment(segIndex: Int){
        localeServ.choseSegment(segIndex: segIndex)
    }
    
    func saveInitialLang(){
        localeServ.saveLanguage("ru")
    }
    
    private func observe(){
        localeServ.languagePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.language, on: self)
            .store(in: &cancellables)
    }
    
    private func addColor(_ color1: UIColor, with color2: UIColor) -> UIColor {
        var (r1, g1, b1, a1) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        var (r2, g2, b2, a2) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return UIColor(red: min(r1 + r2, 1), green: min(g1 + g2, 1), blue: min(b1 + b2, 1), alpha: (a1 + a2) / 2)
    }
    
    private func multiplyColor(_ color: UIColor, by multiplier: CGFloat) -> UIColor {
        var (r, g, b, a) = (CGFloat(0), CGFloat(0), CGFloat(0), CGFloat(0))
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return UIColor(red: r * multiplier, green: g * multiplier, blue: b * multiplier, alpha: a)
    }
}
