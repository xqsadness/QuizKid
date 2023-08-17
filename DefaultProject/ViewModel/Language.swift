//
//  Language.swift
//  DefaultProject
//
//  Created by darktech4 on 15/08/2023.
//

import Foundation
import UIKit


private var bundleKey: UInt8 = 0

final class BundleExtension: Bundle {
    
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        return (objc_getAssociatedObject(self, &bundleKey) as? Bundle)?.localizedString(forKey: key, value: value, table: tableName) ?? super.localizedString(forKey: key, value: value, table: tableName)
    }
}

extension Bundle {
    
    static let once: Void = { object_setClass(Bundle.main, type(of: BundleExtension())) }()
    
    static func set(language: Language) {
        Bundle.once
        
        let isLanguageRTL = Locale.characterDirection(forLanguage: language.code) == .rightToLeft
        UIView.appearance().semanticContentAttribute = isLanguageRTL == true ? .forceRightToLeft : .forceLeftToRight
        
        UserDefaults.standard.set(isLanguageRTL,   forKey: "AppleTe  zxtDirection")
        UserDefaults.standard.set(isLanguageRTL,   forKey: "NSForceRightToLeftWritingDirection")
        UserDefaults.standard.set([language.code], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        guard let path = Bundle.main.path(forResource: language.code, ofType: "lproj") else {
            print("Failed to get a bundle path.")
            return
        }
        
        objc_setAssociatedObject(Bundle.main, &bundleKey, Bundle(path: path), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}


enum Language: Equatable, Hashable {
    case english(English)
//    case chinese(Chinese)
//    case korean
//    case japanese
    
    enum English {
        case us
        case uk
        case australian
        case canadian
        case indian
    }
    
//    enum Chinese {
//        case simplified
//        case traditional
//        case hongKong
//    }
    case vietnamese
    case french
    var displayName: String { 
        switch self {
        case .english(let english):
            switch english {
            case .us: return "English (US)"
            case .uk: return "English (UK)"
            case .australian: return "English (Australian)"
            case .canadian: return "English (Canadian)"
            case .indian: return "English (Indian)"
            }
//        case .chinese(let chinese):
//            switch chinese {
//            case .simplified: return "Chinese (Simplified)"
//            case .traditional: return "Chinese (Traditional)"
//            case .hongKong: return "Chinese (Hong Kong)"
//            }
//        case .korean: return "Korean"
//        case .japanese: return "Japanese"
        case .french: return "French"
        case .vietnamese: return "Vietnamese"
        }
    }
}

extension Language {
    
    var code: String {
        switch self {
        case .english(let english):
            switch english {
            case .us:                return "en"
            case .uk:                return "en-GB"
            case .australian:        return "en-AU"
            case .canadian:          return "en-CA"
            case .indian:            return "en-IN"
            }
            
//        case .chinese(let chinese):
//            switch chinese {
//            case .simplified:       return "zh-Hans"
//            case .traditional:      return "zh-Hant"
//            case .hongKong:         return "zh-HK"
//            }
            
//        case .korean:               return "ko"
//        case .japanese:             return "ja"
        case .vietnamese:        return "vi"
        case .french:        return "fr"
        }
    }
    
    var name: String {
        switch self {
        case .english(let english):
            switch english {
            case .us:                return "English"
            case .uk:                return "English (UK)"
            case .australian:        return "English (Australia)"
            case .canadian:          return "English (Canada)"
            case .indian:            return "English (India)"
            }
            
//        case .chinese(let chinese):
//            switch chinese {
//            case .simplified:       return "简体中文"
//            case .traditional:      return "繁體中文"
//            case .hongKong:         return "繁體中文 (香港)"
//            }
            
//        case .korean:               return "한국어"
//        case .japanese:             return "日本語"
        case .vietnamese:        return "Tiếng Việt"
        case .french:        return "French"
        }
    }
    
//    init?(languageCode: String?) {
//        guard let languageCode = languageCode else { return nil }
//        switch languageCode {
//        case "en", "en-US":     self = .english(.us)
//        case "en-GB":           self = .english(.uk)
//        case "en-AU":           self = .english(.australian)
//        case "en-CA":           self = .english(.canadian)
//        case "en-IN":           self = .english(.indian)
//
//        case "zh-Hans":         self = .chinese(.simplified)
//        case "zh-Hant":         self = .chinese(.traditional)
//        case "zh-HK":           self = .chinese(.hongKong)
//
//        case "ko":              self = .korean
//        case "ja":              self = .japanese
//        case "vi":              self = .vietnamese
//        default:                return nil
//        }
//    }
}
