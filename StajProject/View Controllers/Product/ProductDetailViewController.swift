//
//  ProductDetailViewController.swift
//  StajProject
//
//  Created by Abdulsalam ALROAS
//

import UIKit

class ProductDetailViewController: UIViewController {
    var productsDetail = [ProductDetail]()
    @IBOutlet weak var pagelabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var product_price: UILabel!
    @IBOutlet weak var productBody: UITextView!
    @IBOutlet weak var productLabel: UILabel!
    var getProductId =  Int()
    @IBOutlet weak var category: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getProductDetils()
    }
}


// MARK: - Networking
extension ProductDetailViewController {
    
    func getProductDetils() {
        var baseString = "\(api.product_single)\(getProductId)"
        guard let apiURL = URL(string: baseString) else { return }
        var request = URLRequest(url: apiURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                print("# error occured - while session: \(error?.localizedDescription)")
                return
            }
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] else {
                    return
                }
         
                guard let retrievedDataArray = json as? [String: Any] else {
                    return
                }
  
                 
                        let id = retrievedDataArray["id"] as! Int
                        let title = retrievedDataArray["title"] as! String
                        let description = retrievedDataArray["description"] as! String
                        let image = retrievedDataArray["image"] as! String
                        let category = retrievedDataArray["category"] as! String
                        let price = retrievedDataArray["price"] as! Double
               
                        let productObj = ProductDetail(id: id, title: title, image: image, price: price, category: category, description: description)
                        self.productsDetail.append(productObj)
                  
                OperationQueue.main.addOperation({
                    self.showDetails()
                })
                
            } catch let err {
                print("# error occured - while json parsing: \(err.localizedDescription)")
            }
            }.resume()
        
    }
        
        
        func showDetails(){
            for detail in productsDetail{
                pagelabel.text = detail.title
                productLabel.text = "Product Name:" + detail.title
                productBody.text = detail.description
                product_price.text  = "Product Price:" +  "$ \(detail.price)"
                category.text  = "Product Category:" + detail.category
               
                let url = URL(string: "\(detail.image)" as! String)
                if url != nil {
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            if data != nil {
                                self.productImage.image = UIImage(data:data!)
                            }else{
                                self.productImage.image = UIImage(named: "2")
                            }
                        }
                    }
                }
                
                
             }
        }
    
}

extension ProductDetailViewController {
    @IBAction private func backButtonTouched() {
        self.dismiss(animated: true)
    }
}

