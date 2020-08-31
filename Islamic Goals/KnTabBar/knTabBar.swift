////
////  knTabBar.swift
////  Islamic Goals
////
////  Created by Mehdi Raza Rajani on 04/12/2019.
////  Copyright © 2019 Matz. All rights reserved.
////
//
//import UIKit
//
//class knTabBar: UITabBar {
//
//    /*
//    // Only override draw() if you perform custom drawing.
//    // An empty implementation adversely affects performance during animation.
//    override func draw(_ rect: CGRect) {
//        // Drawing code
//    }
//    */
//    var kn_items = [knTabBarItem]()
//    convenience init(items: [knTabBarItem]) {
//        self.init()
//        kn_items = items
//        translatesAutoresizingMaskIntoConstraints = false
//        setupView()
//    }
//    
//    override var tintColor: UIColor! {
//        didSet {
//            for item in kn_items {
//                item.color = tintColor
//            }}}
//    
//    func setupView() {
//        backgroundColor = .white
//        if kn_items.count == 0 { return }
//        
//        let line = UIView()
//        line.translatesAutoresizingMaskIntoConstraints = false
//        line.backgroundColor = .gray
//        line.height(1)
//        
//        addSubviews(views: line)
//        line.horizontal(toView: self)
//        line.top(toView: self)
//        
//        var horizontalConstraints = "H:|"
//        let itemWidth: CGFloat = screenWidth / CGFloat(kn_items.count)
//        for i in 0 ..< kn_items.count {
//            let item = kn_items[i]
//            addSubviews(views: item)
//            if item.itemHeight == 0 {
//                item.vertical(toView: self)
//            }
//            else {
//                item.bottom(toView: self)
//                item.height(item.itemHeight)
//            }
//            item.width(itemWidth)
//            horizontalConstraints += String(format: "[v%d]", i)
//            if item.lock == false {
//                item.color = tintColor
//            }
//        }
//        
//        horizontalConstraints += "|"
//        addConstraints(withFormat: horizontalConstraints, arrayOf: kn_items)
//    }
//    
//}
