//
//  CycleInfoLabel.swift
//  CycleScrollView
//
//  Created by 软件开发部2 on 2017/4/11.
//  Copyright © 2017年 软件开发部2. All rights reserved.
//

import UIKit

class CycleInfoLabel: UILabel {
    
    //MARK: property
    var currentIndex: Int = 0{
        didSet{
            updateInfo()
        }
    }
    var totalCount: Int = 0{
        didSet{
            updateInfo()
        }
    }
    
    //MARK: life cycle
    convenience init(frame: CGRect, currentIndex: Int, totalCount: Int){
        self.init(frame: frame)
        self.currentIndex = currentIndex
        self.totalCount = totalCount
        textAlignment = .center
        self.font = UIFont.systemFont(ofSize: 20)
    }
    
    //MARK: private method
    func updateInfo(){
        let str = "\(currentIndex)/\(totalCount)"
        text = str
        let width = CGFloat(str.characters.count) * font.pointSize * 0.5 + 5
        self.frame.size.width = width
    }
}
