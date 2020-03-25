//
//  SetTitleLabelText.swift
//  MobileApplicationDevelopment
//
//  Created by Rafin Rahman on 03/03/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit
import Foundation

class SetTitleLabelText{
    
    // after changing the label, this will set back it's orignal status based on the tags
    static func orignalLabelText(title: UILabel){
        
        if(title.tag == 1){
            
            title.text = "LUMP SUM SAVING"
            
        } else if (title.tag == 2){
            
            title.text = "MONTHLY SAVING"
            
        } else if (title.tag == 3){
            
            title.text = "LOANS"
            
        } else if (title.tag == 4){
            
            title.text = "MORTGAGE"
            
        }
        
        title.textColor = UIColor(red:1.00, green:0.74, blue:0.18, alpha:1.0)
        title.font = title.font.withSize(30)
    }
}
