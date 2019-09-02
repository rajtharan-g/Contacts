//
//  EditContactViewController.swift
//  Contacts
//
//  Created by Rajtharan G on 18/08/19.
//  Copyright © 2019 Rajtharan G. All rights reserved.
//

import UIKit
import Photos

enum AttachmentType: String {
    case camera = "Camera", photoLibrary = "Gallery"
}

enum EditContactType {
    case update, create
}

class EditContactViewController: UIViewController {

    @IBOutlet weak var contactView: GradientView!
    @IBOutlet weak var contactImageView: CircularBorderedImageView!
    @IBOutlet weak var uploadImageButton: UIButton!
    @IBOutlet weak var firstNameLabel: CustomGrayLabel!
    @IBOutlet weak var firstNameTextField: CustomBlackTextField!
    @IBOutlet weak var lastNameLabel: CustomGrayLabel!
    @IBOutlet weak var lastNameTextField: CustomBlackTextField!
    @IBOutlet weak var mobileLabel: CustomGrayLabel!
    @IBOutlet weak var mobileTextField: CustomBlackTextField!
    @IBOutlet weak var emailLabel: CustomGrayLabel!
    @IBOutlet weak var emailTextField: CustomBlackTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    static let identifier = "EditContactVC"
    
    var contactDetail: ContactDetail?
    var type: EditContactType?
    var activeField: UITextField?
    var imageUpdated: Bool = false
    
    // MARK: - View life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyUICustomization()
        applyContactDetails(contactDetail: contactDetail)
    }
    
    override func viewWillAppear(_ animated:Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    // MARK: - IBAction methods
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        updateOrCreateContact()
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        displayImageOptionsActionSheet(sender: sender)
    }
    
    // MARK: - Custom methods
    
    func updateOrCreateContact() {
        if type == .update {
            updateContact()
        } else {
            createContact()
        }
    }
    
    func createContact() {
        showSpinner(onView: self.view)
        ContactsManager.shared.createContactDetail(json: contactProperties()) { (contactDetail, error, validationError)  in
            DispatchQueue.main.async {
                self.removeSpinner()
                self.contactDetail = contactDetail
                if let validationError = validationError {
                    let alert = UIAlertController(title: nil, message: validationError.errors?.first, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: Constants.okBtnTitle, style: .default, handler: nil))
                    self.present(alert, animated: true)
                } else {
                    self.applyContactDetails(contactDetail: contactDetail)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func updateContact() {
        guard let contact = contactDetail else { return }
        showSpinner(onView: self.view)
        let manager = ContactUpdateManager()
        manager.updateContactDetail(contact: contact, json: contactProperties() as [String : Any]) { (contactDetail, error) in
            DispatchQueue.main.async {
                self.removeSpinner()
                self.contactDetail = contactDetail
                self.applyContactDetails(contactDetail: contactDetail)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func displayImageOptionsActionSheet(sender: UIButton) {
        let alertController = UIAlertController(title: Constants.actionFileTypeTitle, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: AttachmentType.camera.rawValue, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .camera, vc: self)
        }))
        alertController.addAction(UIAlertAction(title: AttachmentType.photoLibrary.rawValue, style: .default, handler: { (action) -> Void in
            self.authorisationStatus(attachmentTypeEnum: .photoLibrary, vc: self)
        }))
        alertController.addAction(UIAlertAction(title: Constants.cancelBtnTitle, style: .cancel, handler: nil))
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = alertController.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
            }
        }
        present(alertController, animated: true, completion: nil)
    }
    
    func authorisationStatus(attachmentTypeEnum: AttachmentType, vc: UIViewController) {
        if attachmentTypeEnum ==  AttachmentType.camera {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status{
            case .authorized: // The user has previously granted access to the camera.
                self.openCamera()
                
            case .notDetermined: // The user has not yet been asked for camera access.
                AVCaptureDevice.requestAccess(for: .video) { granted in
                    if granted {
                        self.openCamera()
                    }
                }
                //denied - The user has previously denied access.
            //restricted - The user can't grant access due to restrictions.
            case .denied, .restricted:
                self.addAlertForSettings()
                return
                
            default:
                break
            }
        } else if attachmentTypeEnum == AttachmentType.photoLibrary {
            let status = PHPhotoLibrary.authorizationStatus()
            switch status{
            case .authorized:
                if attachmentTypeEnum == AttachmentType.photoLibrary {
                    self.openPhotoLibrary()
                }
            case .denied, .restricted:
                self.addAlertForSettings()
            case .notDetermined:
                PHPhotoLibrary.requestAuthorization({ (status) in
                    if status == PHAuthorizationStatus.authorized{
                        // photo library access given
                        self.openPhotoLibrary()
                    }
                })
            default:
                break
            }
        }
    }
    
    func addAlertForSettings() {
        let alert = UIAlertController(title: nil, message: Constants.alertForPermission, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.okBtnTitle, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // MARK: - Custom methods
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            myPickerController.allowsEditing = true
            present(myPickerController, animated: true, completion: nil)
        }
    }
    
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
        
        // Setup XCUITest Accessibility identifer
        firstNameLabel.accessibilityIdentifier = "firstNameLabel"
        lastNameLabel.accessibilityIdentifier = "lastNameLabel"
        mobileLabel.accessibilityIdentifier = "mobileLabel"
        emailLabel.accessibilityIdentifier = "emailLabel"
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
    
    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let kbSize = keyboardValue.cgRectValue.size
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        var aRect: CGRect = self.view.frame
        aRect.size.height -= kbSize.height
        if let activeField = activeField, !aRect.contains(activeField.frame.origin) {
            self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
        }
    }

}

// MARK: - EditContactViewController delegate methods

extension EditContactViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            updateOrCreateContact()
            textField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
}

// MARK: - UIImagePickerControllerDelegate methods

extension EditContactViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            contactImageView.image = image
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            contactImageView.image = image
        }
        imageUpdated = true
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension EditContactViewController: UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate methods
    
}
