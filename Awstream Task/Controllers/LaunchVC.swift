//
//  LaunchVC.swift
//  Awstream Task
//
//  Created by ahmed on 3/21/19.
//  Copyright © 2019 Ahmed Hossam. All rights reserved.
//

import UIKit

class LaunchVC: UIViewController {

    @IBOutlet weak var logoContainer: UIView!
    @IBOutlet weak var logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DoAnimation()
    }
    
   
    
    override open var prefersStatusBarHidden: Bool {
        return true
    }
    
    func DoAnimation(){
        UIView.transition(with: logoContainer, duration: 5.0, options: .transitionCrossDissolve, animations: {
            self.logoContainer.alpha = 1
        }) { (true) in
            
            self.dismiss(animated: true, completion: nil)
            
            self.performSegue(withIdentifier: "gohome", sender: self)
            
            
        }
        
        
        
    }
  

}
