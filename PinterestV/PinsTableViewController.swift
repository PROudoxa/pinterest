//
//  PinsTableViewController.swift
//  PinterestV
//
//  Created by Alex Voronov on 30.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import UIKit

class PinsTableViewController: UITableViewController {
    
    // MARK: Properties
    var boards: [Board] = []
    var pins: [Pin] = []
    //var cache: NSCache<AnyObject, AnyObject>?
    //var refreshCtrl: UIRefreshControl?
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Pins"
    }
}

extension PinsTableViewController {
    
    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        //navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Table view data source
extension PinsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return boards.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boards[section].pins.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PinCell
        
        cell.createdAtLabel.text = boards[indexPath.section].pins[indexPath.row].createdAt
        cell.notesLabel.text = boards[indexPath.section].pins[indexPath.row].note
        
        // FIXME: problem with images layout and updating
        guard let linkString = boards[indexPath.section].pins[indexPath.row].imageUrlString, linkString != "" else { return cell }
        
            DispatchQueue.global(qos: .utility).sync {
                cell.pinImageView.downloadedFrom(link: linkString)
//                self.tableView.beginUpdates()
//                self.tableView.reloadRows(at: [indexPath], with: .fade)
//                self.tableView.endUpdates()
                cell.pinImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
                //cell.imageView?.contentMode = .scaleAspectFit // OR .scaleAspectFill
                cell.pinImageView.clipsToBounds = true
                cell.setNeedsLayout()
                //tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let name = boards[section].name, let createdAt = boards[section].createdAt else { return "" }
        
        let index = createdAt.index(createdAt.startIndex, offsetBy: 10)
        let fullCreatedAt = "created at: " + createdAt.substring(to: index)
        
        return  "(\(fullCreatedAt)) " + name
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        return "  "
    }
}
