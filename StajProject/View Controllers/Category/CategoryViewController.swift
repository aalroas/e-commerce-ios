//
//  ViewController.swift
//  StajProject
//
//  Created by Abdulsalam ALROAS
//

import UIKit

class CategoryViewController: UIViewController {


    @IBOutlet weak var colViewcategories: UICollectionView!
    private var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colViewcategories.delegate = self
        colViewcategories.dataSource = self
        self.getcategories()
    }
    
    
    private func updateUI() {
        DispatchQueue.main.async {
            self.colViewcategories.reloadData()
        }
    }
}

// MARK: - Networking
extension CategoryViewController {
    
    private func getcategories() {
        let session = URLSession.shared
                let url = api.categories
                let request = NSMutableURLRequest(url: url)
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
                            
                                        let title = retrievedData as! String
                                        let image = ""
                                        let CategoryObj = Category(title: title, image: image)
                                        self.categories.append(CategoryObj)
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




extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.categories.count
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "category_cell", for: indexPath) as! CategoryCollectionViewCell
    let targetCategory = categories[indexPath.row]

    
        let url = URL(string: "\(targetCategory.image)" as! String)
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
    
    if targetCategory.title.contains("electronics"){
        cell.image.image = UIImage(named: "electronics")
    }
    if targetCategory.title.contains("jewelery"){
        cell.image.image = UIImage(named: "jewelery")
    }
    if targetCategory.title.contains("men"){
        cell.image.image = UIImage(named: "men")
    }
    if targetCategory.title.contains("women"){
        cell.image.image = UIImage(named: "women")
    }
    cell.name.text = targetCategory.title
 
    return cell
}
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        

    }
    
    
}
