//
//  Utils.swift
//  iQuiz
//
//  Created by MacStudent on 2017-10-13.
//  Copyright © 2017 MacStudent. All rights reserved.
//
import UIKit

//*****************************************************************
// MARK: - Extensions
//*****************************************************************

public extension UIColor {
  public class func fuberBlue()->UIColor {
    struct C {
      static var c : UIColor = UIColor.gray
    }
    return C.c
  }
  
  public class func fuberLightBlue()->UIColor {
    struct C {
      static var c : UIColor = UIColor.white
    }
    return C.c
  }
}

public func isValidEmail(testStr:String) -> Bool {
    // print("validate calendar: \(testStr)")
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

public func isValidPassword(str:String) -> Bool {
    if str.characters.count > 5 {
        return true
    }
    return false
}

//*****************************************************************
// MARK: - Helper Functions
//*****************************************************************

public func delay(_ delay:Double, closure:@escaping ()->()) {
  DispatchQueue.main.asyncAfter(
    deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
