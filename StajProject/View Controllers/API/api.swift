//
//  api.swift
//  StajProject
//
//  Created by Abdulsalam ALROAS
//

import Foundation
struct api {
    static let base_api = URL(string: "https://fakestoreapi.com/")!
    static let products = URL(string:"\(base_api)products")!
    static let categories = URL(string:"\(base_api)/products/categories")!
    static let product_single = URL(string:"\(base_api)products/")!
    static let cart = URL(string:"\(base_api)carts/user/")!
    static let logout = URL(string:"\(base_api)logout")!
    static let login = URL(string:"\(base_api)/auth/login")!
    
}
