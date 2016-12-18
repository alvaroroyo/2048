//
//  ViewController.swift
//  2048
//
//  Created by Alvaro Royo on 16/12/16.
//  Copyright © 2016 Alvaro Royo. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    //STATICS
    let DIRECTION_DOWN   = [12,8,4,0,13,9,5,1,14,10,6,2,15,11,7,3]
    let DIRECTION_UP     = [0,4,8,12,1,5,9,13,2,6,10,14,3,7,11,15]
    let DIRECTION_RIGHT  = [3,2,1,0,7,6,5,4,11,10,9,8,15,14,13,12]
    let DIRECTION_LEFT   = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
    
    //Views:
    var views : [String:UIView]!
    
    var scoreView : UIView!
    var scoreLbl : UILabel!
    var scorePointsLbl : UILabel!
    var bestScoreView : UIView!
    var bestScoreLbl : UILabel!
    var bestScorePointsLbl : UILabel!
    var tableroView : UIView!
    var resetBtn : UIButton!
    
    var chipsPositions = Array<CGRect>()
    var chipsInGame : [Any] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    
    //STATUS
    var score = 0 {
        didSet{
            scorePointsLbl.text = score.description
            
            if(bestScore < score){
                bestScorePointsLbl.text = score.description
                UserDefaults().set(score, forKey: "BestScore")
            }
            
        }
    }
    var bestScore = 0
    var gameWon = false
    
    override func loadView() {
        self.view = UIView(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.colorWithHex(hex: "#FAF8EF", alpha: 1)
        
        scoreView = UIView()
        scoreView.layer.cornerRadius = 7
        scoreView.backgroundColor = UIColor.colorWithHex(hex: "#BBADA0", alpha: 1)
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scoreView)
        
        scoreLbl = UILabel()
        scoreLbl.text = "Score"
        scoreLbl.textAlignment = .center
        scoreLbl.textColor = UIColor.colorWithHex(hex: "#EEE4DA", alpha: 1)
        scoreLbl.font = UIFont(name: "PingFangHK-Medium", size: 17)
        scoreLbl.translatesAutoresizingMaskIntoConstraints = false
        scoreView.addSubview(scoreLbl)
        
        scorePointsLbl = UILabel()
        scorePointsLbl.text = "0"
        scorePointsLbl.textAlignment = .center
        scorePointsLbl.textColor = UIColor.white
        scorePointsLbl.font = UIFont(name: "PingFangHK-Medium", size: 17)
        scorePointsLbl.translatesAutoresizingMaskIntoConstraints = false
        scoreView.addSubview(scorePointsLbl)
        
        bestScoreView = UIView()
        bestScoreView.layer.cornerRadius = 7
        bestScoreView.backgroundColor = UIColor.colorWithHex(hex: "#BBADA0", alpha: 1)
        bestScoreView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bestScoreView)
        
        bestScoreLbl = UILabel()
        bestScoreLbl.text = "Best Score"
        bestScoreLbl.textAlignment = .center
        bestScoreLbl.textColor = UIColor.colorWithHex(hex: "#EEE4DA", alpha: 1)
        bestScoreLbl.font = UIFont(name: "PingFangHK-Medium", size: 17)
        bestScoreLbl.translatesAutoresizingMaskIntoConstraints = false
        bestScoreView.addSubview(bestScoreLbl)
        
        bestScorePointsLbl = UILabel()
        bestScorePointsLbl.textAlignment = .center
        bestScorePointsLbl.textColor = UIColor.white
        bestScorePointsLbl.font = UIFont(name: "PingFangHK-Medium", size: 17)
        bestScorePointsLbl.translatesAutoresizingMaskIntoConstraints = false
        bestScoreView.addSubview(bestScorePointsLbl)
        
        tableroView = UIView()
        tableroView.translatesAutoresizingMaskIntoConstraints = false
        tableroView.clipsToBounds = true
        tableroView.layer.cornerRadius = 7
        tableroView.backgroundColor = UIColor.colorWithHex(hex: "#BBADA0", alpha: 1)
        self.view.addSubview(tableroView)
        
        resetBtn = UIButton()
        resetBtn.setBackgroundImage(UIImage.imageWithColor(color: UIColor.colorWithHex(hex: "#EF5350", alpha: 1)), for: .normal)
        resetBtn.setTitle("Reset", for: .normal)
        resetBtn.setTitleColor(UIColor.white, for: .normal)
        resetBtn.layer.cornerRadius = 7
        resetBtn.clipsToBounds = true
        resetBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(resetBtn)
        
        views = ["scoreView":scoreView,"bestScoreView":bestScoreView,"tableroView":tableroView,"resetBtn":resetBtn,"scoreLbl":scoreLbl,"scorePointsLbl":scorePointsLbl,"bestScoreLbl":bestScoreLbl,"bestScorePointsLbl":bestScorePointsLbl]
        
        let isLandscape = self.view.frame.width > self.view.frame.height
        setConstraints(with: isLandscape)
        setTableSpaces(with: isLandscape)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        tableroView.addGestureRecognizer(swipeUp)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        tableroView.addGestureRecognizer(swipeDown)
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        tableroView.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        tableroView.addGestureRecognizer(swipeRight)
        
        resetBtn.addTarget(self, action: #selector(reset), for: .touchUpInside)
        
        bestScore = UserDefaults().integer(forKey: "BestScore")
        bestScorePointsLbl.text = bestScore.description
        
        addNewChip()
        addNewChip()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setConstraints(with: nil)
    }
    
    func setConstraints(with isLandscape:Bool?){
        
        var constraints : Array<NSLayoutConstraint>!
        
        self.view.removeConstraints(self.view.constraints)
        scoreView.removeConstraints(scoreView.constraints)
        bestScoreView.removeConstraints(bestScoreView.constraints)
        
        if UIDevice.current.orientation.isLandscape || isLandscape == true{
            //LANDSCAPE VIEW
            
            constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[scoreView(150)]", options: [], metrics: nil, views: views)
            constraints = constraints + NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[bestScoreView(150)]", options: [], metrics: nil, views: views)
            constraints = constraints + NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[resetBtn(150)]", options: [], metrics: nil, views: views)
            constraints = constraints + NSLayoutConstraint.constraints(withVisualFormat: "H:[tableroView]-20-|", options: [], metrics: nil, views: views)
            constraints = constraints + [NSLayoutConstraint.init(item: tableroView, attribute: .width, relatedBy: .equal, toItem: tableroView, attribute: .height, multiplier: 1, constant: 0)]
            
            constraints = constraints + NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[scoreView(50)]-20-[bestScoreView(50)]", options: [], metrics: nil, views: views)
            constraints = constraints + NSLayoutConstraint.constraints(withVisualFormat: "V:[resetBtn(50)]-20-|", options: [], metrics: nil, views: views)
            constraints = constraints + NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[tableroView]-20-|", options: [], metrics: nil, views: views)
            
        }else{
            //PORTRAIT VIEW
            
            constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[scoreView(>=100)]-10-[bestScoreView(==scoreView)]-20-|", options: [], metrics: nil, views: views)
            constraints = constraints + NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[tableroView]-20-|", options: [], metrics: nil, views: views)
            constraints = constraints + NSLayoutConstraint.constraints(withVisualFormat: "H:[resetBtn(120)]", options: [], metrics: nil, views: views)
            constraints = constraints + [NSLayoutConstraint.init(item: resetBtn, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)]
            
            constraints = constraints + NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[scoreView(50)]", options: [], metrics: nil, views: views)
            constraints = constraints + NSLayoutConstraint.constraints(withVisualFormat: "V:|-50-[bestScoreView(50)]", options: [], metrics: nil, views: views)
            constraints = constraints + [NSLayoutConstraint.init(item: tableroView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)]
            constraints = constraints + [NSLayoutConstraint.init(item: tableroView, attribute: .height, relatedBy: .equal, toItem: tableroView, attribute: .width, multiplier: 1, constant: 0)]
            constraints = constraints + NSLayoutConstraint.constraints(withVisualFormat: "V:[tableroView]-30-[resetBtn(50)]", options: [], metrics: nil, views: views)
            
        }
        
        self.view.addConstraints(constraints)
        
        //SUBVIEWS CONSTRAINTS
        
        var scoreConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[scoreLbl]-0-|", options: [], metrics: nil, views: views)
        scoreConstraints = scoreConstraints + NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[scorePointsLbl]-0-|", options: [], metrics: nil, views: views)
        scoreConstraints = scoreConstraints + NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[scoreLbl(18)]-0-[scorePointsLbl]", options: [], metrics: nil, views: views)
        scoreView.addConstraints(scoreConstraints)
        
        var bestScoreConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[bestScoreLbl]-0-|", options: [], metrics: nil, views: views)
        bestScoreConstraints = bestScoreConstraints + NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[bestScorePointsLbl]-0-|", options: [], metrics: nil, views: views)
        bestScoreConstraints = bestScoreConstraints + NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[bestScoreLbl(18)]-0-[bestScorePointsLbl]", options: [], metrics: nil, views: views)
        bestScoreView.addConstraints(bestScoreConstraints)
        
    }
    
    fileprivate func getPosition() -> Int{
        
        var slots: Array<Int> = Array<Int>()
        
        for i in 0...15{
            if chipsInGame[i] is Int {
                slots.append(i)
            }
        }
        
        let randomNum:Int = Int(arc4random_uniform(UInt32(slots.count)))
        
        return slots[randomNum]
    }
    
    fileprivate func setTableSpaces(with isLandscape:Bool){
        //** SET CHIP POSITIONS **//
        let surface = isLandscape ? pow(Double(self.view.frame.height - 40), 2.0) : pow(Double(self.view.frame.width - 40), 2.0)
        
        let marginSurface = surface * 0.47
        
        let chipSurface = surface - marginSurface
        
        let chipWidth = sqrt(chipSurface / 16)
        
        let chipMargin = sqrt(marginSurface) / 13
        
        let marginY = chipMargin
        let marginX = chipMargin
        
        var metrics = ["marginY":marginY,"marginX":marginX,"chipWidth":chipWidth]
        
        for i in 1...16{
            let chipPosition = UIView()
            chipPosition.translatesAutoresizingMaskIntoConstraints = false
            chipPosition.backgroundColor = UIColor.colorWithHex(hex: "#CDC1B4", alpha: 1)
            chipPosition.layer.cornerRadius = 7
            tableroView.addSubview(chipPosition)
            
            chipsPositions.append(CGRect(x: metrics["marginX"]!, y: metrics["marginY"]!, width: chipWidth, height: chipWidth))
            
            var constraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(marginX)-[chipPosition(chipWidth)]", options: [], metrics: metrics, views: ["chipPosition":chipPosition])
            constraints = constraints + NSLayoutConstraint.constraints(withVisualFormat: "V:|-(marginY)-[chipPosition(chipWidth)]", options: [], metrics: metrics, views: ["chipPosition":chipPosition])
            
            tableroView.addConstraints(constraints)
            
            if i % 4 != 0{
                metrics["marginX"] = (marginX + chipWidth) * Double( i % 4 ) + chipMargin
            }else{
                metrics["marginX"] = marginX
                metrics["marginY"] = (marginY + chipWidth) * Double( i/4 ) + chipMargin
            }
            
        }
    }
    
    func addNewChip() -> Void{
        let position = getPosition()
        let random = Int(arc4random_uniform(UInt32(100)))
        let number = random < 75 ? 2 : 4
        let newChip = Chip(framePosition: self.chipsPositions[position], number: number, position: position)
        tableroView.addSubview(newChip)
        self.chipsInGame[position] = newChip
    }
    
    @objc fileprivate func swipeAction(_ sender:UISwipeGestureRecognizer) -> Void{
        
        if gameWon { return }
        
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.down:
            gameLogic(with: DIRECTION_DOWN)
            break
        case UISwipeGestureRecognizerDirection.up:
            gameLogic(with: DIRECTION_UP)
            break
        case UISwipeGestureRecognizerDirection.left:
            gameLogic(with: DIRECTION_LEFT)
            break
        case UISwipeGestureRecognizerDirection.right:
            gameLogic(with: DIRECTION_RIGHT)
            break
            
        default: break
        }
    }
    
    func gameLogic(with direction:[Int]){

        var scorePoints = 0
        var lastPosition = -1
        var lastChip : Chip? = nil
        var movement = false
        
        for i in 0...15 {
            
            var sum = false
            
            //True index
            let e = direction[i]
            
            //Get the chip for actual position
            let obj = self.chipsInGame[e]
            let actualChip : Chip? = obj is Chip ? obj as? Chip : nil
            
            if(actualChip == nil && lastPosition == -1){
                lastPosition = e;
            }
            
            if actualChip != nil && lastChip?.chipNumber == actualChip?.chipNumber {
                
                sum = true
                movement = true
                
                let moveTo = lastChip?.chipPosition
                
                //Animation
                tableroView.bringSubview(toFront: lastChip!)
                lastChip?.moveChipToPosition(self.chipsPositions[moveTo!], number: (lastChip?.chipNumber)! * 2)
                actualChip?.moveChipToPosition(self.chipsPositions[moveTo!], disappear: true)
                
                //Set matrix
                self.chipsInGame[moveTo!] = lastChip!
                if moveTo! == lastPosition { self.chipsInGame[(lastChip?.chipPosition)!] = 0 }
                lastChip?.chipPosition = moveTo!
                self.chipsInGame[(actualChip?.chipPosition)!] = 0
                
                //Set last position
                lastPosition = direction[direction.index(of: moveTo!)! + 1]
                
                scorePoints = scorePoints + (lastChip?.chipNumber)! * 2
                
                lastChip = nil
                
                if (actualChip?.chipNumber)! * 2 == 2048 { self.gameWon = true }
                
            }else if actualChip != nil && lastPosition != -1 {
                
                //Move only one chip
                movement = true
                
                //Animation
                actualChip?.moveChipToPosition(chipsPositions[lastPosition], disappear: false)
                actualChip?.chipPosition = lastPosition
                
                //Set matrix
                self.chipsInGame[lastPosition] = actualChip!
                self.chipsInGame[e] = 0
                
                //Set last position
                lastPosition = direction[direction.index(of: lastPosition)! + 1]
                
            }
            
            if( (i + 1) % 4 == 0){
                lastChip = nil;
                lastPosition = -1;
            }else if(actualChip != nil && !sum){
                lastChip = actualChip;
            }
            
        }
        
        self.score = self.score + scorePoints
        
        if self.gameWon { return }
        
        if movement { addNewChip() }
        
    }
    
    @objc func reset(){
        score = 0
        
        for i in 0...15 {
            let obj = self.chipsInGame[i]
            if obj is Chip {
                let chip : Chip = (obj as? Chip)!
                chip.removeFromSuperview()
                self.chipsInGame[i] = 0
            }
        }
        
        addNewChip()
        addNewChip()
        
    }
    
}

