//
//  ViewController.swift
//  FirebaseMasterDetail
//
//  Copyright © 2016 ninbe. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var ref: FIRDatabaseReference!
    var listItems = [ListItem]()
    var selectedItem: ListItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.listItems.removeAll()
        
        let topItemsRef = ref.child("top-items")
        topItemsRef.observeSingleEvent(of: FIRDataEventType.value, with: { (snapshot) in
            if let items = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for item in items {
                    let title = item.childSnapshot(forPath: "title").value as? String
                    let detail = item.childSnapshot(forPath: "detail").value as? String
                    if let listItem = ListItem(key: item.key, title: title, detail: detail) {
                        self.listItems.append(listItem)
                    }
                }
                self.tableView.reloadData()
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainItem", for: indexPath)
        let listItem = listItems[(indexPath as NSIndexPath).row]
        cell.textLabel!.text = listItem.title
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = listItems[(indexPath as NSIndexPath).row]
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDetail") {
            let detail = segue.destination as! DetailViewController
            detail.item = selectedItem
        }
    }
}

open class ListItem: NSObject {
    var key: String
    var title: String
    var detail: String
    
    init?(key: String?, title: String?, detail: String?) {
        if let text = key {
            self.key = text
        } else {
            return nil
        }
        if let text = title {
            self.title = text
        } else {
            self.title = "no title"
        }
        if let text = detail {
            self.detail = text
        } else {
            self.detail = "no detail"
        }
    }
//
//    convenience override init() {
//        self.init(key: "", title: "", detail: "")
//    }
}

