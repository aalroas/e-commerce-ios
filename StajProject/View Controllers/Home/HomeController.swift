//
//  ViewController.swift
//  StajProject
//
//  Created by Abdulsalam ALROAS
//

import UIKit

class HomeViewController: UIViewController {


    @IBOutlet weak var colViewProducts: UICollectionView!
    private var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colViewProducts.delegate = self
        colViewProducts.dataSource = self
        self.getProducts()
    }
    
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.colViewProducts.reloadData()
        }
    }
}

// MARK: - Networking
extension HomeViewController {
    
    private func getProducts() {
        let session = URLSession.shared
                let url = api.products
                let request = NSMutableURLRequest(url: url)
        print(url)
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
                            
                                        let productDict = retrievedData as! [String: Any]
                                        let id = productDict["id"] as! Int
                                        let title = productDict["title"] as! String
                                        let image = productDict["image"] as! String
                                        let price = productDict["price"] as! Double
                                        let description = productDict["description"] as! String
                                        let category = productDict["category"] as! String
                                        let liked =  Int.random(in: 0...1)
                           
                                        let productObj = Product(id: id, title: title, price: price, description: description, category: category, image: image, liked: liked)
                                        self.products.append(productObj)
                                    }
                                    self.updateUI()
                                
 
                             
                            }catch _ {
                                print ("OOps not good JSON formatted response")
                            }
                        }
                    })
                    task.resume()
                }catch _ {
                    print ("Oops something happened buddy")
                }
    
}
}




extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.products.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product_cell", for: indexPath) as! ProductCollectionViewCell
    let targetProduct = products[indexPath.row]

    
        let url = URL(string: "\(targetProduct.image)" as! String)
        if url != nil {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    if data != nil {
                        cell.image.image = UIImage(data:data!)
                    }else{
                        cell.image.image = UIImage(named: "2")
                    }
                }
            }
        }
    

    cell.name.text = targetProduct.title
    cell.price.text = "$ \(targetProduct.price)"
    cell.like.image =  UIImage(named: "\(targetProduct.liked)")
    

    return cell
}
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProductId = products[indexPath.row].id
        let des = Destination().detail
        des.getProductId = selectedProductId
        self.present(des, animated: true)

    }
    
    
}
