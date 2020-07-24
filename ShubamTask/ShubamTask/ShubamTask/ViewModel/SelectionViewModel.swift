//
//  SelectionViewModel.swift
//  ShubamTask
//
//  Created by Shubam Gupta on 24/07/20.
//  Copyright © 2020 Shubam. All rights reserved.
//

import Foundation
import UIKit

//MARK: enum for differentType of selection
enum selectionType {
    case singleSelection
    case multiSelection
}

//MARK: protocol and Delegates to communicate data between VC & VM
protocol SelectionViewModelDelegates: NSObjectProtocol {
    func collectionViewReload()
}

// MARK: struct to save the selection data
struct SelectionUser {
    let name: String
    var friendName: [String]
}

//MARK: ViewModel for Selection VC
class SelectionViewModel: NSObject {
    
    //MARK: Variables
    var singleUser = [SelectionUser]()
    var multiUser = [SelectionUser]()
    
    //MARK: data to be saved from Coding
    var userData: [UserDetailData] = [] {
        didSet {
            delegates?.collectionViewReload()
        }
    }
    
    var typeSelection: selectionType = .singleSelection
    weak var delegates: SelectionViewModelDelegates?
    
    //MARK: Initializer Method
    init(withDelegate delegate: SelectionViewModelDelegates?) {
        delegates = delegate
    }
    
    //MARK: Preparing Header(Section)
    func prepareHeader(_ headerView: CollectionHeaderReusableView, ofIndexPath indexPath: IndexPath) {
        let responce = userData[indexPath.section].name
        
        headerView.configure(msg: "Name: \(responce)")
        headerView.layer.borderColor = UIColor.lightGray.cgColor
        headerView.layer.borderWidth = 0.5
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        headerView.tag = indexPath.section
        headerView.addGestureRecognizer(tap)
        
    }
    
    //MARK: Single Selection buton
    func signleSelectionClicked() {
        typeSelection = .singleSelection
    }
    
    //MARK: MultiSelection buton
    func mutliSeletionClicked() {
        typeSelection = .multiSelection
    }
    
    func cellForItemAtCollectionView(_ cell: CollectionViewCell, ofIndexPath indexPath: IndexPath) {
        if let label = cell.lblTitle{
            label.text = userData[indexPath.section].friends[indexPath.row].name
            label.textColor = .black
        }
        cell.imageView.kf.setImage(with: URL(string: userData[indexPath.section].friends[indexPath.row].image), placeholder: #imageLiteral(resourceName: "FullSizeRender.JPG"))
    }
    
    
    func numberOfSections() -> Int {
        return userData.count
    }
    
    func numberOfItemsInSection(section: Int) -> Int{
        if userData[section].expand == false {
            return 0 // Collapse
        } else {
            return userData[section].friends.count //Expand
        }
        
    }
    
    func prepareSizeForitems() -> CGSize{
        return CGSize(width: UIScreen.main.bounds.size.width - 40, height: 50)
    }
    
    func prepareSizeForHeader() -> CGSize {
        return CGSize(width: 60, height: 50)
    }
    
    func didSelectItemForCollectionView(indexPath: IndexPath) {
        if typeSelection == .singleSelection {
            userData[indexPath.section].expand = false
            let selectedResponceName = userData[indexPath.section].name
            let selectedResponceFriendName = userData[indexPath.section].friends[indexPath.row].name
            let selectionResponce = SelectionUser(name: selectedResponceName, friendName: [selectedResponceFriendName])
            singleUser.append(selectionResponce)
            print(singleUser)
            delegates?.collectionViewReload()
        } else {
            let selectedResponceName = userData[indexPath.section].name
            let selectedResponceFriendName: [String] = [userData[indexPath.section].friends[indexPath.row].name]
            var selectedResponce: SelectionUser
            if multiUser.count == 0 {
                selectedResponce = SelectionUser(name: selectedResponceName, friendName: selectedResponceFriendName)
                multiUser.append(selectedResponce)
            } else {
                for i in 0...multiUser.count - 1 {
                    let value = multiUser[i].name
                    print(value)
                    print(selectedResponceName)
                    if value == selectedResponceName {
                        multiUser[i].friendName.append(contentsOf: selectedResponceFriendName)
                        print(multiUser)
                    } else {
                        if indexPath.section == i {
                            multiUser[i].friendName.append(contentsOf: selectedResponceFriendName)
                            print(multiUser)
                        } else {
                            selectedResponce = SelectionUser(name: selectedResponceName, friendName: selectedResponceFriendName)
                            multiUser.append(selectedResponce)
                            print(multiUser)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: TapGesture for HeaderCell
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        let value = sender?.view?.tag
        guard let responce = value else { return }
        
        if userData[responce].expand == true {
            userData[responce].expand = false
        } else {
            userData[responce].expand = true
        }
        delegates?.collectionViewReload()
    }
    
    //MARK: JsonValue to Codable
    func jsonValue() {
        guard let jsonURL = Bundle(for: type(of: self)).path(forResource: "userDetails",ofType: "json") else { return }
        guard let jsonString = try? String(contentsOf: URL(fileURLWithPath: jsonURL), encoding: String.Encoding.utf8) else { return }
        
        //jsonString
        var userDetails: UserDetails?
        do{
            userDetails = try JSONDecoder().decode(UserDetails.self, from: Data(jsonString.utf8))
        } catch {
            print("Error Occur when decoding")
        }
        
        guard let result = userDetails else {
            print("Person is nil, there is no data")
            return }
        
        print(result.userDetails.count)
        userData = result.userDetails
    }
}
