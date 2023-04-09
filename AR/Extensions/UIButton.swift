//
//  UIButton.swift
//  AR
//
//  Created by Krishna Venkatramani on 09/04/2023.
//

import Foundation
import UIKit

typealias Callback = () -> Void

//MARK: - Button Handler
extension UIButton {
    static var buttonHandlerKey: UInt8 = 1
    
    var buttonHandler: Callback? {
        get { objc_getAssociatedObject(self, &Self.buttonHandlerKey) as? Callback }
        set { objc_setAssociatedObject(self, &Self.buttonHandlerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func addTapGesture(_ callback: Callback? = nil) {
        buttonHandler = callback
        addTarget(self, action: #selector(tapRecognizer), for: .touchUpInside)
    }
    
    @objc
    private func tapRecognizer() {
        buttonHandler?()
    }
}

//MARK: - Button Builder
extension UIButton {
    
    static func buildGenericButton(title: String, color: UIColor, callback: Callback? = nil) -> UIButton {
        let button = UIButton()
        button.backgroundColor = color
        button.setTitle(title, for: .normal)
        button.setFrame(.init(width: 100, height: 50))
        button.layer.cornerRadius = 12.5
        button.addTapGesture(callback)
        return button
    }
}
