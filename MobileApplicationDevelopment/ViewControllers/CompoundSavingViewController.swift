//
//  FirstViewController.swift
//  MobileApplicationDevelopment
//
//  Created by Rafin Rahman on 17/02/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit

class CompoundSavingViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var presentValueTxt: UITextField!
    @IBOutlet weak var futureValueTxt: UITextField!
    @IBOutlet weak var interestTxt: UITextField!
    @IBOutlet weak var numberOfYearsTxt: UITextField!
    @IBOutlet weak var calculateButton: UIButton!
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
        case futureValue
        case presentValue
        case interestValue
        case years
    }
    
    
    override func viewDidLoad() {
        // checking if it's the first time opening this page
        if (viewOpened){
            super.viewDidLoad()
            viewOpened = false
            
            // checks if keyboard is open 
            let sel2 = #selector(keyboardWillShow(notification:))
            NotificationCenter.default.addObserver(self, selector: sel2, name: UIResponder.keyboardWillShowNotification, object: nil)
            
            let sel = #selector(self.dismissKeyboard)
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: sel)
            view.addGestureRecognizer(tap)
            
            let notification = NotificationCenter.default
            notification.addObserver(self, selector: #selector(self.saveData), name: UIApplication.willResignActiveNotification, object: nil)
            
            // getting stored values
            let presentValueStored = userSavedData.string(forKey: "presentValueCompoundSaving")
            let interestStored = userSavedData.string(forKey: "interestCompoundSaving")
            let yearsStored = userSavedData.string(forKey: "yearsCompoundSaving")
            let futureValueStored = userSavedData.string(forKey: "futureValueCompoundSaving")
            
            // setting stored numbers
            presentValueTxt.text = presentValueStored
            interestTxt.text = interestStored
            numberOfYearsTxt.text = yearsStored
            futureValueTxt.text = futureValueStored
        }
        dismissKeyboard()
    }
    
    // Remove logo and change page title text
    @IBAction func textfieldSelected(_ sender: UITextField) {
        
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
    @IBAction func calculateButon(_ sender: Any) {
        dismissKeyboard()
        // "count" will count the number of filled texfield
        var count = 0
        
        /*
         
         --- If the following textfield are empty, it will add 1 to count ---
         
         */
        
        let futureValue: Double! = Double(futureValueTxt.text!.filter("1234567890.".contains))
        if(futureValue == nil) {
            count += 1
            check = CheckFilledTextfield.futureValue
        }
        
        let presentValue : Double! = Double(presentValueTxt.text!.filter("1234567890.".contains))
        if(presentValue == nil) {
            count += 1
            check = CheckFilledTextfield.presentValue
        }
        
        let yearsValue: Int! = Int(numberOfYearsTxt.text!)
        if(yearsValue == nil) {
            count += 1
            check = CheckFilledTextfield.years
        }
        
        let interestValue : Double! = Double(interestTxt.text!.filter("1234567890.".contains))
        if(interestValue == nil) {
            count += 1
            check = CheckFilledTextfield.interestValue
        }
        
        if((count == 0 && check == CheckFilledTextfield.null) || count > 1) {
            check = CheckFilledTextfield.null
            
            TextfieldFormatting.emptyFieldErrorLabel(title: pageTitle)
            helpButton.isHidden = true
            return
        }
        
        // Checking if  inital amount is bigger then future value
        if futureValue != nil && presentValue != nil {
            if presentValue > futureValue{
                TextfieldFormatting.generalErrorValidation(textfield: presentValueTxt, title: pageTitle, errorCode: 1, helpBtn: helpButton)
                TextfieldFormatting.generalErrorValidation(textfield: futureValueTxt, title: pageTitle, errorCode: 1,helpBtn: helpButton)
                return
            }
        }
        
        // Checking if time is 0
        if (yearsValue == 0){
            TextfieldFormatting.generalErrorValidation(textfield: numberOfYearsTxt, title: pageTitle, errorCode: 2, helpBtn: helpButton)
            return
        }
        
        // Checking if initial amount and future value are the same
        if( presentValue == futureValue ){
            TextfieldFormatting.generalErrorValidation(textfield: presentValueTxt, title: pageTitle, errorCode: 6, helpBtn: helpButton)
            TextfieldFormatting.generalErrorValidation(textfield: futureValueTxt, title: pageTitle, errorCode: 6, helpBtn: helpButton)
            return
        }
        
        switch check {
        case CheckFilledTextfield.futureValue:
            
            let futureValue = OnetimeSaving.futureValue(interestValue: interestValue, presentValue: presentValue, yearsValue: yearsValue)
            
            futureValueTxt.text = String(format: " £ %.2f",futureValue)
            TextfieldFormatting.greenBackgroundTexfield(textfield: futureValueTxt)
            
        case CheckFilledTextfield.presentValue:
            let presentValue = OnetimeSaving.initialAmount(interestValue: interestValue, futureValue: futureValue, yearsValue: yearsValue)
            
            presentValueTxt.text = String(format: " £ %.2f",presentValue)
            TextfieldFormatting.greenBackgroundTexfield(textfield: presentValueTxt)
            
        case CheckFilledTextfield.years:
            let years = OnetimeSaving.years(interestValue: interestValue, futureValue: futureValue, presentValue: presentValue)
            
            numberOfYearsTxt.text = String(format: "%.1f",years)
            TextfieldFormatting.greenBackgroundTexfield(textfield: numberOfYearsTxt)
            
        case CheckFilledTextfield.interestValue:
            let interest = OnetimeSaving.CalculateInterest(futureValue : futureValue, presentValue: presentValue, yearsValue: yearsValue)
            
            interestTxt.text = String(format: "%.2f",interest * 100) + "%"
            
            TextfieldFormatting.greenBackgroundTexfield(textfield: interestTxt)
            
        default:
            return
        }
    }
    
    @IBAction func longTapToClear(_ sender: UILongPressGestureRecognizer) {
        
        presentValueTxt.text = ""
        futureValueTxt.text = ""
        interestTxt.text = ""
        numberOfYearsTxt.text = ""
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
        if (!logoViewVisibility) {
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
        userSavedData.set(self.presentValueTxt.text, forKey: "presentValueCompoundSaving")
        userSavedData.set(self.interestTxt.text, forKey: "interestCompoundSaving")
        userSavedData.set(self.numberOfYearsTxt.text, forKey: "yearsCompoundSaving")
        userSavedData.set(self.futureValueTxt.text, forKey: "futureValueCompoundSaving")
    }
    
    // user input formattting
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

