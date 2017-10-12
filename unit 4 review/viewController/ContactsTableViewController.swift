//
//  ContactsTableViewController.swift
//  unit 4 review
//
//  Created by Brian Licea on 10/12/17.
//  Copyright © 2017 Brian Licea. All rights reserved.
//

import UIKit

class ContactsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: ContactController.shared.notification, object: nil)
        
        ContactController.shared.fetchContact()
    }
    
    @objc func refresh() {
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ContactController.shared.contacts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Keys.cell, for: indexPath)
        let contacts = ContactController.shared.contacts[indexPath.row]
        cell.textLabel?.text = contacts.name
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let contact = ContactController.shared.contacts[indexPath.row]
            ContactController.shared.deleteContact(contact: contact)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Keys.toDetail {
            let destination = segue.destination as? ContactsViewController
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let contact = ContactController.shared.contacts[indexPath.row]
            destination?.contact = contact
        }
    }
    
}
