//
//  ContactViewController.swift
//  My Contact Application2
//
//  Created by Harry Dulaney on 10/23/19.
//

import UIKit
import CoreData

class ContactViewController: UIViewController, UITextFieldDelegate, DateControllerDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    func dateChanged(date: Date) {
        if currentContact != nil {
            currentContact?.birthday = date as NSDate? as Date?
            appDelegate.saveContext()
            
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            lblBirthdate.text = formatter.string(from: date)
        }
    }
   
    
    var currentContact: Contact?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var imgContactPicture: UIImageView!
    @IBOutlet weak var sgmtEditMode: UISegmentedControl!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtCell: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var lblBirthdate: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var txtZip: UITextField!
    
   
    @IBAction func changePicture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraController = UIImagePickerController()
            cameraController.sourceType = .camera
            cameraController.cameraCaptureMode = .photo
            cameraController.delegate = self
            cameraController.allowsEditing = true
            self.present(cameraController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imgContactPicture.contentMode = .scaleAspectFit
            imgContactPicture.image = image
            
            if currentContact == nil {
                let context =
                    appDelegate.persistentContainer.viewContext
                currentContact = Contact(context: context)
            }
            currentContact?.image=NSData(data:
                image.jpegData(compressionQuality: 1.0)!) as Data
        }
        dismiss(animated: true, completion: nil)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
  
        
        if currentContact != nil {
               txtName.text = currentContact!.contactName
               txtAddress.text = currentContact!.streetAddress
               txtCity.text = currentContact!.city
               txtState.text = currentContact!.state
               txtZip.text = currentContact!.zipcode
               txtPhone.text = currentContact!.phoneNumber
               txtCell.text = currentContact!.cellNumber
               txtEmail.text = currentContact!.email
               let formatter = DateFormatter()
               formatter.dateStyle = .short
               if currentContact!.birthday != nil {
                lblBirthdate.text = formatter.string(from: currentContact!.birthday!)
                   
               }
            if let imageData = currentContact?.image {
            imgContactPicture.image = UIImage(data: imageData)
            }
           }
        
           changeEditMode(self)
           
           let textFields: [UITextField] = [txtName, txtAddress, txtCity, txtState, txtZip,
           txtPhone, txtCell, txtEmail]

        for textField in textFields {
            textField.addTarget(self, action: #selector(UITextFieldDelegate.textFieldShouldEndEditing(_:)),
                                for: UIControl.Event.editingDidEnd)
        }
        //let longPress = UILongPressGestureRecognizer.init(target: self,
                                                          //  action: #selector(callPhone(gesture:)))
          //lblPhone.addGestureRecognizer(longPress)
    }
    @objc func callPhone(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let number = txtPhone.text
            if number!.count > 0 {
                let url = NSURL(string: "telprompt://\(number!)")
                UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
                print("Calling Phone Number: \(url!)")
            }
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        currentContact?.contactName = txtName.text
        currentContact?.streetAddress = txtAddress.text
        currentContact?.city = txtCity.text
        currentContact?.state = txtState.text
        currentContact?.zipcode = txtZip.text
        currentContact?.cellNumber = txtCell.text
        currentContact?.phoneNumber = txtPhone.text
        currentContact?.email = txtEmail.text
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func changeEditMode(_ sender: Any) {
        let textFields: [UITextField] = [txtName,txtAddress,txtCity,txtState,txtZip,txtPhone,txtCell,txtEmail]
        if sgmtEditMode.selectedSegmentIndex == 0 {
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = UITextField.BorderStyle.none
            }
            btnChange.isHidden = true
            navigationItem.rightBarButtonItem = nil
        }
        else if sgmtEditMode.selectedSegmentIndex == 1 {
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = UITextField.BorderStyle.roundedRect
            }
            btnChange.isHidden = false;
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save,
            target: self,
            action: #selector(self.saveContact))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
               super.viewWillAppear(animated)
               self.registerKeyboardNotifications()
           }
           
           override func viewWillDisappear(_ animated: Bool) {
               super.viewWillDisappear(animated)
               self.unregisterKeyboardNotifications()
           }
    
    @objc func saveContact() {
        if currentContact == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentContact = Contact(context: context)
        }
        appDelegate.saveContext()
        sgmtEditMode.selectedSegmentIndex = 0
        changeEditMode(self)
        }
    
     func registerKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow(notification:)),
            name: UIResponder.keyboardDidShowNotification, object: nil)
            
            NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
        func unregisterKeyboardNotifications() {
            NotificationCenter.default.removeObserver(self)
        }

    @objc func keyboardDidShow(notification: NSNotification) {
            let userInfo: NSDictionary = notification.userInfo! as NSDictionary
            let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
            let keyboardSize = keyboardInfo.cgRectValue.size
            
            //Get the existing contentInset for the scrollView and set the bottom property to be the height of the keyboard
            var contentInset = self.scrollView.contentInset
            contentInset.bottom = keyboardSize.height
            
            self.scrollView.contentInset = contentInset
            self.scrollView.scrollIndicatorInsets = contentInset
        }
        
        @objc func keyboardWillHide(notification: NSNotification) {
            var contentInset = self.scrollView.contentInset
            contentInset.bottom = 0
            
            self.scrollView.contentInset = contentInset
            self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segueContactDate") {
        let dateController = segue.destination as! DateViewController
        dateController.delegate = self
        }
        }
    }
