//
//  InstructionVC.swift
//  iQuiz
//
//  Created by Kirti Parghi on 10/16/17.
//  Copyright © 2017 MacStudent. All rights reserved.
//

import UIKit

class InstructionVC: UIViewController,UIWebViewDelegate {
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imgViewCancel:UIImageView?
    @IBOutlet weak var webViewInstruction: UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        imgViewCancel?.isUserInteractionEnabled = true
        imgViewCancel?.addGestureRecognizer(tapGestureRecognizer)
        
        webViewInstruction?.delegate = self

        loadDataInWebView()
    }
    
    func loadDataInWebView() {
        webViewInstruction?.loadHTMLString(kQuizInstruction, baseURL: nil)
        webViewInstruction?.backgroundColor = UIColor.clear
        webViewInstruction?.isOpaque = false
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        progressIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        progressIndicator.stopAnimating()
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
