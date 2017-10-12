//
//  ContactsViewController.swift
//  unit 4 review
//
//  Created by Brian Licea on 10/12/17.
//  Copyright © 2017 Brian Licea. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let contact = contact {
            self.nameTextField?.text = contact.name
            self.phoneNumberTextField?.text = String(contact.phoneNumber)
            self.emailTextField?.text = contact.email
        }
    }

    var contact: Contact?

    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let name = nameTextField.text, name != "",
        let phoneNumber = phoneNumberTextField.text, phoneNumber != "",
            let email = emailTextField.text, email != "" else { return }
        
        if contact == nil {
            ContactController.shared.createContact(name: name, phoneNumber: phoneNumber, email: email, completion: { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                    return
                }
            })
        } else if self.contact != nil {
            ContactController.shared.update(contact: contact!, updateName: name, updatedNumber: phoneNumber, updatedEmail: email, completion: { (success) in
                print("Successfully updated contact")
            })
        }
        self.navigationController?.popViewController(animated: true)
    }
}
