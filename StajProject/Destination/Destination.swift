//
//  Destination.swift
//  StajProject
//
//  Created by Abdulsalam ALROAS
//

import Foundation
import UIKit
struct _Storyboard {
    static let main = UIStoryboard.init(name: "Main", bundle: nil)
}

struct Destination {
    let detail = _Storyboard.main.instantiateViewController(withIdentifier: "product") as! ProductDetailViewController
}
