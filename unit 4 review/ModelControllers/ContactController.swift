//
//  ContactController.swift
//  unit 4 review
//
//  Created by Brian Licea on 10/11/17.
//  Copyright © 2017 Brian Licea. All rights reserved.
//

import Foundation
import CloudKit

class ContactController {
    private let cloudKitManager = CloudKitManager()
    static let shared = ContactController()
    
    let notification = Notification.Name("DidRecieve")
    
    var contacts: [Contact] = [] {
        didSet {
            DispatchQueue.main.async {
                let nc = NotificationCenter.default
                nc.post(name: self.notification, object: nil)
            }
        }
    }
    
    init() {
        
    }
    
    func createContact(name: String, phoneNumber: String, email: String, completion: @escaping (Error?) -> Void) {
        
        let contact = Contact(name: name, phoneNumber: phoneNumber, email: email)
        cloudKitManager.save(contact.ckRepresentation) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
                completion(error)
                return
            }
        }
        self.contacts.append(contact)
    }
    
    func update(contact: Contact, updateName: String, updatedNumber: String, updatedEmail: String, completion: @escaping (Bool) -> Void) {
        
        cloudKitManager.update(contact: contact, name: updateName, phoneNumber: updatedNumber, email: updatedEmail) { (newContact) in
            guard let newContact = newContact else { completion(false); return }
            
            guard let index = self.contacts.index(of: contact) else { completion(false); return }
            
            self.contacts[index] = newContact
            
            completion(true)
        }
    }
    
    func fetchContact(completion: @escaping ((Error?) -> Void) = {_ in}) {
        cloudKitManager.fetchrecords(ofType: Keys.recordNameKey) { (records, error) in
            if let error = error {
                print("Error")
                completion(error)
                return
            }
            else {
                print("Success fetching contacts")
            }
            guard let records = records else { return }
            self.contacts = records.flatMap { Contact(cloudKitRecord: $0) }
        }
    }
    
    func remove(contact: Contact) {
        guard let index = contacts.index(of: contact) else { return }
        self.contacts.remove(at: index)
    }
    
    func deleteContact(recordID: CKRecordID, completion: @escaping (Error?) -> Void) {
        cloudKitManager.delete(withRecordID: recordID) { (record, error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
                completion(error)
                return
            }
        }
    }
    
    func deleteContact(contact: Contact) {
        let record = contact.ckRepresentation
        cloudKitManager.deleteOperation(record) {
            guard let indexPath = self.contacts.index(of: contact) else { return }
            self.contacts.remove(at: indexPath)
        }
    }
}

