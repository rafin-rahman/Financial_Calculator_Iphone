//
//  CustomLaunchScreenViewController.swift
//  MobileApplicationDevelopment
//
//  Created by Rafin Rahman on 08/03/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class CustomLaunchScreenViewController: UIViewController {
    
    @IBOutlet weak var borderOne: UIImageView!
    @IBOutlet weak var borderTwo: UIImageView!
    @IBOutlet weak var borderThree: UIImageView!
    @IBOutlet weak var logoMain: UIImageView!
    
    @IBOutlet weak var organgeBoxLeading: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.borderOne.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.borderTwo.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.borderThree.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        self.logoMain.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        logoMain.alpha = 0.0
        
         self.borderOne.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
               self.borderTwo.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
               self.borderThree.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
               
               UIView.animate(withDuration: 1.0, animations: {
                   
                   self.borderOne.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
                   self.borderTwo.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
                   self.borderThree.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
                   
               }, completion: {(success) in
                   
                   UIView.animate(withDuration: 0.5, delay: 0.3, animations: {() -> Void in
                       
                       self.borderOne.transform = CGAffineTransform(scaleX: 1, y: 1)
                       self.borderTwo.transform = CGAffineTransform(scaleX: 1, y: 1)
                       self.borderThree.transform = CGAffineTransform(scaleX: 1, y: 1)
                       self.logoMain.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
                       self.logoMain.alpha = 1.0
                       
                       self.borderOne.frame.origin.y += 8
                       self.borderTwo.frame.origin.y -= 8
                       
                   }, completion: {(success) in
                       UIView.animate(withDuration: 0.5, delay: 0.5, animations: {() -> Void in
                           self.borderOne.transform = CGAffineTransform(scaleX: 1, y: 1)
                           self.borderTwo.transform = CGAffineTransform(scaleX: 1, y: 1)
                           self.borderThree.transform = CGAffineTransform(scaleX: 1, y: 1)
                       }, completion: {(success) in
                           UIView.animate(withDuration: 0.3, delay: 0.5, animations: {() -> Void in
                               // This is used just to wait for 3 seconds
                               self.logoMain.transform = CGAffineTransform(scaleX: 10, y: 10)
                            self.borderOne.alpha = 0
                            self.borderTwo.alpha = 0
                            self.borderThree.alpha = 0
                            self.logoMain.alpha = 0.3
                            self.view.backgroundColor = UIColor(red:1.00, green:0.74, blue:0.18, alpha:1.0)
                            
                           }, completion: {(success) in
                               UIView.animate(withDuration: 5.5, delay: 3.0, animations: {() -> Void in
                                   let nextView = self.storyboard?.instantiateViewController(withIdentifier:"TabbarViewController") as! TabbarViewController
                                   nextView.modalPresentationStyle = .currentContext
                                   nextView.modalTransitionStyle = .crossDissolve
                                   self.present(nextView, animated:true, completion:nil)
                               })
                           })
                       })
                   })
               }
               )
          
    }
 


    
    
}
