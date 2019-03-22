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
    var index = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultTableView.rowHeight = 120
        
        //To hide Keyboard When Click Out of SearchBar
        self.hideKeyboardWhenTappedAround()

  
    }
    func updateView(jsonArray : JSON){
         items = [ResultItem]()
      //  print(jsonArray)
        
     //   get All The Item in JSON array and save it to display in tableView
        
        for item in jsonArray{
            let details = ResultItem()
            details.title = item.1["snippet"]["title"].stringValue
            details.etag = item.1["etag"].stringValue
            details.kind = item.1["kind"].stringValue
            details.videoId = item.1["id"]["videoId"].stringValue
            details.thumbnailsDefaultURL = item.1["snippet"]["thumbnails"]["default"]["url"].stringValue
            details.description = item.1["snippet"]["description"].stringValue
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

        let cache = ImageCache.default
   
        // To know where the cached image is:
        let cacheType = cache.imageCachedType(forKey: items[indexPath.row].thumbnailsDefaultURL!)
       
        
        switch cacheType {
            //if not cached , Cach it and display
        case .none:
            let image = UIImage(named: "placeHolderIcon")
            let url :URL = URL(string: items[indexPath.row].thumbnailsDefaultURL!)!
            
            let resource = ImageResource(downloadURL: url, cacheKey: items[indexPath.row].thumbnailsDefaultURL!)
            cell.itemImage.kf.indicatorType = .activity
            cell.itemImage.kf.setImage(with: url, placeholder: image,options: [.transition(.fade(0.2))])
            print("none")
            
          //  if it cached and still in memory retrieve it and display
        case .memory:
            cell.itemImage.kf.indicatorType = .activity
             cell.itemImage.image = cache.retrieveImageInMemoryCache(forKey: items[indexPath.row].thumbnailsDefaultURL!)
            print("memory")
             //  if it cached in disk retrieve it and display
        case .disk:
            cell.itemImage.kf.indicatorType = .activity
            cell.itemImage.image = cache.retrieveImageInDiskCache(forKey: items[indexPath.row].thumbnailsDefaultURL!)
            print("disk")
            
            
   
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // when click on cell item Go to Details Screen
        index = indexPath.row
        performSegue(withIdentifier: "gotoDetails", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "gotoDetails"{
            if let destination = segue.destination as? VideoDetailsVC{
              // save the item i clicked in details screen to display information and video
                guard let viddeoID = items[index].videoId else{return}
                  print(viddeoID)
                destination.selectedItem = items[index]
                //destination.videoID = "\(viddeoID)"
            }
            
        }
    }
    
    
}
extension SearchVC : UISearchBarDelegate{
   
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text{
            if text != ""{
            // this is the request and parameters (filters) of getting JSON information from youtube about The search Text
                let param = ["part":"snippet","q":text,"type":"video","maxResults":"2","key":Constants.ApiKey]
                
                
                Alamofire.request(Constants.SearchUrl, method: .get, parameters: param).responseJSON { (response) in
                     let json :JSON = JSON(response.value)
                    let jsonItems = json["items"]
                   print(json)
                    if response.result.isSuccess{
                        //send the array to function Update to display in tableView
                        self.updateView(jsonArray : jsonItems)
                    }
                        
                    else{
                        print("failur")
                    }
                    
                }
               
                print(text)
                //to close keyboard when click on search Button
                searchBar.resignFirstResponder()
                
            }
            else{
                let alert = UIAlertController(title: "No Text", message: "Please Enter Your Search Keyword", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    print("Ok")
                }))
                self.present(alert, animated: true, completion: nil)
                print("enter text")
            }
            
        }
       
    }
}
