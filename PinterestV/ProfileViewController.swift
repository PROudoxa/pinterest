//
//  ProfileViewController.swift
//  PinterestV
//
//  Created by Alex Voronov on 29.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: Properties
    let networkManager = NetworkManager()
    var arrBoards: [Board] = []
    var arrPins: [Pin] = []
    
    // MARK: IBOutlets
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var boardsLabel: UILabel!
    @IBOutlet weak var pinsLabel: UILabel!
    @IBOutlet weak var boardsButton: UIButton!
    @IBOutlet weak var pinsButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        boardsButton.layer.cornerRadius = 5
        pinsButton.layer.cornerRadius = 5
        
        scrollView.contentInset.bottom += -200
        
        networkManager.getInfo(for: .Me)
        
        networkManager.callbackUser = { [unowned self] (user: User) in
            self.updateImage(with: user.imageUrl)
            self.updateLabels(for: user)
        }
        
        DispatchQueue.global(qos: .utility).async {
            
            self.networkManager.getInfo(for: .MyPins)
            self.networkManager.callbackPins = { [unowned self] (pins: [Pin]) in
                self.arrPins = pins
            }
            
            self.networkManager.getInfo(for: .MyBoards)
            self.networkManager.callbackBoards = { [unowned self] (boards: [Board]) in
                self.arrBoards = boards
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPinsSegue" {
            guard let navigationController = segue.destination as? UINavigationController,
                let destinationVC = navigationController.topViewController as? PinsTableViewController else {
                    fatalError("guard: Application storyboard mis-configuration")
            }
            
            for board in self.arrBoards {
                
                let boardId = board.id
                let appropriatePins = self.arrPins.filter(){ $0.boardId == boardId }
                
                board.pins = appropriatePins
            }
            
            destinationVC.boards = self.arrBoards
        }
    }
}

// MARK: IBActions
extension ProfileViewController {
    
    @IBAction func boardsTapped(_ sender: UIButton) {
        print("boards tapped")
    }
    
    @IBAction func pinsTapped(_ sender: UIButton) {
        print("pins tapped")
    }
}

// MARK: Private
private extension ProfileViewController {
    
    func updateImage(with imageLinkString: String?) {
        
        guard let linkString = imageLinkString else { return }
        DispatchQueue.global(qos: .background).async {
            self.userImage.downloadedFrom(link: linkString)
        }
    }
    
    func updateLabels(for user: User) {
        DispatchQueue.main.async {
            self.usernameLabel.text = user.username
            self.firstNameLabel.text = user.firstName
            self.lastNameLabel.text = user.lastName
            self.bioLabel.text = user.bio
            self.followersLabel.text = "followers: " + "\(user.counts.followers)"
            self.followingLabel.text = "following: " + "\(user.counts.following)"
            self.boardsLabel.text = "boards: " + "\(user.counts.boards)"
            self.pinsLabel.text = "pins: " + "\(user.counts.pins)"
            
            if let createdAt = user.createdAt {
                let index = createdAt.index(createdAt.startIndex, offsetBy: 10)
                self.createdAtLabel.text = "created at: " + createdAt.substring(to: index)
            }
        }
    }
}
