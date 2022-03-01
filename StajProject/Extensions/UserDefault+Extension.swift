//
//  File.swift
//  StajProject
//
//  Created by Abdulsalam ALROAS
//

import Foundation


import Foundation
import UIKit

extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        //NSAttributedStringKey.foregroundColor : UIColor.blue
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}


extension UserDefaults {
 
    var username: String? {
        set {
            setValue(newValue, forKey: #function)
        }
        get {
            string(forKey: #function)
        }
    }
    
    var userID: String? {
        set {
            setValue(newValue, forKey: #function)
        }
        get {
            string(forKey: #function)
        }
    }
    
    var password: String? {
        set {
            setValue(newValue, forKey: #function)
        }
        get {
            string(forKey: #function)
        }
    }
    
    var accessToken: String? {
        set {
            setValue(newValue, forKey: #function)
        }
        get {
            string(forKey: #function)
        }
    }
    
    func removeAll() {
        let dictionary = dictionaryRepresentation()
        dictionary.keys.forEach { key in
            removeObject(forKey: key)
        }
    }
    
}


