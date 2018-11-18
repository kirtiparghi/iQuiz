//
//  Costants.swift
//  iQuiz
//
//  Created by MacStudent on 2017-10-13.
//  Copyright © 2017 MacStudent. All rights reserved.
//

import Foundation

/// The total animation duration of the splash animation
let kAnimationDuration: TimeInterval = 3.0

/// The length of the second part of the duration
let kAnimationDurationDelay: TimeInterval = 0.5

/// The offset between the AnimatedULogoView and the background Grid
let kAnimationTimeOffset: CFTimeInterval = 0.35 * kAnimationDuration

/// The ripple magnitude. Increase by small amounts for amusement ( <= .2) :]
let kRippleMagnitudeMultiplier: Float = 0.025

let kQuizInstruction : String = "<HTML><body><p style=\"color:white;\">The quiz consists of questions carefully designed to help you self assess your conprehension of the information presented on the topics convered in the module. No data will be collected on the website regarding your responses or how many times you take the quiz.</p><p style=\"color:white;\">Each question in the quiz is of multiple choice or true or false format. Read each question carefully and click on the button next to your response that is based on the information covered on the topic in the module. Each correct or incorrect response will result in appropriate feedback immediately at the bottom of the screen.</p><p style=\"color:white;\">After responding to a question, click on the \"Next Question\" button at the bottom to go to the next question.After responding to the 10th question, click on \"Close\" on the top of the window to exit the quiz.</p><p style=\"color:white;\">If you select an incorrect response for a question, you can try again until you get the correct response. If you retake the quiz, the questions and their respective responses will be randomized.</p><p style=\"color:white;\">The total score for the quiz is based on your responses to all questions. If you respond incorrectly toa question or retake a question again and get the correect response, your quiz score will reflect it appropriately. However, your quiz will not be graded, if you skip a question or exit before responding to all the questions.</p></body></HTML>"
