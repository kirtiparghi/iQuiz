//
//  LoginVC.swift
//  iQuiz
//
//  Created by Kirti Parghi on 10/18/17.
//  Copyright © 2017 MacStudent. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, SSRadioButtonControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var txtFieldName:UITextField!
    
    @IBOutlet weak var txtFieldEmailID: UITextField!
    @IBOutlet weak var btnRememberMe: UIButton?
    @IBOutlet weak var txtFieldPassword: UITextField!
    var radioButtonController: SSRadioButtonsController?

    override func viewDidLoad() {
        super.viewDidLoad()
        radioButtonController = SSRadioButtonsController(buttons: btnRememberMe!)
        radioButtonController!.delegate = self
        radioButtonController!.shouldLetDeSelect = true
        btnRememberMe?.tintColor = UIColor.white
        
        txtFieldEmailID.attributedPlaceholder = NSAttributedString(string: "Enter Email ID",
                                                                   attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        txtFieldPassword.attributedPlaceholder = NSAttributedString(string: "Enter Password",
                                                                    attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        txtFieldName.attributedPlaceholder = NSAttributedString(string: "Enter Name",
                                                                    attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        
    }
    
    func didSelectButton(selectedButton: UIButton?) {
    }

    @IBAction func btnLoginTapped(_ sender: UIButton) {
        validateIDAndPassword()
    }
    
    func validateIDAndPassword() {
//        if !isValidEmail(testStr: txtFieldEmailID.text!) {
//            let alert = UIAlertController(title: "Alert", message: "Email id is not valid", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//        else if !isValidPassword(str: txtFieldPassword.text!) {
//            let alert = UIAlertController(title: "Alert", message: "Password should be at least 6 characters long.", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//        else {
//            if (btnRememberMe?.isSelected)! {
//                // store email id and password in user defaults
//                let defaults = UserDefaults.standard
//                defaults.set(txtFieldEmailID.text, forKey: "emailid")
//                defaults.synchronize()
//            }
//            let defaults = UserDefaults.standard
//            defaults.set(0, forKey: "attempts")
//            defaults.set(0, forKey: "highScore")
//            defaults.synchronize()
//            self.performSegue(withIdentifier: "dashboardSegue", sender: self)
//        }
        
        if txtFieldName.text?.count == 0 {
            let alert = UIAlertController(title: "Alert", message: "Please enter name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let defaults = UserDefaults.standard
            
            if var arrayNames: NSMutableArray = defaults.object(forKey: "names") as? NSMutableArray {
                var myarray = NSMutableArray(array: arrayNames)
                myarray.add(txtFieldName.text)
                defaults.set(myarray, forKey: "names")
            }
            else {
                defaults.set(0, forKey: "highScore")
                var arrayNames = NSMutableArray()
                arrayNames.add(txtFieldName.text)
                defaults.set(arrayNames, forKey: "names")
            }
            defaults.set(0, forKey: "attempts")
            defaults.set(txtFieldName.text, forKey: "currentName")
            defaults.synchronize()
            
            self.performSegue(withIdentifier: "dashboardSegue", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
