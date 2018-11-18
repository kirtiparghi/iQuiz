//
//  ResultVC.swift
//  iQuiz
//
//  Created by Kirti Parghi on 10/17/17.
//  Copyright © 2017 MacStudent. All rights reserved.
//

import UIKit

class ResultVC: UIViewController {
    
    @IBOutlet weak var imgViewCancel: UIImageView?
    
    @IBOutlet weak var bgView:UIView?
    
    var timer: Timer?
    var iFloat:Float?

    @IBOutlet weak var lblScore: UILabel?
    @IBOutlet weak var lblSkipQue: UILabel?
    @IBOutlet weak var lblCorrectAnswer: UILabel?
    @IBOutlet weak var lblWrongAnswer: UILabel?
    var finalScore:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblScore?.text = "YOUR SCORE IS \(finalScore!) OUT OF 10"
        
        let defaults = UserDefaults.standard
        
        lblSkipQue?.text = "You skipped \(defaults.value(forKey: "skip")!) questions"
        lblCorrectAnswer?.text = "Correct Answers \(defaults.value(forKey: "correctAnswer")!)"
        lblWrongAnswer?.text = "Wrong Answers \(defaults.value(forKey: "wrongAnswer")!)"
        
        bgView?.layer.cornerRadius = 40
        bgView?.layer.masksToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgViewCancel?.isUserInteractionEnabled = true
        imgViewCancel?.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let defaults = UserDefaults.standard
        if finalScore! > defaults.value(forKey: "highScore") as! Int {
            defaults.set(finalScore!, forKey: "highScore")
        }
        defaults.set(0, forKey: "skip")
        defaults.set(0, forKey: "correctAnswer")
        defaults.set(0, forKey: "wrongAnswer")
        
        var intAttempts = defaults.value(forKey: "attempts") as! Int
        intAttempts = intAttempts + 1
        
        defaults.set(intAttempts, forKey: "attempts")
        
        defaults.synchronize()
        
        var nav: UINavigationController! = UINavigationController()
        nav =  storyboard?.instantiateViewController(withIdentifier: "DashboardNavigationController") as! UINavigationController
        //let dashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "dashboard") as! DashboardVC
        self.present(nav, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
