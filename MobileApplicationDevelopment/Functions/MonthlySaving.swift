//
//  savingWithContribution.swift
//  MobileApplicationDevelopment
//
//  Created by Rafin Rahman on 22/02/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import Foundation

class MonthlySaving{
    
    // Calculate future value for monthly savings with deposit at the end
    static func futureValueAtEnd( presentValue:Double, payment: Double, interest: Double, years: Int) -> Double{
        
        if(interest == 0){
            
            let result = (payment * Double(years) * 12) + presentValue
            return result
        }
        else
        {
        let interestInPercentage = interest / 100
        let top = (pow((1 + (interestInPercentage / 12)), (12 * Double(years)))) - 1
        let bottom = interestInPercentage / 12
        // Calculare initial amount
        let compoudInterestForPrincipal = presentValue * (pow((1 + (interestInPercentage / 12)),(12 * Double(years))))
        let result = (payment * (top / bottom)) + compoudInterestForPrincipal
        return result
        }
    }
    
    // Calculate future value for monthly savings with deposit at the beginning
    static func futureValueAtStart(presentValue:Double, payment: Double, interest: Double, years: Int) -> Double{
        
        if(interest == 0){
                   
                   let result = (payment * Double(years) * 12) + presentValue
                   return result
               }
               else
               {
        let interestInPercentage = interest / 100
        let top = (pow((1 + (interestInPercentage / 12)), (12 * Double(years)))) - 1
        let bottom = interestInPercentage / 12
        let compoudInterestForPrincipal = presentValue * (pow((1 + (interestInPercentage / 12)),(12 * Double(years))))
        let result = ((payment * (top / bottom)) * (1 + (interestInPercentage / 12))) + compoudInterestForPrincipal
        return result
        }
    }
    
    // Calculate payment value for monthly savings with deposit at the end
    static func paymentAtEnd(futureValue: Double, interest: Double, years:Int, presentValue:Double) -> Double {
        
        if(interest == 0){
            
            let result = (futureValue - presentValue) / (Double(years) / 12)
            return result
        }
        else
        {
            let interestInPercentage = interest / 100
            let compundInterestForPrincipalAmount = (presentValue * (pow((1 + (interestInPercentage / 12)),(12 * Double(years)))))
            let result = (futureValue - compundInterestForPrincipalAmount) / (((pow((1 + (interestInPercentage / 12)),(12 * Double(years))) ) - 1) / (interestInPercentage / 12))
            return result
        }
    }
    
    // Calculate payment value for monthly savings with deposit at the beginning
    static func paymentAtStart(futureValue: Double, interest: Double, years:Int, presentValue:Double) -> Double{
        
        if(interest == 0){
            
            let result = (futureValue - presentValue) / (Double(years) / 12)
            return result
        }
        else
        {
            
            let interestInPercentage = interest / 100
            let compundInterestForPrincipalAmount = (presentValue * (pow((1 + (interestInPercentage / 12)),(12 * Double(years)))))
            let result = (futureValue - compundInterestForPrincipalAmount) / ((((pow((1 + (interestInPercentage / 12)),(12 * Double(years))) ) - 1) / (interestInPercentage / 12)))
            return result
        }
    }
    
    // Calculate time (years) for monthly savings with deposit at the end
    static func yearAtEnd(futureValue: Double, interest: Double, payment:Double, presentValue: Double) ->Double{
        
        if(interest == 0){
            let result = ((futureValue - presentValue) / payment) / 12
            return result
        }else{
            let interestInPercentage = interest / 100
            let top = (futureValue * (interestInPercentage / 12)) + payment
            let bottom = (presentValue * (interestInPercentage / 12)) + payment
            let A = log(top / bottom)
            let result = A * (1 / (12 * (log(1 + (interestInPercentage / 12)))))
            return result
        }
    }
    
    // Calculate time (years) for monthly savings with deposit at the beginning
    static func yearAtStart(futureValue: Double, interest: Double, payment:Double, presentValue: Double) ->Double{
        
        if(interest == 0){
            
            let result = ((futureValue - presentValue) / payment) / 12
            return result
        }else{
            let interestInPercentage = interest / 100
            let topA = futureValue + (payment / (interestInPercentage / 12)) + payment
            let bottomA = presentValue + (payment / (interestInPercentage / 12)) + payment
            let top = log(topA / bottomA)
            let bottom = 12 * (log(1 + (interestInPercentage / 12)))
            let result = top / bottom
            return result
        }
    }
}
