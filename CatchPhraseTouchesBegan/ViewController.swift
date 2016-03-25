//
//  ViewController.swift
//  CatchPhraseTouchesBegan
//
//  Created by Nishanth Pasham on 1/21/16.
//  Copyright (c) 2016 Nishanth Pasham. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UITextField!
    
    @IBOutlet weak var team1ScoreLabel: UITextField!
    
    @IBOutlet weak var team2ScoreLabel: UITextField!
    
//    @IBOutlet var team1ScoreTextView: UITextView!
    
    var backgroundMusic : AVAudioPlayer?
    
    var timer = NSTimer()
    var counter = 0
    
    //team scores
    var team1Score = 0
    var team2Score = 0
    
    @IBAction func addAPointToTeam1(){
        if(counter == 0) {
            if(team1Score < 7) {
                team1Score++
                team1ScoreLabel.text = String(team1Score)
//                team1ScoreTextView.text = String(team1Score)
            }
        } else {
            print("Please stop clock before updating score! \n")
        }
        checkIfThereIsAWinner();
    }
    
    @IBAction func addAPointToTeam2(){
        if(counter == 0) {
            if(team2Score < 7) {
                team2Score++
                team2ScoreLabel.text = String(team2Score)
            }
        } else {
            print("Please stop clock before updating score! \n")
        }
        checkIfThereIsAWinner();
    }
    
    func checkIfThereIsAWinner() {
        if(team1Score == 7){
            print("Team 1 wins! \n")
        }
        else if(team2Score == 7) {
            print("Team 2 wins! \n")
        }
    }
    
    static func arrayFromContentsOfFileWithName(fileName: String) -> [String]? {
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt")
        let content = String(contentsOfFile: path!, encoding: NSUTF8StringEncoding)
        return content!.componentsSeparatedByString("\n")
    }
    
    static let catchphrasewordsfilename = "catchphrases"
    static let catchphrasewords : [String] = ViewController.arrayFromContentsOfFileWithName(ViewController.catchphrasewordsfilename)!;
    static let length : UInt32? = UInt32(ViewController.catchphrasewords.count)
    
    func returnACatchPhraseWord(){
        let randNum = Int(arc4random_uniform(ViewController.length!-1))
//        print("The value of randNum is \(randNum) \n")
        label.text = ViewController.catchphrasewords[randNum]
    }
    
    func setupAudioPlayerWithFile(file:NSString, type:NSString) -> AVAudioPlayer?  {
        
        let path = NSBundle.mainBundle().pathForResource(file as String, ofType: type as String)
        let url = NSURL.fileURLWithPath(path!)
        var audioPlayer:AVAudioPlayer?
        audioPlayer = AVAudioPlayer(contentsOfURL: url, error: nil)
        audioPlayer?.numberOfLoops = -1
        audioPlayer?.enableRate = true
        audioPlayer?.rate = 0.2;
        return audioPlayer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.purpleColor()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if(counter != 0) {
            self.returnACatchPhraseWord()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startButton(sender: AnyObject) {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector: Selector("updateAndCheckCounter"), userInfo: nil, repeats: true)
        team1ScoreLabel.text = String(team1Score)
        team2ScoreLabel.text = String(team2Score)
        if let backgroundMusic = self.setupAudioPlayerWithFile("clock_ticking", type:"wav") {
            self.backgroundMusic = backgroundMusic
        }
        self.returnACatchPhraseWord()
        self.backgroundMusic?.play()
    }
    
    @IBAction func stopButton(sender: AnyObject) {
        timer.invalidate()
        counter = 0
        backgroundMusic?.stop()
    }
    
    func updateAndCheckCounter() {
        self.counter++
        if (self.counter < 10) {
            if(self.counter < 5){
                self.backgroundMusic?.rate = 1
            } else {
                self.backgroundMusic?.rate = 3
            }
        } else {
            counter = 0
            timer.invalidate()
            if let backgroundMusic = self.setupAudioPlayerWithFile("Buzzer", type:"wav") {
                self.backgroundMusic?.stop()
                self.backgroundMusic = backgroundMusic
            }
            self.backgroundMusic?.numberOfLoops = 0
            self.backgroundMusic?.play()
            sleep(1)
            self.backgroundMusic?.stop()
        }
    }
    

}

