//
//  String + Ext.swift
//  MixColors
//
//  Created by Polina on 06.02.2024.
//

import Foundation

extension String{
    var localized: String {
          let lang = currentLanguage()
          let path = Bundle.main.path(forResource: lang, ofType: "lproj")
          let bundle = Bundle(path: path!)
          return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
      }
    
      private func currentLanguage() -> String {
          return UserDefaults.standard.string(forKey: Const.keyLang) ?? ""
      }
}
