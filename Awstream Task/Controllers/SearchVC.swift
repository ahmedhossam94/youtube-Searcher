//
//  ViewController.swift
//  Awstream Task
//
//  Created by ahmed on 3/20/19.
//  Copyright © 2019 Ahmed Hossam. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class SearchVC: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var resultTableView: UITableView!
    var items  = [ResultItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultTableView.rowHeight = 120
        
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view, typically from a nib.
        
  
    }
    func updateView(jsonArray : JSON){
         items = [ResultItem]()
        print(jsonArray)
        for item in jsonArray{
            let details = ResultItem()
            details.title = item.1["snippet"]["title"].stringValue
            details.etag = item.1["etag"].stringValue
            details.kind = item.1["kind"].stringValue
            details.videoId = item.1["id"]["videoId"].stringValue
            details.thumbnailsDefaultURL = item.1["snippet"]["thumbnails"]["default"]["url"].stringValue
            items.append(details)
           print(details.thumbnailsDefaultURL)
        }
        resultTableView.reloadData()
       
    }


}
extension SearchVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchCell
        cell.itemTitle.text = items[indexPath.row].title
      
        cell.selectionStyle = .none
        
        let image = UIImage(named: "placeHolderIcon")
         let url :URL = URL(string: items[indexPath.row].thumbnailsDefaultURL!)!

   
        
        let cache = ImageCache.default
   
        // To know where the cached image is:
        let cacheType = cache.imageCachedType(forKey: items[indexPath.row].thumbnailsDefaultURL!)
       
        
        switch cacheType {
        case .none:
            let image = UIImage(named: "placeHolderIcon")
            let url :URL = URL(string: items[indexPath.row].thumbnailsDefaultURL!)!
            
            let resource = ImageResource(downloadURL: url, cacheKey: items[indexPath.row].thumbnailsDefaultURL!)
            cell.itemImage.kf.indicatorType = .activity
            cell.itemImage.kf.setImage(with: url, placeholder: image,options: [.transition(.fade(0.2))])
            print("none")
            
            
        case .memory:
            cell.itemImage.kf.indicatorType = .activity
             cell.itemImage.image = cache.retrieveImageInMemoryCache(forKey: items[indexPath.row].thumbnailsDefaultURL!)
            print("memory")
            
        case .disk:
            cell.itemImage.kf.indicatorType = .activity
            cell.itemImage.image = cache.retrieveImageInDiskCache(forKey: items[indexPath.row].thumbnailsDefaultURL!)
            print("disk")
        default:
            let image = UIImage(named: "placeHolderIcon")
            let url :URL = URL(string: items[indexPath.row].thumbnailsDefaultURL!)!
            
            let resource = ImageResource(downloadURL: url, cacheKey: items[indexPath.row].thumbnailsDefaultURL!)
            cell.itemImage.kf.indicatorType = .activity
            cell.itemImage.kf.setImage(with: url, placeholder: image,options: [.transition(.fade(0.2))])
        }
        
        return cell
    }
    
    
}
extension SearchVC : UISearchBarDelegate{
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text{
            if text != ""{
                let param = ["part":"snippet","q":text,"type":"video","maxResults":"9","key":Constants.ApiKey]
                
                
                Alamofire.request(Constants.SearchUrl, method: .get, parameters: param).responseJSON { (response) in
                    let json :JSON = JSON(response.value)
                    let jsonItems = json["items"]
                   
                    if response.result.isSuccess{
                       
                        self.updateView(jsonArray : jsonItems)
                    }
                        
                    else{
                        print("failur")
                    }
                    
                }
               
                print(text)
                searchBar.resignFirstResponder()
                
            }
            else{
                print("enter text")
            }
            
        }
       
    }
}
