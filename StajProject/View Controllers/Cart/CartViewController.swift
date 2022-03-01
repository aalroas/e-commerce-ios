//
//  CartViewController.swift
//  StajProject
//
//  Created by Abdulsalam ALROAS
//

import UIKit

class CartViewController:  UIViewController{
   
    @IBOutlet weak var tableView: UITableView!
    private var Products = [Cart]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.getCart()
    }
    
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: - Networking
extension CartViewController {
    
    private func getCart() {
        let session = URLSession.shared
        let urlString = api.cart + UserDefaults.standard.userID
        let url = URL(string: urlString)
        let request = NSMutableURLRequest(url: url!)
                request.httpMethod = "GET"
                do{
                    let task = session.dataTask(with: request as URLRequest as URLRequest, completionHandler: {(data, response, error) in
                        if let response = response {
                            let nsHTTPResponse = response as! HTTPURLResponse
                            let statusCode = nsHTTPResponse.statusCode
                            print ("status code = \(statusCode)")
                        }
                        if let error = error {
                            print ("\(error)")
                        }
                        if let data = data {
                            do{
                                let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
                                let retrievedDataArray = json as! [Any]
                                        for retrievedData in retrievedDataArray {
                                            let cardDict = retrievedData as! [String: Any]
                                            let id = cardDict["id"] as! Int
                                            let userId = cardDict["userId"] as! Int
                                        
                                            for pro in cardDict["products"] as! [[String: Int]] {
                                                    let productId = pro["productId"] as! Int
                                                    let quantity = pro["quantity"] as! Int
                                                    let proObj = Products(productId: productId,quantity:quantity)
                                            }
                                            let cartObj = Cart(id: id, userId: userId, products: proObj )
                                            self.Products.append(cartObj)
                                        }
                                        self.updateUI()
                               
                            }catch _ {
                                print ("OOps not good JSON formatted response")
                            }
                        }
                    })
                    task.resume()
                }
                }
    
}




extension CartViewController: UITableViewDelegate, UITableViewDataSource {
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return self.Products.count
      }
    
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = self.tableView.dequeueReusableCell(withIdentifier: "cart_cell") as! CartTableViewCell
          
            let targetOrder = Products[indexPath.row]
                let url = URL(string: "\(targetOrder.image)" as! String)
                if url != nil {
                    DispatchQueue.global().async {
                        let data = try? Data(contentsOf: url!)
                        DispatchQueue.main.async {
                            if data != nil {
                                cell.orderImageView.image = UIImage(data:data!)
                            }else{
                                cell.orderImageView.image = UIImage(named: "2")
                            }
                        }
                    }
                }
        cell.orderNameLabel.text = targetOrder.name
        cell.orderPriceLabel.text = targetOrder.total
        cell.statusLabel.text = targetOrder.status
        cell.qtyLabel.text = targetOrder.qty
            return cell
      }
      
}
