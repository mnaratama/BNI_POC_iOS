//
//  ManageQuicklinkTableCell.swift
//  BNIMobile
//
//  Created by Naratama on 09/03/23.
//

import UIKit

protocol ManageQuicklinkTableCellDelegate: class {
//    func collectionView(collectionviewcell: HomeQuicklinksCollectionCell?, index: Int, didTappedInTableViewCell: HomepageOtherQuicklinkTableCell)
}

class ManageQuicklinkTableCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var lineView: UIView!
    
    weak var cellDelegate: ManageQuicklinkTableCellDelegate?
    var items: [QuicklinkModel] = []
    var selectedItems = true
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    private func setupCollectionView(){
        collectionView.register(UINib(nibName: "ManageQuicklinkCollectionCell", bundle: .main), forCellWithReuseIdentifier: "ManageQuicklinkCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func bind(data: [QuicklinkModel], selected: Bool){
        items = data
        selectedItems = selected
        lineView.isHidden = !selected
        collectionView.reloadData()
    }
}

extension ManageQuicklinkTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ManageQuicklinkCollectionCell", for: indexPath) as! ManageQuicklinkCollectionCell
        cell.bind(image: items[indexPath.row].image ?? "", title: items[indexPath.row].title ?? "", selected: selectedItems)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 84)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = collectionView.cellForItem(at: indexPath) as? HomeQuicklinksCollectionCell
//            self.cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
        }
    }
}
