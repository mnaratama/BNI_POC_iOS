//
//  HomepageOtherQuicklinkTableCell.swift
//  BNIMobile
//
//  Created by Naratama on 07/03/23.
//

import UIKit

protocol HomepageOtherQuicklinkTableCellCellDelegate: class {
    func collectionView(collectionviewcell: HomeQuicklinksCollectionCell?, index: Int, didTappedInTableViewCell: HomepageOtherQuicklinkTableCell)
}

class HomepageOtherQuicklinkTableCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    weak var cellDelegate: HomepageOtherQuicklinkTableCellCellDelegate?
    var items: [QuicklinkModel] = []
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    private func setupCollectionView(){
        collectionView.register(UINib(nibName: "HomeQuicklinksCollectionCell", bundle: .main), forCellWithReuseIdentifier: "QuicklinksCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func bind(data: [QuicklinkModel]){
        items = data
        collectionView.reloadData()
    }
}

extension HomepageOtherQuicklinkTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuicklinksCollectionCell", for: indexPath) as! HomeQuicklinksCollectionCell
        cell.bind(image: items[indexPath.row].image ?? "", title: items[indexPath.row].title ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 84)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = collectionView.cellForItem(at: indexPath) as? HomeQuicklinksCollectionCell
            self.cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
        }
    }
}
