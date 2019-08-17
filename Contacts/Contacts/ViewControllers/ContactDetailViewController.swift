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

    @IBOutlet weak var messageActionView: ContactActionView!
    @IBOutlet weak var callActionView: ContactActionView!
    @IBOutlet weak var emailActionView: ContactActionView!
    @IBOutlet weak var favoriteActionView: ContactActionView!
    
    var contact: Contact!
    var contactDetail: ContactDetail?
    
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
            }
        }
    }
    
    // MARK: - Custom methods
    
    func applyUICustomization() {
        messageActionView.updateView(actionType: .message)
        callActionView.updateView(actionType: .call)
        emailActionView.updateView(actionType: .email)
        favoriteActionView.updateView(actionType: .favourite)
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
