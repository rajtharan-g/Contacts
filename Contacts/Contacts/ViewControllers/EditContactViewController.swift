//
//  EditContactViewController.swift
//  Contacts
//
//  Created by Rajtharan G on 18/08/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit

class EditContactViewController: UIViewController {

    @IBOutlet weak var contactView: UIView!
    @IBOutlet weak var contactImageView: UIImageView!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var contactDetail: ContactDetail?
    var activeField: UITextField?
    
    // MARK: - View life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyUICustomization()
        applyContactDetails(contactDetail: contactDetail)
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeHidden(aNotification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(aNotification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    // MARK: - IBAction methods
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        ContactsManager.shared.updateContactDetail(contactDetail: contactDetail, json: contactProperties()) { (contactDetail, error) in
            DispatchQueue.main.async {
                self.contactDetail = contactDetail
                self.applyContactDetails(contactDetail: contactDetail)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Custom methods
    
    func contactProperties() -> [String: String?] {
        return ["first_name": firstNameTextField.text, "last_name": lastNameTextField.text, "phone_number": mobileTextField.text, "email": emailTextField.text]
    }
    
    func applyUICustomization() {
        
        // Color
        navigationItem.leftBarButtonItem?.applyTintColor(color: UIColor.menuGreenColor())
        navigationItem.rightBarButtonItem?.applyTintColor(color: UIColor.menuGreenColor())
        
        // Text
        firstNameLabel.text = "First Name"
        lastNameLabel.text = "Last Name"
        mobileLabel.text = "mobile"
        emailLabel.text = "email"
    }
    
    func applyContactDetails(contactDetail: ContactDetail?) {
        firstNameTextField.text = contactDetail?.firstName
        lastNameTextField.text = contactDetail?.lastName
        mobileTextField.text = contactDetail?.phone
        emailTextField.text = contactDetail?.email
    }
    
    @objc func keyboardWillBeHidden(aNotification: NSNotification) {
        let contentInsets: UIEdgeInsets = .zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillShow(aNotification: NSNotification) {
        var info = aNotification.userInfo!
        let kbSize: CGSize = ((info["UIKeyboardFrameEndUserInfoKey"] as? CGRect)?.size)!
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        var aRect: CGRect = self.view.frame
        aRect.size.height -= kbSize.height
        if !aRect.contains(activeField!.frame.origin) {
            self.scrollView.scrollRectToVisible(activeField!.frame, animated: true)
        }
    }

}

extension EditContactViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
}
