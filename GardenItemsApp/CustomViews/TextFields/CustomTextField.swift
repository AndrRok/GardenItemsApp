//
//  CustomTextField.swift
//  GardenItemsApp
//
//  Created by ARMBP on 5/1/23.
//

import UIKit

class CustomTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure(){
        textAlignment               = .center
        layer.cornerRadius          = 15
        backgroundColor             = .systemGray6
        autocorrectionType          = .no
        returnKeyType               = .go
    }
    
    
    //MARK: -  Setting padding for text inside
    
    let paddingText = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50);
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: paddingText)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: paddingText)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: paddingText)
    }
    
    
    //MARK: - For Security text
    override var isSecureTextEntry: Bool {
        didSet {
            if isFirstResponder {
                _ = becomeFirstResponder()
            }
        }
    }
    
    override func becomeFirstResponder() -> Bool {
        let success = super.becomeFirstResponder()
        if isSecureTextEntry, let text = self.text {
            self.text?.removeAll()
            insertText(text)
        }
        return success
    }
}



