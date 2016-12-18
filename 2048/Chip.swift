//
//  Chip.swift
//  2048_Game_Swift
//
//  Created by Alvaro Royo on 23/7/16.
//  Copyright © 2016 alvaroroyo. All rights reserved.
//

import Foundation
import UIKit

class Chip: UIView{
    
    fileprivate let CHIP_COLORS: [Int:String] = [2:"#EEE4DA",4:"#EDE0C8",8:"#F2B179",16:"#F59563",32:"#F67C5F",64:"#EB423F",128:"#F5D077",256:"#F3C62B",512:"#74B5DD",1024:"#5DA1E2",2048:"#007FC2"]
    
    fileprivate let APPEAR_ANIMATION_DELAY = 0.3
    fileprivate let TRANSLATE_ANIMATION_DELAY = 0.3
    
    fileprivate var numberLabel: UILabel!
    
    fileprivate var _chipNumber: Int = 0
    fileprivate(set) var chipNumber: Int {
        get{
            return self._chipNumber
        }
        set{
            _chipNumber = newValue
            if newValue > 0{
                self.backgroundColor = UIColor.colorWithHex(hex: CHIP_COLORS[newValue]!, alpha: 1)
                self.numberLabel.textColor = self.chipNumber == 2 || self.chipNumber == 4 ? UIColor.colorWithHex(hex: "#776E65", alpha: 1) : UIColor.colorWithHex(hex: "#ffffff", alpha: 1)
                self.numberLabel.text = newValue.description
            }
        }
    }
    var chipPosition: Int = -1
    
    var positionFrame : CGRect!
    
    init(framePosition: CGRect, number: Int, position: Int){
        super.init(frame: CGRect(x: framePosition.minX, y: framePosition.minY, width: framePosition.width, height: framePosition.width))
        self._chipNumber = number
        self.chipPosition = position
        self.positionFrame = framePosition
        

        self.backgroundColor = UIColor.colorWithHex(hex: CHIP_COLORS[self.chipNumber]! , alpha: 1)
        self.layer.cornerRadius = 7
        
        self.numberLabel = UILabel(frame: CGRect(x: 0, y: 0, width: framePosition.width, height: framePosition.height))
        self.numberLabel.textColor = self.chipNumber == 2 || self.chipNumber == 4 ? UIColor.colorWithHex(hex: "#776E65", alpha: 1) : UIColor.colorWithHex(hex: "#ffffff", alpha: 1)
        self.numberLabel.font = UIFont(name: "PingFangHK-Medium", size: 23)
        self.numberLabel.textAlignment = .center
        self.numberLabel.text = number.description
        self.addSubview(self.numberLabel)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        UIView.animate(withDuration: APPEAR_ANIMATION_DELAY, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //** CLASS FUNCTIONS **//
    
    func moveChipToPosition(_ position:CGRect, number:Int) -> Void{
        UIView.animate(withDuration: TRANSLATE_ANIMATION_DELAY, animations: { 
                self.frame = position
            }, completion: { (true) in
                self.chipNumber = number
        }) 
    }
    
    func moveChipToPosition(_ position:CGRect, disappear:Bool) -> Void{
        UIView.animate(withDuration: TRANSLATE_ANIMATION_DELAY, animations: { 
                self.frame = position
            }, completion: { (true) in
                if disappear { self.removeFromSuperview() }
        }) 
    }
    
}
