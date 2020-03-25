//
//  Compund.swift
//  MobileApplicationDevelopment
//
//  Created by Rafin Rahman on 18/02/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import Foundation

class OnetimeSaving{
    
    // Calculate the future value of one-time savings
    static func futureValue(interestValue: Double, presentValue:Double, yearsValue:Int ) -> Double{
       
        var futureValue = (interestValue / 100) / 12
        futureValue =  pow((1 + futureValue),(12 * Double(yearsValue)))
        futureValue = futureValue * presentValue
        return futureValue
        
    }
    
    // Calculate the initial amount of one-time savings
    static func initialAmount(interestValue: Double, futureValue:Double, yearsValue:Int) -> Double{
        var initialValue = pow(((interestValue / 100) / 12) + 1,(12 * Double(yearsValue)) )
        initialValue = futureValue / initialValue
        return initialValue
    }
    
    // Calculate the time (years) of one-time savings
    static func years(interestValue: Double, futureValue:Double, presentValue:Double) -> Double{
        if(interestValue == 0){
            let result = 0.0
            return result
        }
        else
        {
            let a = log(futureValue / presentValue)
            let b = 12 * (log(((interestValue / 100) / 12) + 1))
            let result = (a / b)
            return result
            
        }
    }
    
    // Calculate the interest of one-time savings
    static func CalculateInterest(futureValue: Double, presentValue:Double, yearsValue:Int) -> Double{
        var interest = futureValue  / presentValue
        interest = pow(interest, (1/(12 * Double(yearsValue))))
        interest = (interest - 1) * 12
        return interest
    }
}
