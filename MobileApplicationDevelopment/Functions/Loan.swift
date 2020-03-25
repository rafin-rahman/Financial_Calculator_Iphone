//
//  Mortgage.swift
//  MobileApplicationDevelopment
//
//  Created by Rafin Rahman on 19/02/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import Foundation

class Loan{
    
    // Calculate monthly re-payments for loan and mortgage
    static func monthlyPayment(loanAmount: Double, interest: Double, year: Double ) -> Double {
        if(interest == 0){
            let result = (loanAmount / year) / 12
            return result
        }
        else{
            let interestInPercentage = interest / 100
            var top = loanAmount * (interestInPercentage / 12)
            top = top * pow((1 + (interestInPercentage / 12)), (12 * year))
            let bottom = (pow((1 + (interestInPercentage / 12)), (12 * year))) - 1
            let result = top / bottom
            return result
        }
    }
    
    // Calculate loan duration for loan and mortgage
    static func loanDuration(payment: Double, interest: Double, loanAmount: Double) -> Double{
        if(interest == 0){
            let result = (loanAmount / payment) / 12
            return result
        }
        else
        {
            let interestInPercentage = interest / 100
            let top = log((-12 * payment) / ((loanAmount * interestInPercentage) - (12 * payment)))
            let bottom = 12 * log((interestInPercentage + 12) / 12)
            let result = top / bottom
            return result
        }
    }
    
    // Calculate loan amount for loan and mortgage
    static func loanAmount( payment: Double, interest: Double, year: Double) -> Double {
        
        if(interest == 0){
            let result = year * payment * 12
            return result
        }
        else
        {
            let interestInPercentage = interest / 100
            let top = payment * ((pow((1 + (interestInPercentage / 12)),(12 * year))) - 1)
            let bottom = (interestInPercentage / 12) * (pow((1 + (interestInPercentage / 12)), (12 * year)))
            let result = top / bottom
            return result
        }
        
        
    }
}
