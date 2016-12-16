//
//  File.swift
//  FirebaseMasterDetail
//
//  Copyright © 2016 ninbe. All rights reserved.
//

import UIKit
import Firebase

class DetailViewController: UIViewController {
    
    var ref: FIRDatabaseReference!
    var item: ListItem!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var detailText: UITextView!
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
    }
    
    @IBAction func updateButtonClicked(_ sender: AnyObject) {
        
        var title: String = ""
        var detail: String = ""
        
        if let text = self.titleText.text {
            title = text
        }
        if let text = self.detailText.text {
            detail = text
        }
        let data = ["title": title, "detail": detail]
        let key = "/top-items/\(self.item.key)"
        ref.updateChildValues([key: data], withCompletionBlock: { (error: Error?, ref: FIRDatabaseReference) in
            if let _ = error {
                print(error)
            }
        })
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.titleText.text = self.item.title
        self.detailText.text = self.item.detail
    }
}
