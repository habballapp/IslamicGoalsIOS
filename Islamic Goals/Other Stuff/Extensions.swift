//
//  Extensions.swift
//  Islamic Goals
//
//  Created by Mehdi Raza Rajani on 18/07/2019.
//  Copyright © 2019 Matz. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import JZCalendarWeekView

extension UIViewController {
    
    //close keyboard
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.resignFirstResponder()
        self.view.endEditing(true)
    }
}

extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
//    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.findViewController()?.resignFirstResponder()
//        self.findViewController()?.view.endEditing(true)
//    }
    
    func dropShadow(scale: Bool = true, color: UIColor = .black, opacity: Float = 0.2, shadowRadius: CGFloat = 1) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = .zero
        layer.shadowRadius = shadowRadius
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "HelveticaNeue-Bold", size: 30)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "HelveticaNeue-Medium", size: 30)!]
        let normal = NSMutableAttributedString(string:text, attributes: attrs)
        append(normal)
        
        return self
    }
}

extension String {
    func isValidEmail() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    func isValidPassword() -> Bool {
        
        // at least one digit
        // at least one alphabet
        // 8 characters total
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[0-9])(?=.*[A-Za-z]).{8,}")
        return passwordTest.evaluate(with: self)
    }
    
    func getDigit() -> Int? {
        return Int(self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())
    }
    
    var html2Attributed: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return nil
            }
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            CustomToast.showNegativeMessage(message: error.localizedDescription)
            print("error: ", error)
            return nil
        }
    }
    
    var htmlAttributed: (NSAttributedString?, NSDictionary?) {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return (nil, nil)
            }
            
            var dict:NSDictionary?
            dict = NSMutableDictionary()
            
            return try (NSAttributedString(data: data,
                                           options: [.documentType: NSAttributedString.DocumentType.html,
                                                     .characterEncoding: String.Encoding.utf8.rawValue],
                                           documentAttributes: &dict), dict)
        } catch {
            print("error: ", error)
            CustomToast.showNegativeMessage(message: error.localizedDescription)
            return (nil, nil)
        }
    }
    
    func htmlAttributed(using font: UIFont, color: UIColor) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(font.pointSize)pt !important;" +
                "color: #\(color.hexString!) !important;" +
                "font-family: \(font.familyName), Helvetica !important;" +
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            CustomToast.showNegativeMessage(message: error.localizedDescription)
            return nil
        }
    }
    
    func htmlAttributed(family: String?, size: CGFloat, color: UIColor) -> NSAttributedString? {
        do {
            let htmlCSSString = "<style>" +
                "html *" +
                "{" +
                "font-size: \(size)pt !important;" +
                "color: #\(color.hexString!) !important;" +
                "font-family: \(family ?? "Helvetica"), Helvetica !important;" +
            "}</style> \(self)"
            
            guard let data = htmlCSSString.data(using: String.Encoding.utf8) else {
                return nil
            }
            
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            CustomToast.showNegativeMessage(message: error.localizedDescription)
            return nil
        }
    }
//
//    func sha256() -> String{
//        if let stringData = self.data(using: String.Encoding.utf8) {
//            return hexStringFromData(input: digest(input: stringData as NSData))
//        }
//        return ""
//    }
//
//    private func digest(input : NSData) -> NSData {
//        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
//        var hash = [UInt8](repeating: 0, count: digestLength)
//        CC_SHA256(input.bytes, UInt32(input.length), &hash)
//        return NSData(bytes: hash, length: digestLength)
//    }
//
//    private  func hexStringFromData(input: NSData) -> String {
//        var bytes = [UInt8](repeating: 0, count: input.length)
//        input.getBytes(&bytes, length: input.length)
//
//        var hexString = ""
//        for byte in bytes {
//            hexString += String(format:"%02x", UInt8(byte))
//        }
//
//        return hexString
//    }
//
    func removeSpaces() -> String {
        return self.replacingOccurrences(of: " ", with: "_")
    }
    func addSpaces() -> String {
        return self.replacingOccurrences(of: "_", with: " ")
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
}

extension UIColor {
    var hexString:String? {
        if let components = self.cgColor.components {
            if components.count >= 3 {
                let r = components[0]
                let g = components[1]
                let b = components[2]
                return  String(format: "%02X%02X%02X", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
            } else {
                let b = components[0]
                return  String(format: "%02X%02X%02X", (Int)(b * 255), (Int)(b * 255), (Int)(b * 255))
            }
        }
        return nil
    }
}

func isInternetAvailable() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    return (isReachable && !needsConnection)
}

extension Date {

    func add(component: Calendar.Component, value: Int) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self)!
    }

    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
}

//extension UIColor {
//
//    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
//        self.init(
//            red: CGFloat(red) / 255.0,
//            green: CGFloat(green) / 255.0,
//            blue: CGFloat(blue) / 255.0,
//            alpha: alpha
//        )
//    }
//    // Get UIColor by hex
//    convenience init(hex: Int, alpha: CGFloat = 1.0) {
//        self.init(
//            red: (hex >> 16) & 0xFF,
//            green: (hex >> 8) & 0xFF,
//            blue: hex & 0xFF,
//            alpha: alpha
//        )
//    }
//}

extension NSObject {

    class var className: String {
        return String(describing: self)
    }
}

//extension JZHourGridDivision {
//    var displayText: String {
//        switch self {
//        case .noneDiv: return "No Division"
//        default:
//            return self.rawValue.description + " mins"
//        }
//    }
//}
//
//extension DayOfWeek {
//    var dayName: String {
//        switch self {
//        case .Sunday: return "Sunday"
//        case .Monday: return "Monday"
//        case .Tuesday: return "Tuesday"
//        case .Wednesday: return "Wednesday"
//        case .Thursday: return "Thursday"
//        case .Friday: return "Friday"
//        case .Saturday: return "Saturday"
//        }
//    }
//
//    static var dayOfWeekList: [DayOfWeek] {
//        return [.Sunday, .Monday, .Tuesday, .Wednesday, .Thursday, .Friday, .Saturday]
//    }
//}
//
//extension JZScrollType {
//    var displayText: String {
//        switch self {
//        case .pageScroll:
//            return "Page Scroll"
//        case .sectionScroll:
//            return "Section Scroll"
//        }
//    }
//}

// Anchor Constraints from JZiOSFramework
extension UIView {

    func setAnchorConstraintsEqualTo(widthAnchor: CGFloat?=nil, heightAnchor: CGFloat?=nil, centerXAnchor: NSLayoutXAxisAnchor?=nil, centerYAnchor: NSLayoutYAxisAnchor?=nil) {

        self.translatesAutoresizingMaskIntoConstraints = false

        if let width = widthAnchor {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = heightAnchor {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }

        if let centerX = centerXAnchor {
            self.centerXAnchor.constraint(equalTo: centerX).isActive = true
        }

        if let centerY = centerYAnchor {
            self.centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
    }

    // bottomAnchor & trailingAnchor should be negative
    func setAnchorConstraintsEqualTo(widthAnchor: CGFloat? = nil, heightAnchor: CGFloat? = nil,
                                     topAnchor: (NSLayoutYAxisAnchor, CGFloat)? = nil, bottomAnchor: (NSLayoutYAxisAnchor, CGFloat)? = nil,
                                     leadingAnchor: (NSLayoutXAxisAnchor, CGFloat)? = nil, trailingAnchor: (NSLayoutXAxisAnchor, CGFloat)? = nil) {

        self.translatesAutoresizingMaskIntoConstraints = false

        if let width = widthAnchor {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = heightAnchor {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }

        if let topY = topAnchor {
            self.topAnchor.constraint(equalTo: topY.0, constant: topY.1).isActive = true
        }

        if let botY = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: botY.0, constant: botY.1).isActive = true
        }

        if let leadingX = leadingAnchor {
            self.leadingAnchor.constraint(equalTo: leadingX.0, constant: leadingX.1).isActive = true
        }

        if let trailingX = trailingAnchor {
            self.trailingAnchor.constraint(equalTo: trailingX.0, constant: trailingX.1).isActive = true
        }
    }

    func setAnchorCenterVerticallyTo(view: UIView, widthAnchor: CGFloat?=nil, heightAnchor: CGFloat?=nil, leadingAnchor: (NSLayoutXAxisAnchor, CGFloat)?=nil, trailingAnchor: (NSLayoutXAxisAnchor, CGFloat)?=nil) {
        self.translatesAutoresizingMaskIntoConstraints = false

        setAnchorConstraintsEqualTo(widthAnchor: widthAnchor, heightAnchor: heightAnchor, centerYAnchor: view.centerYAnchor)

        if let leadingX = leadingAnchor {
            self.leadingAnchor.constraint(equalTo: leadingX.0, constant: leadingX.1).isActive = true
        }

        if let trailingX = trailingAnchor {
            self.trailingAnchor.constraint(equalTo: trailingX.0, constant: trailingX.1).isActive = true
        }
    }

    func setAnchorCenterHorizontallyTo(view: UIView, widthAnchor: CGFloat?=nil, heightAnchor: CGFloat?=nil, topAnchor: (NSLayoutYAxisAnchor, CGFloat)?=nil, bottomAnchor: (NSLayoutYAxisAnchor, CGFloat)?=nil) {
        self.translatesAutoresizingMaskIntoConstraints = false

        setAnchorConstraintsEqualTo(widthAnchor: widthAnchor, heightAnchor: heightAnchor, centerXAnchor: view.centerXAnchor)

        if let topY = topAnchor {
            self.topAnchor.constraint(equalTo: topY.0, constant: topY.1).isActive = true
        }

        if let botY = bottomAnchor {
            self.bottomAnchor.constraint(equalTo: botY.0, constant: botY.1).isActive = true
        }
    }

    func setAnchorConstraintsFullSizeTo(view: UIView, padding: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: view.topAnchor, constant: padding).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding).isActive = true
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
    }

    func addSubviews(_ views: [UIView]) {
        views.forEach({ self.addSubview($0)})
    }
}
