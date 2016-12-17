//
//  ViewController.swift
//  2048
//
//  Created by Alvaro Royo on 16/12/16.
//  Copyright © 2016 Alvaro Royo. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    //Views:
    var views : [String:UIView]!
    
    var scoreView : UIView!
    var bestScoreView : UIView!
    var tableroView : UIView!
    var resetBtn : UIButton!
    
    var chipsPositions = Array<UIView>()
    var chipsInGame = Array<Chip>()
    
    override func loadView() {
        self.view = UIView(frame: UIScreen.main.bounds)
        self.view.backgroundColor = UIColor.colorWithHex(hex: "#FAF8EF", alpha: 1)
        
        scoreView = UIView()
        scoreView.layer.cornerRadius = 7
        scoreView.backgroundColor = UIColor.colorWithHex(hex: "#BBADA0", alpha: 1)
        scoreView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(scoreView)
        
        bestScoreView = UIView()
        bestScoreView.layer.cornerRadius = 7
        bestScoreView.backgroundColor = UIColor.colorWithHex(hex: "#BBADA0", alpha: 1)
        bestScoreView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(bestScoreView)
        
        tableroView = UIView()
        tableroView.clipsToBounds = true
        tableroView.layer.cornerRadius = 7
        tableroView.backgroundColor = UIColor.colorWithHex(hex: "#BBADA0", alpha: 1)
        tableroView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableroView)
        
        resetBtn = UIButton()
        resetBtn.setBackgroundImage(UIImage.imageWithColor(color: UIColor.colorWithHex(hex: "#EF5350", alpha: 1)), for: .normal)
        resetBtn.setTitle("Reset", for: .normal)
        resetBtn.setTitleColor(UIColor.white, for: .normal)
        resetBtn.layer.cornerRadius = 7
        resetBtn.clipsToBounds = true
        resetBtn.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(resetBtn)
        
        views = ["scoreView":scoreView,"bestScoreView":bestScoreView,"tableroView":tableroView,"resetBtn":resetBtn]
        
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
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        setConstraints(with: nil)
    }
    
    func setConstraints(with isLandscape:Bool?){
        
        var constraints : Array<NSLayoutConstraint>!
        
        self.view.removeConstraints(self.view.constraints)
        
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
        
    }
    
    func setTableSpaces(with isLandscape:Bool){
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
            
            chipsPositions.append(chipPosition)
            
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
    
    fileprivate func getPosition() -> Int{
        
        var slots: Array<Int> = Array<Int>()
        
        for i in 0...15{
            if self.chipsInGame[i].chipNumber == 0 {
                slots.append(i)
            }
        }
        
        let random = Int(arc4random()) % slots.count
        
        return slots[random]
    }
    
    func addNewChip() -> Void{
//        let position = getPosition()
//        let random = Int(arc4random()) % 100
//        let newChip: Chip = Chip(view: self.chipsPositions[position], number: random < 75 ? 2 : 4, position: position)
//        self.addSubview(newChip)
//        self.chipsInGame[position] = newChip
    }
    
    @objc fileprivate func swipeAction(_ sender:UISwipeGestureRecognizer) -> Void{
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.down:
            print("Down")
//            gameLogic(DOWN_MOVE)
            break
        case UISwipeGestureRecognizerDirection.up:
            print("Up")
//            gameLogic(UP_MOVE)
            break
        case UISwipeGestureRecognizerDirection.left:
            print("Left")
//            gameLogic(LEFT_MOVE)
            break
        case UISwipeGestureRecognizerDirection.right:
            print("Right")
//            gameLogic(RIGHT_MOVE)
            break
            
        default: break
        }
    }
    
}

