//
//  NetworkManager.swift
//  PinterestV
//
//  Created by Alex Voronov on 29.04.18.
//  Copyright © 2018 Alex Voronov. All rights reserved.
//

import UIKit


class NetworkManager {
    
    // MARK: properties
    var callbackUser: ((User) -> ())?
    var callbackBoards: (([Board]) -> ())?
    var callbackPins: (([Pin]) -> ())?
    
    let host: String = "https://api.pinterest.com"
    let me: String = "/v1/me/"
    let boards: String = "boards/"
    let pins: String = "pins/"
    
    let token: String = "AR5bKX9SSZp7hl0NUA2YTyEYXuWZFSlgnrFKrolE4qNQJ4AtewAAAAA"
    
    // to get all fields list : developers.pinterest.com/tools/api-explorer/?
    let fieldsMe: String = "account_type%2Cbio%2Ccounts%2Ccreated_at%2Cfirst_name%2Cid%2Cimage%2Clast_name%2Curl%2Cusername"
    let fieldsBoards: String = "id%2Cname%2Curl%2Ccounts%2Ccreated_at%2Ccreator%2Cdescription%2Cimage%2Cprivacy%2Creason"
    let fieldsPins: String = "id%2Clink%2Cnote%2Curl%2Cattribution%2Cboard%2Ccolor%2Ccounts%2Ccreated_at%2Ccreator%2Cmedia%2Cimage%2Cmetadata%2Coriginal_link"
    
    enum RequestType {
        case Me
        case MyBoards
        case MyPins
    }
    
    init() {}
}

// MARK: internal
extension NetworkManager {
    
    func getInfo(for type: RequestType) {
        
        let fullStringMe: String = host + me + "?" + "access_token=" + token + "&" + "fields=" + fieldsMe
        let fullStringMyBoards: String = host + me + boards + "?" + "access_token=" + token + "&" + "fields=" + fieldsBoards
        let fullStringMyPins: String = host + me + pins + "?" + "access_token=" + token + "&" + "fields=" + fieldsPins
        
        var fullString: String?
        
        switch type {
        case .Me:
            fullString = fullStringMe
            
        case .MyBoards:
            fullString = fullStringMyBoards
            
        case .MyPins:
            fullString = fullStringMyPins
        }
        
        guard let fullSrt = fullString else { return }
        sendRequest(with: fullSrt, for: type)
    }
}

// MARK: private
private extension NetworkManager {

    func sendRequest(with urlString: String, for type: RequestType) {
        guard let url = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String, Any>
                
                guard let jsonUnwrapped = json else { return }
                print(jsonUnwrapped)
                
                switch type {
                case .Me:
                    self.parseUser(from: jsonUnwrapped)
                    
                case .MyBoards:
                    self.parseBoards(from: jsonUnwrapped)
                    
                case .MyPins:
                    self.parsePins(from: jsonUnwrapped)
                }
                
            } catch {
                print(error)
            }
        }.resume()
    }
    
    // MARK: parse
    func parseBoards(from json: Dictionary<String, Any>) {
        
        var boardsArray: [Board] = []
        
        guard let boardsJSON = json["data"] as? [[String: Any?]], !boardsJSON.isEmpty else { return }
        
        for boardJSON in boardsJSON {
            
            let createdAt = boardJSON["created_at"] as? String
            let description = boardJSON["description"] as? String
            let name = boardJSON["name"] as? String
            let id = boardJSON["id"] as? String
            
            var imageUrlString = ""
            
            if let imageInfo = boardJSON["image"] as? [String: Any?],
                let size = imageInfo["60x60"] as? [String: Any?] {
                imageUrlString = size["url"] as? String ?? ""
            }
            
            var creatorId = ""
            
            if let creator = boardJSON["creator"] as? [String: Any?] {
                creatorId = creator["id"] as? String ?? ""
            }
            
            let board = Board(createdAt: createdAt, description: description, id: id, imageUrlString: imageUrlString, name: name, creatorId: creatorId, pins: [])
            
            boardsArray.append(board)
        }
        
        self.callbackBoards?(boardsArray)
    }
    
    func parsePins(from json: Dictionary<String, Any>) {
        
        var pinsArr: [Pin] = []
        
        guard let pinsArrJSON = json["data"] as? [[String: Any?]], !pinsArrJSON.isEmpty else { return }
        
        for pinJSON in pinsArrJSON {
            
            let createdAt = pinJSON["created_at"] as? String
            let note = pinJSON["note"] as? String
            let id = pinJSON["id"] as? String
            
            var imageUrlString = ""
            
            if let imageInfo = pinJSON["image"] as? [String: Any?],
                let original = imageInfo["original"] as? [String: Any?] {
                imageUrlString = original["url"] as? String ?? ""
            }
            
            var creatorId = ""
            
            if let creator = pinJSON["creator"] as? [String: Any?] {
                creatorId = creator["id"] as? String ?? ""
            }
            
            var boardId = ""
            
            if let board = pinJSON["board"] as? [String: Any?] {
                boardId = board["id"] as? String ?? ""
            }
            
            let pin = Pin(createdAt: createdAt, id: id, imageUrlString: imageUrlString, note: note, boardId: boardId, creatorId: creatorId)
            
            pinsArr.append(pin)
        }
        
        self.callbackPins?(pinsArr)
    }
    
    func parseUser(from json: Dictionary<String, Any>) {
        guard let jsonParse = json["data"] as? [String: Any?]  else { return }
        
        let username = jsonParse["username"] as? String
        let firstName = jsonParse["first_name"] as? String
        let lastName = jsonParse["last_name"] as? String
        let createdAt = jsonParse["created_at"] as? String
        
        let accountType = jsonParse["account_type"] as? String
        let bio = jsonParse["bio"] as? String
        let id = jsonParse["id"] as? String
        let url = jsonParse["url"] as? String
        
        var imageUrl = ""
        
        if let imageInfo = jsonParse["image"] as? [String: Any?],
            let size = imageInfo["60x60"] as? [String: Any?] {
            imageUrl = size["url"] as? String ?? ""
        }
        
        var counts: (boards: Int, followers: Int, following: Int, pins: Int) = (0, 0, 0, 0)
        
        if let countsJSON = jsonParse["counts"] as? [String: Int] {
            let boards = countsJSON["boards"] ?? 0
            let followers = countsJSON["followers"] ?? 0
            let following = countsJSON["following"] ?? 0
            let pins = countsJSON["pins"] ?? 0
            counts = (boards, followers, following, pins)
        }
        
        let user = User(accountType: accountType, bio: bio, createdAt: createdAt, firstName: firstName, id: id, imageUrl: imageUrl, lastName: lastName, url: url, username: username, boards: counts.boards, followers: counts.followers, following: counts.following, pins: counts.pins, boardsArray: [])
        
        self.callbackUser?(user)
    }
}

// MARK: download image extension
extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
