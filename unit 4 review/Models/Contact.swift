//
//  Contacts.swift
//  unit 4 review
//
//  Created by Brian Licea on 10/11/17.
//  Copyright © 2017 Brian Licea. All rights reserved.
//

import Foundation
import CloudKit

class Contact {
    
    
    
    var name: String
    var phoneNumber: String
    var email: String
    var recordID: CKRecordID?
    
    init(name: String, phoneNumber: String, email: String) {
        
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
    }
    
    init?(cloudKitRecord: CKRecord) {
        
        guard cloudKitRecord.recordType == Keys.recordNameKey, let name = cloudKitRecord[Keys.nameKey] as? String,
            let phoneNumber = cloudKitRecord[Keys.phoneNumberKey] as? String,
            let email = cloudKitRecord[Keys.emailKey] as? String else {
                return nil }
        
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
        self.recordID = cloudKitRecord.recordID
        
    }
    
    var ckRepresentation: CKRecord {
        let record = CKRecord(recordType: Keys.recordNameKey)
        recordID = record.recordID
        record.setValue(name, forKey: Keys.nameKey)
        record.setValue(phoneNumber, forKey: Keys.phoneNumberKey)
        record.setValue(email, forKey: Keys.emailKey)
        
        return record
    }
}

extension Contact: Equatable {}

func ==(lhs: Contact, rhs: Contact) -> Bool {
    return lhs.name == rhs.name && lhs.email == rhs.email && lhs.phoneNumber == rhs.phoneNumber
}

