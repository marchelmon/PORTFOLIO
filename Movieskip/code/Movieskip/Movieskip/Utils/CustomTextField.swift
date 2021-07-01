//
//  CustomTextField.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-25.
//

import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String, secureText: Bool = false) {
        super.init(frame: .zero)
                
        let spacer = UIView()
        spacer.setDimensions(height: 40, width: 12)
        leftView = spacer
        leftViewMode = .always
        
        backgroundColor = UIColor(white: 1, alpha: 1)
        textColor = .black
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        layer.cornerRadius = 7
        self.placeholder = placeholder
        isSecureTextEntry = secureText
        keyboardAppearance = .light
        autocorrectionType = .no
        autocapitalizationType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
