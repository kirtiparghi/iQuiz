//
//  StatisticsVC.swift
//  iQuiz
//
//  Created by Kirti Parghi on 10/18/17.
//  Copyright © 2017 MacStudent. All rights reserved.
//

import UIKit

class StatisticsVC: UIViewController {

    @IBOutlet weak var lblUserName: UILabel!

    @IBOutlet weak var imgViewCancel:UIImageView?
    @IBOutlet weak var lblAttempts:UILabel?
    @IBOutlet weak var lblHighScore:UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgViewCancel?.isUserInteractionEnabled = true
        imgViewCancel?.addGestureRecognizer(tapGestureRecognizer)
        
        let defaults = UserDefaults.standard
        
        if defaults.value(forKey: "attempts") == nil {
            lblAttempts?.text = "Number Of Attempts 0"
        }
        else {
            lblAttempts?.text = "Number Of Attempts \(defaults.value(forKey: "attempts")!)"
        }
        
        if defaults.value(forKey: "highScore") == nil {
            lblHighScore?.text = "Highest score is 0"
        }
        else {
            lblHighScore?.text = "Highest score is \(defaults.value(forKey: "highScore")!)"
        }
        lblUserName.text = defaults.value(forKey: "currentName") as! String        
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
