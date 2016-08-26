//
//  ViewController.swift
//  gigaPet
//
//  Created by Evgeny Vlasov on 8/22/16.
//  Copyright © 2016 Evgeny Vlasov. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var monsterImg: MonsterImg!
    @IBOutlet weak var humanImg: HumanImg!
    
    @IBOutlet weak var foodImg: DragImg!
    @IBOutlet weak var heartImg: DragImg!
    @IBOutlet weak var elixirImg: DragImg!
    
    @IBOutlet weak var penalty1Img: UIImageView!
    @IBOutlet weak var penalty2Img: UIImageView!
    @IBOutlet weak var penalty3Img: UIImageView!
    
    @IBOutlet weak var gameOverLbl: UILabel!
    
    
    @IBOutlet weak var stoneBtn: UIButton!
    @IBOutlet weak var humanBtn: UIButton!
    
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAQUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penelaties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxHeart: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        startNewGame()
        
        monsterImg.hidden = true
        humanImg.hidden = true
        
    }
    
    @IBAction func restartBtn(sender: AnyObject) {
        
        if timer != nil {
            timer.invalidate()
        }
        
        startNewGame()
        
    }
    
    @IBAction func stoneBtn(sender: AnyObject) {
        
        // reveal character img, start the game.
        // hide buttons.
        
        humanImg.hidden = true
        monsterImg.hidden = false
        monsterImg.playIdleAnimation()
        startNewGame()

    }
    
    @IBAction func humanBtn(sender: AnyObject) {
        
        // reveal the other character img, start the game. 
        // hide the buttons. 
        
        monsterImg.hidden = true
        humanImg.hidden = false
        
        humanImg.playIdleAnimation()
        
        startNewGame()
        
    }

    
    
    func itemDroppedOnCharacter(notif: AnyObject){
        monsterHappy = true
        startTimer()
        
        foodImg.alpha = DIM_ALPHA
        foodImg.userInteractionEnabled = false
        heartImg.alpha = DIM_ALPHA
        heartImg.userInteractionEnabled = false
        elixirImg.alpha = DIM_ALPHA
        elixirImg.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxHeart.play()
        } else {
            sfxBite.play()
        }
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "changeGameState", userInfo: nil, repeats: true)
    }
    
    func changeGameState(){
        
        
        if !monsterHappy {
        penelaties++
            
            sfxSkull.play()
        
        if penelaties == 1 {
            penalty1Img.alpha = OPAQUE
            penalty2Img.alpha = DIM_ALPHA
        } else if penelaties == 2 {
            penalty2Img.alpha = OPAQUE
            penalty3Img.alpha = DIM_ALPHA
        } else if penelaties >= 3 {
            penalty3Img.alpha = OPAQUE
        } else {
            penalty1Img.alpha = DIM_ALPHA
            penalty2Img.alpha = DIM_ALPHA
            penalty3Img.alpha = DIM_ALPHA
        }
        
        if penelaties >= MAX_PENALTIES {
            gameOver()
        }
        }
        
        let rand = arc4random_uniform(3)
        if rand == 0 {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            elixirImg.alpha = DIM_ALPHA
            elixirImg.userInteractionEnabled = false
            
            heartImg.alpha = OPAQUE
            heartImg.userInteractionEnabled = true
        } else if rand == 1 {
            foodImg.alpha = OPAQUE
            foodImg.userInteractionEnabled = true
            
            elixirImg.alpha = DIM_ALPHA
            elixirImg.userInteractionEnabled = false
            
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
        
        } else if rand == 2 {
            foodImg.alpha = DIM_ALPHA
            foodImg.userInteractionEnabled = false
            
            elixirImg.alpha = OPAQUE
            elixirImg.userInteractionEnabled = true
            
            heartImg.alpha = DIM_ALPHA
            heartImg.userInteractionEnabled = false
        }
        
        currentItem = rand
        monsterHappy = false
    }

    func gameOver() {
        
        gameOverLbl.hidden = false
        timer.invalidate()
        
            monsterImg.playDeathAnimation()
            humanImg.playDeathAnimation()
        
        // this piece of code doesn't work for some reason
        
      
        sfxDeath.play()
    }
    
    func startNewGame() {
        
        monsterImg.playIdleAnimation()
        humanImg.playIdleAnimation()
        
        
        stoneBtn.hidden = true
        humanBtn.hidden = true
        
        penelaties = 0
        timer = nil
        gameOverLbl.hidden = true
        monsterHappy = true
        currentItem = 0
        
        foodImg.alpha = OPAQUE
        heartImg.alpha = OPAQUE
        elixirImg.alpha = OPAQUE
        
        foodImg.dropTarget = monsterImg
        heartImg.dropTarget = monsterImg
        elixirImg.dropTarget = monsterImg
        
        penalty1Img.alpha = DIM_ALPHA
        penalty2Img.alpha = DIM_ALPHA
        penalty3Img.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do {
            try musicPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("cave-music", ofType: "mp3")!))
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bite", ofType: "wav")!))
            
            try sfxHeart = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("heart", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("death", ofType: "wav")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("skull", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxHeart.prepareToPlay()
            sfxSkull.prepareToPlay()
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        startTimer()
    
    }

}

















