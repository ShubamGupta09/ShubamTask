//
//  SelectionViewController.swift
//  ShubamTask
//
//  Created by Shubam Gupta on 22/07/20.
//  Copyright © 2020 Shubam. All rights reserved.
//

import UIKit
import Kingfisher



class SelectionViewController: UIViewController {

    //MARK: IBOutlet
    @IBOutlet weak var btnSingleSelection: UIButton!
    @IBOutlet weak var btnMultipleSelection: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
        
    //MARK: ViewModel
    lazy var selectionVM = SelectionViewModel(withDelegate: self)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButton()
        selectionVM.jsonValue()
        setUpCollectionView()
    }
    
    //MARK: CollectionView Setup
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName:"CollectionViewCell", bundle: nil), forCellWithReuseIdentifier:"CollectionViewCell")
        collectionView.register(CollectionHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CollectionHeaderReusableView")
    }
    
    func setUpButton() {
        btnSingleSelection.layer.cornerRadius = 5
        btnSingleSelection.setTitleColor(.white, for: .normal)
        btnSingleSelection.layer.backgroundColor = UIColor.black.cgColor
        btnSingleSelection.layer.borderColor = UIColor.clear.cgColor
        
        btnMultipleSelection.layer.cornerRadius = 5
        btnMultipleSelection.layer.borderWidth = 0.5
        btnMultipleSelection.setTitleColor(.black, for: .normal)
        btnMultipleSelection.layer.borderColor = UIColor.black.cgColor
        btnMultipleSelection.layer.backgroundColor = UIColor.white.cgColor
    }
    
    @IBAction func btnSingleSelection(_ sender: Any) {
        btnSingleSelection.layer.cornerRadius = 5
        btnSingleSelection.setTitleColor(.white, for: .normal)
        btnSingleSelection.layer.backgroundColor = UIColor.black.cgColor
        btnSingleSelection.layer.borderColor = UIColor.clear.cgColor
        
        btnMultipleSelection.layer.cornerRadius = 5
        btnMultipleSelection.layer.borderWidth = 0.5
        btnMultipleSelection.setTitleColor(.black, for: .normal)
        btnMultipleSelection.layer.borderColor = UIColor.black.cgColor
        btnMultipleSelection.layer.backgroundColor = UIColor.white.cgColor
        
        // SingleSelection Clicked
        selectionVM.signleSelectionClicked()
    }
    
    @IBAction func btnMutlipleSelection(_ sender: Any) {
        btnMultipleSelection.layer.cornerRadius = 5
        btnMultipleSelection.setTitleColor(.white, for: .normal)
        btnMultipleSelection.layer.backgroundColor = UIColor.black.cgColor
        btnMultipleSelection.layer.borderColor = UIColor.clear.cgColor
        
        btnSingleSelection.layer.cornerRadius = 5
        btnSingleSelection.layer.borderWidth = 0.5
        btnSingleSelection.setTitleColor(.black, for: .normal)
        btnSingleSelection.layer.borderColor = UIColor.black.cgColor
        btnSingleSelection.layer.backgroundColor = UIColor.white.cgColor
        
        //MultiSelection Selected
        selectionVM.mutliSeletionClicked()
    }
}

extension SelectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //MARK: numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectionVM.numberOfItemsInSection(section: section)
    }
    
    //MARK: numberOfSections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return selectionVM.numberOfSections()
    }
    
    //MARK: CellForItem
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell {
            selectionVM.cellForItemAtCollectionView(cell, ofIndexPath: indexPath)
            return cell
        }
        return UICollectionViewCell()
    }
    
    //MARK: HeaderView (Section)
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionHeaderReusableView", for: indexPath) as? CollectionHeaderReusableView {
            selectionVM.prepareHeader(headerView, ofIndexPath: indexPath)
            return headerView
        }
        return UICollectionReusableView()
    }
    
    //MARK: SizeForItem
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return selectionVM.prepareSizeForitems()
    }
    
    //MARK: SizeForHeader
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return selectionVM.prepareSizeForHeader()
    }
    
    //MARK: didSelectItem
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectionVM.didSelectItemForCollectionView(indexPath: indexPath)
    }
}

// MARK: Delegates
extension SelectionViewController: SelectionViewModelDelegates {
    func collectionViewReload() {
        collectionView.reloadData()
    }
}

