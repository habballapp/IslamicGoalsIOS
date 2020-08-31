////
////  knTabBarItem.swift
////  Islamic Goals
////
////  Created by Mehdi Raza Rajani on 04/12/2019.
////  Copyright © 2019 Matz. All rights reserved.
////
//
//import UIKit
//
//class knTabBarItem: UIButton {
//    // (1)
//    var itemHeight: CGFloat = 0
//    // (2)
//    var lock = false
//    // (3)
//    var color: UIColor = UIColor.lightGray {
//        didSet {
//            guard lock == false else { return }
//            iconImageView.tintColor = color
//            textLabel.textColor = color
//        }}
//
//    // (4)
//    private let iconImageView = knUIMaker.makeImageView(contentMode: .scaleAspectFit)
//    private let textLabel = knUIMaker.makeLabel(font: UIFont.systemFont(ofSize: 11),
//                                        color: .black, alignment: .center)
//
//    convenience init(icon: UIImage, title: String,
//                    font: UIFont = UIFont.systemFont(ofSize: 11)) {
//        self.init()
//        translatesAutoresizingMaskIntoConstraints = false
//        iconImageView.image = icon
//        textLabel.text = title
//        textLabel.font = UIFont(name: font.fontName, size: 11)
//        setupView()
//    }
//
//    // (5)
//    private func setupView() {
//        addSubviews(views: iconImageView, textLabel)
//        iconImageView.top(toView: self, space: 0)
//        iconImageView.centerX(toView: self)
//        iconImageView.square()
//
//        let iconBottomConstant: CGFloat = textLabel.text == "" ? -2 : -20
//        iconImageView.bottom(toView: self, space: iconBottomConstant)
//
//        textLabel.bottom(toView: self, space: -2)
//        textLabel.centerX(toView: self)
//    }
//
//}
