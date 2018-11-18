//
//  TestVC.swift
//  iQuiz
//
//  Created by Kirti Parghi on 10/17/17.
//  Copyright © 2017 MacStudent. All rights reserved.
//

import UIKit
import QuartzCore
import AVFoundation

class TestVC: UIViewController, AVSpeechSynthesizerDelegate {

    let speechSynthesizer = AVSpeechSynthesizer()
    
    var rate: Float!
    
    var pitch: Float!
    
    var volume: Float!
    
    var totalUtterances: Int! = 0
    
    var currentUtterance: Int! = 0
    
    var totalTextLength: Int = 0
    
    var spokenTextLengths: Int = 0
    
    var preferredVoiceLanguageCode: String!
    
    var previousSelectedRange: NSRange!
    
    @IBOutlet weak var imgViewCancel: UIImageView?
    
    var arrayQuestions: NSArray?
    var arrayQuestionAnswer: NSMutableArray?
    
    var timer: Timer?
    @IBOutlet var progress:UIProgressView?
    var iFloat:Float?
    var intCurrentQuestion: Int?
    var intCounter: Int?
    var intFinalScore: Int?

    @IBOutlet weak var lblQuestion: UILabel?
    @IBOutlet weak var btnOption1: UIButton?
    @IBOutlet weak var btnOption2: UIButton?
    @IBOutlet weak var btnOption3: UIButton?
    @IBOutlet weak var btnOption4: UIButton?
    @IBOutlet weak var btnNext: UIButton?
    @IBOutlet weak var lblSeconds: UILabel?
    @IBOutlet weak var lblCurrentQuestion: UILabel?
    
    var dictQuestion: NSMutableDictionary?
    var strCurrentSelectAnswer: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arrayQuestionAnswer = NSMutableArray()
        fetchQuestionsFromPList()
        
        intFinalScore = 0
        iFloat = 0
        intCurrentQuestion = 1
        intCounter = 10
        lblSeconds?.text = "\(intCounter!) Sec"
        dictQuestion = NSMutableDictionary()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
        displayNextQuestion()
        
        lblCurrentQuestion?.adjustsFontSizeToFitWidth = true
        lblSeconds?.adjustsFontSizeToFitWidth = true
        btnOption1?.titleLabel?.adjustsFontSizeToFitWidth = true
        btnOption2?.titleLabel?.adjustsFontSizeToFitWidth = true
        btnOption3?.titleLabel?.adjustsFontSizeToFitWidth = true
        btnOption4?.titleLabel?.adjustsFontSizeToFitWidth = true
        lblQuestion?.adjustsFontSizeToFitWidth = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgViewCancel?.isUserInteractionEnabled = true
        imgViewCancel?.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(speak(tapGestureRecognizer:)))
        lblQuestion?.isUserInteractionEnabled = true
        lblQuestion?.addGestureRecognizer(tapGestureRecognizer1)
        
        btnOption1?.backgroundColor = UIColor.gray
        btnOption2?.backgroundColor = UIColor.gray
        btnOption3?.backgroundColor = UIColor.gray
        btnOption4?.backgroundColor = UIColor.gray
        
        if !loadSettings() {
            registerDefaultSettings()
        }
        
        speechSynthesizer.delegate = self
        strCurrentSelectAnswer = String()
    }
    
    @objc func speak(tapGestureRecognizer: UITapGestureRecognizer) {
        if !speechSynthesizer.isSpeaking {
            /**
             let speechUtterance = AVSpeechUtterance(string: tvEditor.text)
             speechUtterance.rate = rate
             speechUtterance.pitchMultiplier = pitch
             speechUtterance.volume = volume
             speechSynthesizer.speakUtterance(speechUtterance)
             */
            let index = lblQuestion?.text?.index((lblQuestion!.text?.startIndex)!, offsetBy: 3)

            var textParagraphs = lblQuestion?.text!.substring(from: index!)
            print("text para \(textParagraphs!)")
            totalUtterances = textParagraphs!.count
            currentUtterance = 0
            totalTextLength = 0
            spokenTextLengths = 0

            //for pieceOfText in textParagraphs! {
            let speechUtterance = AVSpeechUtterance(string: String(describing: textParagraphs!))
                speechUtterance.rate = rate
                speechUtterance.pitchMultiplier = pitch
                speechUtterance.volume = volume
                speechUtterance.postUtteranceDelay = 0.005

                if let voiceLanguageCode = preferredVoiceLanguageCode {
                    let voice = AVSpeechSynthesisVoice(language: voiceLanguageCode)
                    speechUtterance.voice = voice
                }

            totalTextLength = totalTextLength + String(describing: textParagraphs!).utf16.count

                speechSynthesizer.speak(speechUtterance)
           // }
        }
        else{
            speechSynthesizer.continueSpeaking()
        }
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        let defaults = UserDefaults.standard
        defaults.set(0, forKey: "skip")
        defaults.set(0, forKey: "correctAnswer")
        defaults.set(0, forKey: "wrongAnswer")
        defaults.synchronize()

        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnNextTapped(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        print("==========BEFORE INT CURRENT QUESTION --- \(String(describing: intCurrentQuestion))")
        if intCurrentQuestion! > Int(9) {
            if timer != nil {
                timer!.invalidate()
                timer = nil
            }
            print("inside segue.......................")
            let index = strCurrentSelectAnswer?.index((strCurrentSelectAnswer?.startIndex)!, offsetBy: 3)
            if strCurrentSelectAnswer!.substring(from: index!) == dictQuestion!.value(forKey: "answer") as! String {
                var intCorrectAnswer = defaults.value(forKey: "correctAnswer") as! Int
                intCorrectAnswer = intCorrectAnswer + 1
                defaults.set(intCorrectAnswer, forKey: "correctAnswer")
            }
            else if checkForSkipAnswer() {
                var intSkipAnswer = defaults.value(forKey: "skip") as! Int
                intSkipAnswer = intSkipAnswer + 1
                defaults.set(intSkipAnswer, forKey: "skip")
            }
            else {
                var intWrongAnswer = defaults.value(forKey: "wrongAnswer") as! Int
                intWrongAnswer = intWrongAnswer + 1
                defaults.set(intWrongAnswer, forKey: "wrongAnswer")
            }
            defaults.synchronize()

            self.performSegue(withIdentifier: "resultSegue", sender: self)
        }
        else {
            if strCurrentSelectAnswer.characters.count > 0 {
                let index = strCurrentSelectAnswer?.index((strCurrentSelectAnswer?.startIndex)!, offsetBy: 3)
                if strCurrentSelectAnswer!.substring(from: index!) == dictQuestion!.value(forKey: "answer") as! String {
                    var intCorrectAnswer = defaults.value(forKey: "correctAnswer") as! Int
                    intCorrectAnswer = intCorrectAnswer + 1
                    defaults.set(intCorrectAnswer, forKey: "correctAnswer")
                }
                else if checkForSkipAnswer() {
                    var intSkipAnswer = defaults.value(forKey: "skip") as! Int
                    intSkipAnswer = intSkipAnswer + 1
                    defaults.set(intSkipAnswer, forKey: "skip")
                }
                else {
                    var intWrongAnswer = defaults.value(forKey: "wrongAnswer") as! Int
                    intWrongAnswer = intWrongAnswer + 1
                    defaults.set(intWrongAnswer, forKey: "wrongAnswer")
                }
                defaults.synchronize()
            }
            
            if intCurrentQuestion! < 10 {
                intCurrentQuestion = intCurrentQuestion! + 1
            }
            print("==========AFTER INT CURRENT QUESTION --- \(intCurrentQuestion)")
        timer!.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)

        iFloat = 0
        intCounter = 10
        lblCurrentQuestion?.text = "\(intCurrentQuestion!)/10"
        displayNextQuestion()
        btnOption1?.backgroundColor = UIColor.gray
        btnOption2?.backgroundColor = UIColor.gray
        btnOption3?.backgroundColor = UIColor.gray
        btnOption4?.backgroundColor = UIColor.gray

        iFloat = iFloat! + 0.1
        intCounter = intCounter! - 1
        print("intCounter \(String(describing: intCounter))")
        lblSeconds?.text = "\(intCounter!) Sec"
        progress?.setProgress(iFloat!, animated: true)
        }
        print("=============== skip \(defaults.value(forKey: "skip"))")
        print("=============== correct \(defaults.value(forKey: "correctAnswer"))")
        print("=============== wrong \(defaults.value(forKey: "wrongAnswer"))")
    }
    
    @IBAction func btnOptionsTapped(_ sender: UIButton) {
        strCurrentSelectAnswer = sender.titleLabel!.text
        print(dictQuestion!.value(forKey: "answer") as! String)
        print(strCurrentSelectAnswer)
        let index = sender.titleLabel!.text?.index((sender.titleLabel!.text?.startIndex)!, offsetBy: 3)
        if sender.titleLabel!.text!.substring(from: index!) == dictQuestion!.value(forKey: "answer") as! String {
            intFinalScore = intFinalScore! + 1
        }
        
        print("final score---> \(intFinalScore)")
        
        switch sender.tag {
            case 1: // OPTION 1 IS SELECTED
                        btnOption1?.backgroundColor = UIColor.brown
                        btnOption2?.backgroundColor = UIColor.gray
                        btnOption3?.backgroundColor = UIColor.gray
                        btnOption4?.backgroundColor = UIColor.gray
            case 2: // OPTION 2 IS SELECTED
                    btnOption1?.backgroundColor = UIColor.gray
                    btnOption2?.backgroundColor = UIColor.brown
                    btnOption3?.backgroundColor = UIColor.gray
                    btnOption4?.backgroundColor = UIColor.gray
            case 3: // OPTION 3 IS SELECTED
                    btnOption1?.backgroundColor = UIColor.gray
                    btnOption2?.backgroundColor = UIColor.gray
                    btnOption3?.backgroundColor = UIColor.brown
                    btnOption4?.backgroundColor = UIColor.gray
            case 4: // OPTION 4 IS SELECTED
                    btnOption1?.backgroundColor = UIColor.gray
                    btnOption2?.backgroundColor = UIColor.gray
                    btnOption3?.backgroundColor = UIColor.gray
                    btnOption4?.backgroundColor = UIColor.brown
        default: break
        }
    }
    
    @objc func update() {
        print("current ---> \(intCurrentQuestion)")
        if iFloat!  >= Float(1) {
            
            let defaults = UserDefaults.standard
            if strCurrentSelectAnswer.characters.count > 0 {
                let index = strCurrentSelectAnswer?.index((strCurrentSelectAnswer?.startIndex)!, offsetBy: 3)
                if strCurrentSelectAnswer!.substring(from: index!) == dictQuestion!.value(forKey: "answer") as! String {
                    var intCorrectAnswer = defaults.value(forKey: "correctAnswer") as! Int
                    intCorrectAnswer = intCorrectAnswer + 1
                    defaults.set(intCorrectAnswer, forKey: "correctAnswer")
                }
                else if checkForSkipAnswer() {
                    var intSkipAnswer = defaults.value(forKey: "skip") as! Int
                    intSkipAnswer = intSkipAnswer + 1
                    defaults.set(intSkipAnswer, forKey: "skip")
                }
                else {
                    var intWrongAnswer = defaults.value(forKey: "wrongAnswer") as! Int
                    intWrongAnswer = intWrongAnswer + 1
                    defaults.set(intWrongAnswer, forKey: "wrongAnswer")
                }
                defaults.synchronize()
            }
            
            if intCurrentQuestion! >= Int(10) {
                if timer != nil {
                    timer!.invalidate()
                    timer = nil
                }
                self.performSegue(withIdentifier: "resultSegue", sender: self)
            }
            else {
                iFloat = 0
                timer!.invalidate()
                timer = nil
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.update), userInfo: nil, repeats: true)
            }
            intCurrentQuestion = intCurrentQuestion! + 1
            if intCurrentQuestion! <= Int(10) {
                displayNextQuestion()
            }
            
            intCounter = 10
            
            btnOption1?.backgroundColor = UIColor.gray
            btnOption2?.backgroundColor = UIColor.gray
            btnOption3?.backgroundColor = UIColor.gray
            btnOption4?.backgroundColor = UIColor.gray
        }
        lblCurrentQuestion?.text = "\(intCurrentQuestion!)/10"
        iFloat = iFloat! + 0.1
        intCounter = intCounter! - 1
        print("intCounter \(String(describing: intCounter))")
        lblSeconds?.text = "\(intCounter!) Sec"
        progress?.setProgress(iFloat!, animated: true)
        
        let defaults = UserDefaults.standard
        
        print("=============== skip \(String(describing: defaults.value(forKey: "skip")))")
        print("=============== correct \(String(describing: defaults.value(forKey: "correctAnswer")))")
        print("=============== wrong \(String(describing: defaults.value(forKey: "wrongAnswer")))")
    }

    func checkForSkipAnswer() -> Bool {
        if btnOption1?.backgroundColor == UIColor.gray && btnOption2?.backgroundColor == UIColor.gray && btnOption3?.backgroundColor == UIColor.gray && btnOption4?.backgroundColor == UIColor.gray {
            return true
        }
        else {
            return false
        }
    }
    
    func displayNextQuestion() {
        print("current counter --> \(String(describing: intCurrentQuestion))")

        print("size of array question answer --> \(String(describing: arrayQuestionAnswer?.count))")
        dictQuestion = arrayQuestionAnswer?[intCurrentQuestion!-1] as? NSMutableDictionary
        print(dictQuestion.debugDescription)
        lblQuestion?.text = "\(String(describing: intCurrentQuestion!)). \(String(describing: dictQuestion!.value(forKey: "question")!))"
        let dictOptions = dictQuestion!.value(forKey: "options") as! NSMutableDictionary
        btnOption1?.setTitle("A. \(String(describing: dictOptions.value(forKey: "A")!))", for: .normal)
        btnOption2?.setTitle("B. \(String(describing: dictOptions.value(forKey: "B")!))", for: .normal)
        btnOption3?.setTitle("C. \(String(describing: dictOptions.value(forKey: "C")!))", for: .normal)
        btnOption4?.setTitle("D. \(String(describing: dictOptions.value(forKey: "D")!))", for: .normal)
    }
    
    func fetchQuestionsFromPList() {
        var array: NSArray?
        if let path = Bundle.main.path(forResource: "QAPlist", ofType: "plist") {
            array = NSArray(contentsOfFile: path)
        }
        if array != nil {
            for index in arrayQuestions! {
                arrayQuestionAnswer?.add(array![index as! Int])
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let resultVC = segue.destination as! ResultVC
        resultVC.finalScore = intFinalScore
    }
    
    func registerDefaultSettings() {
        rate = AVSpeechUtteranceDefaultSpeechRate
        pitch = 1.0
        volume = 1.0
        
        let defaultSpeechSettings: Dictionary<NSObject, AnyObject> = ["rate" as NSObject: rate as AnyObject, "pitch" as NSObject: pitch as AnyObject, "volume" as NSObject: volume as AnyObject]
        UserDefaults.standard.register(defaults: defaultSpeechSettings as! [String : Any])
    }
    
    
    func loadSettings() -> Bool {
        let userDefaults = UserDefaults.standard as UserDefaults
        
        if let theRate: Float = userDefaults.value(forKey: "rate") as? Float {
            rate = theRate
            pitch = userDefaults.value(forKey: "pitch") as! Float
            volume = userDefaults.value(forKey:"volume") as! Float
            
            return true
        }
        return false
    }
    
    // MARK: AVSpeechSynthesizerDelegate method implementation
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        currentUtterance = currentUtterance + 1
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
    }
}
