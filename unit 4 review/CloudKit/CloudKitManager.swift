//
//  CloudKitManager.swift
//  unit 4 review
//
//  Created by Brian Licea on 10/11/17.
//  Copyright © 2017 Brian Licea. All rights reserved.
//

import Foundation
import CloudKit

class CloudKitManager {
    let publicDataBase = CKContainer.default().publicCloudDatabase

    func fetchrecords(ofType type: String, withSortDiscriptor sortDiscriptors: [NSSortDescriptor]? = nil, completion: @escaping ([CKRecord]?, Error?) -> Void) {

        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: type, predicate: predicate)
        query.sortDescriptors = sortDiscriptors
        publicDataBase.perform(query, inZoneWith: nil, completionHandler: completion)
    }

    func save(_ record: CKRecord, completion: @escaping ((Error?) -> Void) = {_ in }) {

        publicDataBase.save(record) { (record, error) in
            completion(error)
        }
    }

    func update(contact: Contact, name: String, phoneNumber: String, email: String, completion: @escaping(Contact?) -> Void) {

        guard let recordID = contact.recordID else { return }

        publicDataBase.fetch(withRecordID: recordID) { (record, error) in

            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let record = record else { completion(nil); return }

            record.setValue(name, forKey: Keys.nameKey)
            record.setValue(phoneNumber, forKey: Keys.phoneNumberKey)
            record.setValue(email, forKey: Keys.emailKey)

            let modifyOperation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)

            modifyOperation.savePolicy = .changedKeys
            modifyOperation.modifyRecordsCompletionBlock = { (records, recordID, error) in
                guard let record = records?.first else { completion(nil); return }

                let  updateContact = Contact(cloudKitRecord: record)
                completion(updateContact)
            }
            self.publicDataBase.add(modifyOperation)
        }
    }

    func delete(withRecordID: CKRecordID, completionHandler: @escaping ( CKRecordID?, Error?) -> Void) {
        publicDataBase.delete(withRecordID: withRecordID, completionHandler: completionHandler)
    }

    func deleteOperation(_ record: CKRecord, completion: @escaping () -> Void ) {
        let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [record.recordID])
        operation.savePolicy = .changedKeys
        operation.queuePriority = .high
        operation.qualityOfService = .userInteractive

        operation.modifyRecordsCompletionBlock = { added, deleted, error in
            if let error = error {
                print(error)
            }
            else {

            }
        }
        self.publicDataBase.add(operation)
        completion()
    }
}

