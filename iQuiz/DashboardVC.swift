//
//  DashboardVC.swift
//  iQuiz
//
//  Created by MacStudent on 2017-10-13.
//  Copyright © 2017 MacStudent. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "skip")
        defaults.set(0, forKey: "correctAnswer")
        defaults.set(0, forKey: "wrongAnswer")
        defaults.synchronize()
        
        self.navigationItem.leftBarButtonItem = nil
        
        let logoutBarButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        logoutBarButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = logoutBarButton        
    }
    
    @objc func logoutTapped() {
        let defaults = UserDefaults.standard
        defaults.set("", forKey: "emailid")
        defaults.synchronize()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var nav: UINavigationController! = UINavigationController()
        nav =  storyboard.instantiateViewController(withIdentifier: "MainNavigationController") as! UINavigationController        
        self.present(nav, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.parent?.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
    
    @IBAction func btnStartTapped(_ sender: UIButton) {
        var arrayQuestions = NSArray()
        var arrayUniqNumbers = Set<Int>()
        while arrayUniqNumbers.count != 10 {
            let randomQuesIndex = (arc4random() % 20);
            arrayUniqNumbers.insert(Int(randomQuesIndex))
        }
        arrayQuestions = Array(arrayUniqNumbers) as NSArray
        let testVC = self.storyboard?.instantiateViewController(withIdentifier: "test") as! TestVC
        testVC.arrayQuestions = arrayQuestions
        self.present(testVC, animated: true, completion: nil)
    }
    
    @IBAction func btnInstructionTapped(_ sender: UIButton) {
        let instructionVC = self.storyboard?.instantiateViewController(withIdentifier: "instruction") as! InstructionVC
        self.present(instructionVC, animated: true, completion: nil)
    }
    
    @IBAction func btnStatisticsTapped(_ sender:UIButton) {
        let statisticsVC = self.storyboard?.instantiateViewController(withIdentifier: "statistics") as! StatisticsVC
        self.present(statisticsVC, animated: true, completion: nil)
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
