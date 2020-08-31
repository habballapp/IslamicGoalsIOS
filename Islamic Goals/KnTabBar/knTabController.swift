////
////  knTabController.swift
////  Islamic Goals
////
////  Created by Mehdi Raza Rajani on 04/12/2019.
////  Copyright © 2019 Matz. All rights reserved.
////
//
//import UIKit
//
//class knTabController: UITabBarController {
//    var kn_tabBar: knTabBar!
//    var selectedColor = UIColor.darkGray
//    var normalColor = UIColor.lightGray {
//        didSet {
//            kn_tabBar.tintColor = normalColor
//        }}
//    
//    private var kn_tabBarHeight: CGFloat = 49
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tabBar.isHidden = true
//        setupView()
//    }
//
//    func setupView() {}
//    
//    func setTabBar(items: [knTabBarItem], height: CGFloat = 49) {
//        guard items.count > 0 else { return }
//        
//        kn_tabBar = knTabBar(items: items)
//        guard let bar = kn_tabBar else { return }
//        kn_tabBar.tintColor = normalColor
//        bar.kn_items.first?.color = selectedColor
//        
//        view.addSubviews(views: bar)
//        bar.horizontal(toView: view)
//        bar.bottom(toView: view)
//        kn_tabBarHeight = height
//        bar.height(kn_tabBarHeight)
//        for i in 0 ..< items.count {
//            items[i].tag = i
//            items[i].addTarget(self, action: #selector(switchTab), for: .touchUpInside)
//        }
//    }
//    
//    @objc func switchTab(button: UIButton) {
//        let newIndex = button.tag
//        changeTab(from: selectedIndex, to: newIndex)
//    }
//    
//    private func changeTab(from fromIndex: Int, to toIndex: Int) {
//        kn_tabBar.kn_items[fromIndex].color = normalColor
//        kn_tabBar.kn_items[toIndex].color = selectedColor
//        animateSliding(from: fromIndex, to: toIndex)
//    }
//}
//
//extension knTabController {
//
//    func animateSliding(from fromIndex: Int, to toIndex: Int) {
//        guard fromIndex != toIndex else { return }
//        guard let fromController = viewControllers?[fromIndex], let toController = viewControllers?[toIndex] else { return }
//        let fromView = fromController.view!
//        let toView = toController.view!
//        let viewSize = fromView.frame
//        let scrollRight = fromIndex < toIndex
//        fromView.superview?.addSubview(toView)
//        toView.frame = CGRect(x: scrollRight ? screenWidth : -screenWidth,
//                              y: viewSize.origin.y,
//                              width: screenWidth,
//                              height: viewSize.height)
//        
//        func animate() {
//            fromView.frame = CGRect(x: scrollRight ? -screenWidth : screenWidth,
//                                    y: viewSize.origin.y,
//                                    width: screenWidth,
//                                    height: viewSize.height)
//            toView.frame = CGRect(x: 0,
//                                  y: viewSize.origin.y,
//                                  width: screenWidth,
//                                  height: viewSize.height)
//        }
//        
//        func finished(_ completed: Bool) {
//            fromView.removeFromSuperview()
//            selectedIndex = toIndex
//        }
//        
//        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseInOut,
//                       animations: animate, completion: finished)
//    }
//}
