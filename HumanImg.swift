//
//  HumanImg.swift
//  gigaPet
//
//  Created by Evgeny Vlasov on 8/25/16.
//  Copyright © 2016 Evgeny Vlasov. All rights reserved.
//

import Foundation
import UIKit

class HumanImg: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        playIdleAnimation()
    }
    
    func playIdleAnimation() {
        self.image = UIImage(named: "i1.png")
        self.animationImages = nil
        
        
        var imgArray = [UIImage] ()
        for var x = 1; x <= 4; x++ {
            let img = UIImage(named: "i\(x).png")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 0
        self.startAnimating()
    }
    
    func playDeathAnimation() {
        
        self.image = UIImage(named: "d4.png")
        self.animationImages = nil
        
        var imgArray = [UIImage] ()
        for var x = 1; x <= 5; x++ {
            let img = UIImage(named: "d\(x).png")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 0.8
        self.animationRepeatCount = 1
        self.startAnimating()
    }




}