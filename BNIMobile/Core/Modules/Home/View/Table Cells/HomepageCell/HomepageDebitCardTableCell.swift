//
//  HomepageDebitCardTableCell.swift
//  BNIMobile
//
//  Created by Naratama on 07/03/23.
//

import UIKit

protocol HomepageDebitCardTableCellDelegate: class {
    func collectionView(collectionviewcell: HomepageDebitCardCollectionCell?, index: Int, didTappedInTableViewCell: HomepageDebitCardTableCell)
}

class HomepageDebitCardTableCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    weak var cellDelegate: HomepageDebitCardTableCellDelegate?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    private func setupCollectionView(){
        collectionView.register(UINib(nibName: "HomepageDebitCardCollectionCell", bundle: .main), forCellWithReuseIdentifier: "HomepageDebitCardCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

extension HomepageDebitCardTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomepageDebitCardCollectionCell", for: indexPath) as! HomepageDebitCardCollectionCell
        cell.bind()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 332, height: 128)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? HomepageDebitCardCollectionCell
        self.cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
    }
}

