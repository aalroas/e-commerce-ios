//
//  Product.swift
//  StajProject
//
//  Created by Abdulsalam ALROAS
//

import Foundation

struct Cart {
    var id: Int
    var userId: Int
    var products: [Products]
}

struct Products {
    var productId: Int
    var quantity: Int
}
