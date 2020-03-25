//
//  greenTextfieldColor.swift
//  MobileApplicationDevelopment
//
//  Created by Rafin Rahman on 03/03/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit
import Foundation

class TextfieldFormatting{
    
    // Change texfield background color to greeen
    static func greenBackgroundTexfield (textfield: UITextField){
        
        UIView.animate(withDuration: 0.2, animations: {
            textfield.layer.borderColor = UIColor.green.cgColor
            textfield.layer.borderWidth = 1.0
            textfield.backgroundColor = UIColor(red:0.25, green:0.76, blue:0.50, alpha:1.0)
        }, completion: {(success) in
            
            UIView.animate(withDuration: 0.2, delay: 1.0, animations: {() -> Void in
                textfield.layer.borderColor = UIColor.clear.cgColor
                textfield.layer.borderWidth = 0.0
                textfield.backgroundColor = UIColor.clear
                textfield.layoutIfNeeded() // check
                textfield.alpha = 1
            })
        })
    }
    
    // Change texfield background color to red
    static func redBackgroundTextfield(textfield: UITextField, title: UILabel, count: Int){
        
        if(textfield.tag == 1){
            title.text = "Sorry, I cannot calculate this, insert a number"
        }else{
            title.text = "Sorry, I cannot calculate interest, insert a number"
        }
        
        title.textColor = UIColor.red
        
        UIView.animate(withDuration: 0.2, animations: {
            textfield.layer.borderColor = UIColor.red.cgColor
            textfield.layer.borderWidth = 2.5
            textfield.backgroundColor = UIColor(red:0.86, green:0.28, blue:0.28, alpha:0.6)
            
        }, completion: {(success) in
            
            UIView.animate(withDuration: 0.2, delay: 1.0, animations: {() -> Void in
                textfield.layer.borderColor = UIColor.clear.cgColor
                textfield.layer.borderWidth = 0.0
                textfield.backgroundColor = UIColor.clear
            })
        })
    }
    
    
    // Change label text, number and size
    static func emptyFieldErrorLabel(title: UILabel){
        
        title.text = "LEAVE ONLY ONE LINE EMPTY!"
        title.textColor = UIColor.red
        title.font = title.font.withSize(25)
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.warning)
    }
    
    // Change texfield background to red and reset placeholder
    static func generalErrorValidation(textfield: UITextField, title: UILabel, errorCode: Int, helpBtn: UIButton){
        if(errorCode == 1){
            title.text = "Deposit cannot be bigger then future value"
        }else if(errorCode == 2){
            title.text = "Time cannot be 0"
        }else if(errorCode == 3){
            title.text = "Repayments cannot be bigger than loan amount"
        }else if(errorCode == 4){
            title.text = "Monthly payments cannot be bigger than future value"
        }else if(errorCode == 5){
            title.text = "Deposit and payments cannot be bigger than future value"
        }
        else if(errorCode == 6){
            title.text = "Deposit and future value cannot be the same"
        }else if(errorCode == 7){
            title.text = "Repayments and loan amount cannot be the same"
        }else if(errorCode == 8){
            title.text = "Repayments cannot be bigger than loan amount"
        }
        
       title.textColor = UIColor.red
        helpBtn.isHidden = true
        
        UIView.animate(withDuration: 0.2, animations: {
            textfield.layer.borderColor = UIColor.red.cgColor
            textfield.layer.borderWidth = 2.5
            textfield.backgroundColor = UIColor(red:0.86, green:0.28, blue:0.28, alpha:0.6)
            
        }, completion: {(success) in
            
            UIView.animate(withDuration: 1.5, delay: 1.5, animations: {() -> Void in
                textfield.layer.borderColor = UIColor.clear.cgColor
                textfield.layer.borderWidth = 0.0
                textfield.backgroundColor = UIColor.clear
                textfield.text = textfield.placeholder
            }, completion: {(success) in
                
                UIView.animate(withDuration: 0.0, delay: 0.0, animations: {() -> Void in
                    
                    textfield.text = ""
                })
            })
        })
    }
    

}


