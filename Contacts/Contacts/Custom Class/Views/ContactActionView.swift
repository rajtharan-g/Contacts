//
//  ContactActionView.swift
//  Contacts
//
//  Created by Rajtharan G on 17/08/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

protocol ContactActionViewDelegate: class {
    func messageActionPressed()
    func callActionPressed()
    func emailActionPressed()
    func favouriteActionPressed()
}

public enum ContactActionType: String {
    case message, call, email, favourite
}

class ContactActionView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var actionLabel: UILabel!
    
    var type: ContactActionType?
    weak var delegate: ContactActionViewDelegate?
    
    // MARK: - Init methods
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
        applyUICustomization()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        applyUICustomization()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("ContactAction", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    // MARK: - IBAction methods
    
    @IBAction func buttonActionPressed(_ sender: UIButton) {
        if let delegate = delegate, let type = type {
            switch type {
            case .message:
                delegate.messageActionPressed()
                break
            case .call:
                delegate.callActionPressed()
                break
            case .email:
                delegate.emailActionPressed()
                break
            case .favourite:
                delegate.favouriteActionPressed()
                break
            }
        }
    }
    
    // MARK: - Custom methods
    
    func updateView(actionType: ContactActionType, contactDetail: ContactDetail?) {
        self.type = actionType
        updateButtonImage(actionType: actionType, contactDetail: contactDetail)
        updateActionText(actionType: actionType, contactDetail: contactDetail)
    }

    func updateActionText(actionType: ContactActionType, contactDetail: ContactDetail?) {
        switch actionType {
        case .message:
            actionLabel.text = "message"
            break
        case .call:
            actionLabel.text = "call"
            break
        case .email:
            actionLabel.text = "email"
            break
        case .favourite:
            actionLabel.text = contactDetail?.isFavourite ?? false ? "unfavourite" : "favourite"
            break
        }
    }
    
    func updateButtonImage(actionType: ContactActionType, contactDetail: ContactDetail?) {
        switch actionType {
        case .message:
            actionButton.setImage(UIImage(named: "message_button"), for: .normal)
            break
        case .call:
            actionButton.setImage(UIImage(named: "call_button"), for: .normal)
            break
        case .email:
            actionButton.setImage(UIImage(named: "email_button"), for: .normal)
            break
        case .favourite:
            contactDetail?.isFavourite ?? false ? actionButton.setImage(UIImage(named: "favourite_button_selected"), for: .normal) : actionButton.setImage(UIImage(named: "favourite_button"), for: .normal)
            break
        }
    }
    
    func applyUICustomization() {
        
        // Color
        actionLabel.textColor = UIColor.appBlackColor()
        
        // Font
        actionLabel.font = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        
        // UI
        actionButton.rounded()
    }
    
}
