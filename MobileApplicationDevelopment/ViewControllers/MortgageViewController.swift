//
//  MortgageViewController.swift
//  MobileApplicationDevelopment
//
//  Created by Rafin Rahman on 18/02/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class MortgageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var loanAmountText: UITextField!
    @IBOutlet weak var interestText: UITextField!
    @IBOutlet weak var monthlyPaymentText: UITextField!
    @IBOutlet weak var yearsText: UITextField!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    
    var check = CheckFilledTextfield.null
    let userSavedData = UserDefaults.standard
    // used to dismiss keyboard on Tab change
    var viewOpened = true
    var logoViewVisibility = true
    
    // enumeration used to check how many text field has been filled
    enum CheckFilledTextfield {
        case null
        case monthlyPayment
        case loanAmount
        case years
    }
    
    override func viewDidLoad() {
        
        // checking if it's the first time opening this page
        if (viewOpened){
            super.viewDidLoad()
            viewOpened = false
            
            let sel = #selector(self.dismissKeyboard)
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: sel)
            view.addGestureRecognizer(tap)
            
            let notification = NotificationCenter.default
            notification.addObserver(self, selector: #selector(self.saveData), name: UIApplication.willResignActiveNotification, object: nil)
            
            // getting stored values
            let loanAmountStored = userSavedData.string(forKey: "loanAmountMortgage")
            let interestStored = userSavedData.string(forKey: "interestMortgage")
            let monthlyPaymentStored = userSavedData.string(forKey: "paymentMortgage")
            let yearsStored = userSavedData.string(forKey: "durationMortgage")
            
            // setting stored numbers
            loanAmountText.text = loanAmountStored
            interestText.text = interestStored
            monthlyPaymentText.text = monthlyPaymentStored
            yearsText.text = yearsStored
        }
        dismissKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let sel = #selector(keyboardWillShow(notification:))
        NotificationCenter.default.addObserver(self, selector: sel, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // Remove logo and change page title text
    @IBAction func textFieldSelected(_ sender: UITextField) {
        if(logoViewVisibility){
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.logoView.removeConstraints(self.logoView!.constraints)
                self.logoView.heightAnchor.constraint(equalToConstant: 0).isActive = true
                self.view.layoutIfNeeded()
                self.logoView.alpha = 0
            })
            logoViewVisibility = false
        }
        pageTitle.text = "Type: " + sender.placeholder!
        sender.delegate = self
    }
    
    // Add pound sign before the text
    @IBAction func updateTextfieldOnEdit(_ sender: UITextField) {
        if(sender.text! != ""){
            sender.text = sender.text!.trimmingCharacters(in: CharacterSet(charactersIn: "1234567890.").inverted)
            sender.text = "£ " + sender.text!
        }
    }
    
    // Add percentage sign before the text
    @IBAction func addPercentage(_ sender: UITextField) {
        if(sender.text! != ""){
            sender.text = sender.text!.trimmingCharacters(in: CharacterSet(charactersIn: "1234567890.").inverted)
            sender.text =  sender.text! + " %"
        }
    }
    
    // This button will calculate the value of the a textfield if only 1 texfield is empty.
    @IBAction func calculateButton(_ sender: Any) {
        var count = 0
        
        /*
         
         --- If the following textfield are empty, it will add 1 to count ---
         
         */
        
        let loanAmount: Double! = Double(loanAmountText.text!.filter("1234567890.".contains))
        if(loanAmount == nil) {
            count += 1
            check = CheckFilledTextfield.loanAmount
        }
        
        let monthlyPayment : Double! = Double(monthlyPaymentText.text!.filter("1234567890.".contains))
        if(monthlyPayment == nil) {
            count += 1
            check = CheckFilledTextfield.monthlyPayment
        }
        
        let years: Double! = Double(yearsText.text!)
        if(years == nil) {
            count += 1
            check = CheckFilledTextfield.years
        }
        
        let interest: Double! = Double(interestText.text!.filter("1234567890.".contains))
        if(interest == nil) {
            TextfieldFormatting.redBackgroundTextfield(textfield: interestText, title: pageTitle, count: count)
            helpButton.isHidden = true
            return
        }
        
        if((count == 0 && check == CheckFilledTextfield.null) || count > 1) {
            check = CheckFilledTextfield.null
            
            TextfieldFormatting.emptyFieldErrorLabel(title: pageTitle)
            helpButton.isHidden = true
            return
        }
        
        // Checking if monthly repayments are bigger than loan amount
        if monthlyPayment != nil && loanAmount != nil {
            if monthlyPayment > loanAmount{
                TextfieldFormatting.generalErrorValidation(textfield: monthlyPaymentText, title: pageTitle, errorCode: 3,helpBtn: helpButton)
                TextfieldFormatting.generalErrorValidation(textfield: loanAmountText, title: pageTitle,errorCode: 3, helpBtn: helpButton)
                return
            }
        }
        
        // Checking is time is 0
        if (years == 0){
            TextfieldFormatting.generalErrorValidation(textfield: yearsText, title: pageTitle, errorCode: 2, helpBtn: helpButton)
            return
        }
        
        // Checking if loan amount and payment value are the same
        if( loanAmount == monthlyPayment ){
            TextfieldFormatting.generalErrorValidation(textfield: loanAmountText, title: pageTitle, errorCode: 7, helpBtn: helpButton)
            TextfieldFormatting.generalErrorValidation(textfield: monthlyPaymentText, title: pageTitle, errorCode: 7, helpBtn: helpButton)
            return
        }
        
        switch check {
        case CheckFilledTextfield.loanAmount:
            let loanAmount = Loan.loanAmount(payment: monthlyPayment, interest: interest, year: years)
            loanAmountText.text = String(format: " £ %.2f",loanAmount)
            TextfieldFormatting.greenBackgroundTexfield(textfield: loanAmountText)
            
        case CheckFilledTextfield.monthlyPayment:
            let monthlyPayment = Loan.monthlyPayment(loanAmount: loanAmount, interest: interest, year: years)
            monthlyPaymentText.text = String(format: " £ %.1f",monthlyPayment)
            TextfieldFormatting.greenBackgroundTexfield(textfield: monthlyPaymentText)
            
        case CheckFilledTextfield.years:
            let loanDuration = Loan.loanDuration(payment: monthlyPayment, interest: interest, loanAmount: loanAmount)
            
            yearsText.text = String(format: "%.1f",loanDuration)
            TextfieldFormatting.greenBackgroundTexfield(textfield: yearsText)
        default:
            return
        }
    }
    
    @IBAction func longTapToClear(_ sender: UILongPressGestureRecognizer) {
        
        loanAmountText.text = ""
        interestText.text = ""
        monthlyPaymentText.text = ""
        yearsText.text = ""
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        // setting tabbar at the top of the keyboard
        if (!KeyboardPosition.open){
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if (KeyboardPosition.keyBoardHeight == -1) {
                    KeyboardPosition.keyBoardHeight = keyboardSize.origin.y - keyboardSize.height -
                        (self.tabBarController?.tabBar.frame.height)!
                }
            }
            var tabBarFrame: CGRect = (self.tabBarController?.tabBar.frame)!
            if (KeyboardPosition.defaultPosition == -1) {
                KeyboardPosition.defaultPosition = tabBarFrame.origin.y
            }
            tabBarFrame.origin.y = KeyboardPosition.keyBoardHeight
            self.tabBarController?.tabBar.frame = tabBarFrame
            KeyboardPosition.open = true
        }
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
        
        // setting tabbar at the bottom of the screen
        if (KeyboardPosition.open){
            var tabBarFrame: CGRect = (self.tabBarController?.tabBar.frame)!
            tabBarFrame.origin.y = KeyboardPosition.defaultPosition
            self.tabBarController?.tabBar.frame = tabBarFrame
            KeyboardPosition.open = false
        }
        
        // setting logoView height to 120
        if(!logoViewVisibility){
            logoView.removeConstraints(logoView!.constraints)
            logoView.heightAnchor.constraint(equalToConstant: 120).isActive = true
            UIView.animate(withDuration: 0.3, animations: {() -> Void in
                self.view.layoutIfNeeded()
                self.logoView.alpha = 1
            })
            logoViewVisibility = true
        }
        
        SetTitleLabelText.orignalLabelText(title: pageTitle)
        if(helpButton.isHidden){
            helpButton.isHidden = false
        }
    }
    
    // Store user last inserted numbers for calculation
    @objc func saveData(){
        userSavedData.set(self.loanAmountText.text, forKey: "loanAmountMortgage")
        userSavedData.set(self.interestText.text, forKey: "interestMortgage")
        userSavedData.set(self.monthlyPaymentText.text, forKey: "paymentMortgage")
        userSavedData.set(self.yearsText.text, forKey: "durationMortgage")
    }
    
    func textField(_ textField: UITextField,shouldChangeCharactersIn range: NSRange,replacementString string: String) -> Bool
    {
        let newTextField = textField.text!.filter("1234567890.".contains)
        
        let list = newTextField.components(separatedBy: ".")
        let numberOfDot = list.count - 1
        
        
        
        // Does not allow a seond dot in the same textfield
        if numberOfDot > 0 && string == "."
        {
            return false
        }
        
        // Deletes the last char of the textfield with back button
        if let char = string.cString(using: String.Encoding.utf8){
            let isBackspace = strcmp(char, "\\b")
            if (isBackspace == -92){
                textField.text = String(newTextField.dropLast()) + " "
                return true
            }
        }
        
        // Does not allow more than 2 numbers after the dot
        if (list.count == 2 && list[1].count == 2){
            return false
        }
        
        return true
    }
}
