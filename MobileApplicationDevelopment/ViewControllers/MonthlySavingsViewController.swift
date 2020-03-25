//
//  SecondViewController.swift
//  MobileApplicationDevelopment
//
//  Created by Rafin Rahman on 17/02/2020.
//  Copyright © 2020 Rafin Rahman. All rights reserved.
//

import UIKit



class MonthlySavingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var presentValueText: UITextField!
    @IBOutlet weak var interestText: UITextField!
    @IBOutlet weak var monthlyPaymentText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    @IBOutlet weak var futureValueText: UITextField!
    @IBOutlet weak var switchOnOff: UISwitch!
    @IBOutlet weak var endofCycleLabel: UILabel!
    @IBOutlet weak var startOfCycleLabel: UILabel!
    @IBOutlet weak var calculateButton: UIButton!
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var pageTitle: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    
    // enumeration used to check how many text field has been filled
    enum CheckFilledTextfield {
        case null
        case futureValue
        case presentValue
        case interestValue
        case years
        case monthlyPayment
    }
    
    var check = CheckFilledTextfield.null
    let userSavedData = UserDefaults.standard
    // used to dismiss keyboard on Tab change
    var viewOpened = true
    var logoViewVisibility = true
    
    
    override func viewDidLoad() {
        
        endofCycleLabel.isHidden = true
        
        // checking if it's the first time opening this page
        if (viewOpened){
            super.viewDidLoad()
            
            viewOpened = false
            let sel = #selector(self.dismissKeyboard)
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: sel)
            view.addGestureRecognizer(tap)
            
            let notification = NotificationCenter.default
            notification.addObserver(self, selector: #selector(self.savedData), name: UIApplication.willResignActiveNotification, object: nil)
            
            // getting stored values
            let presentValueStored = userSavedData.string(forKey: "presentValueMonthly")
            let interestStored = userSavedData.string(forKey: "interestMonthly")
            let yearsStored = userSavedData.string(forKey: "yearsMonthly")
            let futureValueStored = userSavedData.string(forKey: "futureValueMonthly")
            let monthylPaymentStored = userSavedData.string(forKey: "paymentMonthly")
            let switchOnOffStored = userSavedData.bool(forKey: "statusMonthly")
            
            // setting stored numbers
            presentValueText.text = presentValueStored
            interestText.text = interestStored
            yearText.text = yearsStored
            futureValueText.text = futureValueStored
            monthlyPaymentText.text = monthylPaymentStored
            switchOnOff.isOn = switchOnOffStored
            showLabel(switchOnOff)
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
    
    @IBAction func setDefaultUIOnChange(_ sender: UITextField) {
        pageTitle.text = "MONTHLY SAVING"
        interestText.layer.borderColor = UIColor.clear.cgColor
        
        pageTitle.textColor = UIColor(red:1.00, green:0.74, blue:0.18, alpha:1.0)
        pageTitle.font = pageTitle.font.withSize(30)
        presentValueText.layer.borderColor = UIColor.black.cgColor
        presentValueText.layer.borderWidth = 0.1
        presentValueText.backgroundColor = UIColor.clear
    }
    
    // This button will calculate the value of the a textfield if only 1 texfield is empty.
    @IBAction func calculateButton(_ sender: Any) {
        var count = 0
        
        /*
         
         --- If the following textfield are empty, it will add 1 to count ---
         
         */
        
        let futureValue: Double! = Double(futureValueText.text!.filter("1234567890.".contains))
        if(futureValue == nil) {
            count += 1
            check = CheckFilledTextfield.futureValue
        }
        
        let presentValue : Double! = Double(presentValueText.text!.filter("1234567890.".contains))
        if(presentValue == nil) {
            count += 1
            check = CheckFilledTextfield.presentValue
            TextfieldFormatting.redBackgroundTextfield(textfield: presentValueText, title: pageTitle, count: count)
            helpButton.isHidden = true
            return
        }
        
        let yearsValue: Int! = Int(yearText.text!)
        if(yearsValue == nil) {
            count += 1
            check = CheckFilledTextfield.years
        }
        
        let interestValue : Double! = Double(interestText.text!.filter("1234567890.".contains))
        if(interestValue == nil) {
            
            TextfieldFormatting.redBackgroundTextfield(textfield: interestText, title: pageTitle, count: count)
            helpButton.isHidden = true
            return
        }
        
        let paymentValue : Double! = Double(monthlyPaymentText.text!.filter("1234567890.".contains))
        if(paymentValue == nil) {
            count += 1
            check = CheckFilledTextfield.monthlyPayment
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
                TextfieldFormatting.generalErrorValidation(textfield: presentValueText, title: pageTitle, errorCode: 1, helpBtn: helpButton)
                TextfieldFormatting.generalErrorValidation(textfield: futureValueText, title: pageTitle, errorCode: 1, helpBtn: helpButton)
                
                return
            }
        }
        
        
        // Monthly amount and initil amount cannot be bigger than future value
        if (futureValue != nil && presentValue != nil && paymentValue != nil) {
            if ((paymentValue + presentValue) > futureValue){
                TextfieldFormatting.generalErrorValidation(textfield: monthlyPaymentText, title: pageTitle, errorCode: 5, helpBtn: helpButton)
                TextfieldFormatting.generalErrorValidation(textfield: presentValueText, title: pageTitle, errorCode: 5, helpBtn: helpButton)
                return
            }
            
        }
        
        // Checking is time is 0
        if (yearsValue == 0){
            TextfieldFormatting.generalErrorValidation(textfield: yearText, title: pageTitle, errorCode: 2, helpBtn: helpButton)
            
            return
        }
        
        // Checking if initial amount and future value are the same
        if( presentValue == futureValue ){
            TextfieldFormatting.generalErrorValidation(textfield: presentValueText, title: pageTitle, errorCode: 6, helpBtn: helpButton)
            TextfieldFormatting.generalErrorValidation(textfield: futureValueText, title: pageTitle, errorCode: 6, helpBtn: helpButton)
            return
        }
        
        switch check {
            
        case CheckFilledTextfield.futureValue:
            if(!switchOnOff.isOn){
                let futureValue = MonthlySaving.futureValueAtEnd(presentValue: presentValue, payment: paymentValue, interest: interestValue, years: yearsValue)
                futureValueText.text = String(format: " £ %.2f",futureValue)
                
                TextfieldFormatting.greenBackgroundTexfield(textfield: futureValueText)
            }
            else{
                let futureValue = MonthlySaving.futureValueAtStart(presentValue: presentValue, payment: paymentValue, interest: interestValue, years: yearsValue)
                futureValueText.text = String(format: " £ %.2f",futureValue)
                TextfieldFormatting.greenBackgroundTexfield(textfield: futureValueText)
            }
            
        case CheckFilledTextfield.monthlyPayment:
            if(!switchOnOff.isOn){
                let payment = MonthlySaving.paymentAtEnd(futureValue: futureValue, interest: interestValue, years: yearsValue, presentValue:presentValue)
                monthlyPaymentText.text = String(format: " £ %.2f", payment)
                TextfieldFormatting.greenBackgroundTexfield(textfield: monthlyPaymentText)
            }else{
                let payment = MonthlySaving.paymentAtStart(futureValue: futureValue, interest: interestValue, years: yearsValue, presentValue:presentValue)
                monthlyPaymentText.text = String(format: " £ %.2f", payment)
                TextfieldFormatting.greenBackgroundTexfield(textfield: monthlyPaymentText)
            }
            
        case CheckFilledTextfield.years:
            if(!switchOnOff.isOn){
                let years = MonthlySaving.yearAtEnd(futureValue: futureValue, interest: interestValue, payment: paymentValue, presentValue: presentValue)
                yearText.text = String(format: "%.1f",years)
                TextfieldFormatting.greenBackgroundTexfield(textfield: yearText)
            }
            else{
                let years = MonthlySaving.yearAtStart(futureValue: futureValue, interest: interestValue, payment: paymentValue, presentValue: presentValue)
                yearText.text = String(format: "%.1f",years)
                TextfieldFormatting.greenBackgroundTexfield(textfield: yearText)
            }
            
        default:
            return
        }
    }
    
    @IBAction func longTapToClear(_ sender: UILongPressGestureRecognizer) {
        
        presentValueText.text = ""
        interestText.text = ""
        monthlyPaymentText.text = ""
        yearText.text = ""
        futureValueText.text = ""
    }
    
    @IBAction func showLabel(_ sender: UISwitch) {
        if(switchOnOff.isOn){
            endofCycleLabel.isHidden = true
            startOfCycleLabel.isHidden = false
            calculateButton.backgroundColor = UIColor(red:1.00, green:0.74, blue:0.18, alpha:1.0)
        }else{
            endofCycleLabel.isHidden = false
            startOfCycleLabel.isHidden = true
            calculateButton.backgroundColor = UIColor.init(red: 0.12, green: 0.13, blue: 0.14, alpha: 1.0)
        }
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
        if(KeyboardPosition.open){
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
    @objc func savedData(){
        userSavedData.set(self.presentValueText.text, forKey: "presentValueMonthly")
        userSavedData.set(self.interestText.text, forKey: "interestMonthly")
        userSavedData.set(self.yearText.text, forKey: "yearsMonthly")
        userSavedData.set(self.futureValueText.text, forKey: "futureValueMonthly")
        userSavedData.set(self.monthlyPaymentText.text, forKey: "paymentMonthly")
        userSavedData.set(self.switchOnOff.isOn, forKey: "statusMonthly")
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


