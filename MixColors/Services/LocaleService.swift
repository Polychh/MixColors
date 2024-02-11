//
//  LocoleService.swift
//  MixColors
//
//  Created by Polina on 07.02.2024.
//

import Foundation

protocol LocaleServiceProtocol {
    var language: Language { get }
    var languagePublisher: Published<Language>.Publisher { get }
    func saveLanguage(_ lang: String)
    func choseSegment(segIndex: Int)
}

enum Language: String {
    case english = "en"
    case russian = "ru"
}

final class LocaleService: LocaleServiceProtocol{
   @Published var language = Language.russian
   var languagePublisher: Published<Language>.Publisher { $language }
       
    func saveLanguage(_ lang: String) {
        UserDefaults.standard.set(lang, forKey: Const.keyLang)
        UserDefaults.standard.synchronize()
    }
    
    func choseSegment(segIndex: Int){
        switch segIndex{
        case 0: updateLanguage(lang: Language.russian.rawValue)
        case 1: updateLanguage(lang: Language.english.rawValue)
        default: break
        }
    }
    
    private func updateLanguage(lang: String) {
        saveLanguage(lang)
        guard let lang = Language(rawValue: lang) else {return}
        language = lang
    }
}

