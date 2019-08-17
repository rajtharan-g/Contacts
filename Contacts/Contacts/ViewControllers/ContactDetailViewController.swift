//
//  ContactDetailViewController.swift
//  Contacts
//
//  Created by Rajtharan G on 17/08/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit
import MessageUI

class ContactDetailViewController: UIViewController {

    @IBOutlet weak var contactDetailView: UIView!
    @IBOutlet weak var contactImageView: CircularBorderedImageView!
    @IBOutlet weak var contactNameLabel: UILabel!
    @IBOutlet weak var messageActionView: ContactActionView!
    @IBOutlet weak var callActionView: ContactActionView!
    @IBOutlet weak var emailActionView: ContactActionView!
    @IBOutlet weak var favoriteActionView: ContactActionView!
    @IBOutlet weak var mobileTextLabel: UILabel!
    @IBOutlet weak var emailTextLabel: UILabel!
    @IBOutlet weak var mobileValueLabel: UILabel!
    @IBOutlet weak var emailValueLabel: UILabel!
    
    var contact: Contact!
    var contactDetail: ContactDetail?
    var gradientLayer: CAGradientLayer?
    
    // MARK: - View life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyUICustomization()
        setDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ContactsManager.shared.fetchContactDetail(contact: contact) { (contactDetail, error) in
            DispatchQueue.main.async {
                self.contactDetail = contactDetail
                self.applyContactDetails(contactDetail: contactDetail)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer?.frame = contactDetailView.bounds
    }
    
    // MARK: - Custom methods
    
    func applyContactDetails(contactDetail: ContactDetail?) {
        contactImageView.load(urlString: contactDetail?.contactImage)
        contactNameLabel.text = contactDetail?.fullName()
        mobileValueLabel.text = contactDetail?.phone
        emailValueLabel.text = contactDetail?.email
    }
    
    func applyGradient() {
        gradientLayer = CAGradientLayer()
        gradientLayer?.frame = contactDetailView.bounds
        gradientLayer?.colors = [UIColor.white.cgColor, UIColor.menuGreenColor(alpha: 0.28).cgColor]
        gradientLayer?.opacity = 0.55
        if let topLayer = contactDetailView.layer.sublayers?.first, topLayer is CAGradientLayer {
            topLayer.removeFromSuperlayer()
        }
        if let gradientLayer = gradientLayer {
            contactDetailView.layer.addSublayer(gradientLayer)
        }
    }
    
    func applyUICustomization() {
        
        // Color
        mobileTextLabel.textColor = UIColor.appBlackColor(alpha: 0.5)
        emailTextLabel.textColor = UIColor.appBlackColor(alpha: 0.5)
        mobileValueLabel.textColor = UIColor.appBlackColor()
        emailValueLabel.textColor = UIColor.appBlackColor()
        navigationItem.rightBarButtonItem?.applyTintColor(color: UIColor.menuGreenColor())
        navigationController?.navigationBar.tintColor = UIColor.menuGreenColor()
        
        // Font
        mobileTextLabel.font = UIFont.systemFont(ofSize: 16.0)
        emailTextLabel.font = UIFont.systemFont(ofSize: 16.0)
        mobileValueLabel.font = UIFont.systemFont(ofSize: 16.0)
        emailValueLabel.font = UIFont.systemFont(ofSize: 16.0)
        contactNameLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
        
        // Text
        mobileTextLabel.text = "mobile"
        emailTextLabel.text = "email"
        
        // UI
        messageActionView.updateView(actionType: .message)
        callActionView.updateView(actionType: .call)
        emailActionView.updateView(actionType: .email)
        favoriteActionView.updateView(actionType: .favourite)
        applyGradient()
    }
    
    func setDelegate() {
        messageActionView.delegate = self
        callActionView.delegate = self
        emailActionView.delegate = self
        favoriteActionView.delegate = self
    }

}

// MARK: - ContactActionViewDelegate delegate methods

extension ContactDetailViewController: ContactActionViewDelegate {
    
    func messageActionPressed() {
        if MFMessageComposeViewController.canSendText() {
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            composeVC.recipients = [contactDetail?.phone ?? ""]
            present(composeVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: nil, message: "It's not possible to send messages", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
        
    }
    
    func callActionPressed() {
        if let url = URL(string: "tel://\(contactDetail?.phone ?? "")"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let alert = UIAlertController(title: nil, message: "It's not possible to call this number", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func emailActionPressed() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposer = MFMailComposeViewController()
            mailComposer.setToRecipients([contactDetail?.email ?? ""])
            mailComposer.mailComposeDelegate = self
            present(mailComposer, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: nil, message: "It's not possible to send mail", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
    
    func favouriteActionPressed() {
        
    }

}

// MARK: - MFMessageComposeViewControllerDelegate methods

extension ContactDetailViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }

}

// MARK: - MFMailComposeViewControllerDelegate methods

extension ContactDetailViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
