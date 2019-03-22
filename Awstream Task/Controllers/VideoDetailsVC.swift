//
//  VideoDetailsVC.swift
//  Awstream Task
//
//  Created by ahmed on 3/21/19.
//  Copyright © 2019 Ahmed Hossam. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
class VideoDetailsVC: UIViewController {

    @IBOutlet weak var videoDescription: UILabel!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var youtubePlayer: YTPlayerView!
   
    var selectedItem = ResultItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        youtubePlayer.delegate = self
        guard let videoID =   selectedItem.videoId else{return}
         guard let videoTitletext =   selectedItem.title else{return}
         guard let videoDescriptiontext =   selectedItem.description else{return}
        
        youtubePlayer.load(withVideoId: videoID)
        videoDescription.text = videoDescriptiontext
        videoTitle.text = videoTitletext
    
        
    }
}

extension VideoDetailsVC : YTPlayerViewDelegate{
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        
        let alert = UIAlertController(title: "ERROR", message: "\(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            print("Ok")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
