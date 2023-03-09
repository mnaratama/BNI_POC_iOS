//
//  HomeQuicklinkTableCell.swift
//  BNIMobile
//
//  Created by Naratama on 06/03/23.
//

import UIKit

protocol HomeQuicklinkTableCellDelegate: class {
    func collectionView(collectionviewcell: HomeQuicklinksCollectionCell?, index: Int, didTappedInTableViewCell: HomeQuicklinkTableCell)
    func pushToManage()
}

class HomeQuicklinkTableCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var viewQuicklink: UIView!
    @IBOutlet weak var stackView: UIView!
    @IBOutlet weak var buttonImg: UIImageView!
    
    var items: [QuicklinkModel] = []
    weak var cellDelegate: HomeQuicklinkTableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        setupCollectionView()
        setupView()
    }
    
    private func setupCollectionView(){
        collectionView.register(UINib(nibName: "HomeQuicklinksCollectionCell", bundle: .main), forCellWithReuseIdentifier: "QuicklinksCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 0
    }
    
    private func setupView(){
        viewQuicklink.layer.shadowOffset = CGSize(width: 0.3,
                                                  height: 0.7)
        viewQuicklink.layer.shadowRadius = 1.3
        viewQuicklink.layer.shadowOpacity = 0.08
        viewQuicklink.layer.cornerRadius = 8
    }
    
    func bind(data: [QuicklinkModel], selected: Int){
        items = data
        collectionView.reloadData()
        if selected == 1 {
            buttonImg.image = UIImage(named: "ic_circle_chevron_up")
            stackView.isHidden = false
        } else {
            buttonImg.image = UIImage(named: "ic_circle_chevron_bottom")
            stackView.isHidden = true
        }
    }
    
    @IBAction func manageTapped(_ sender: UIButton) {
        self.cellDelegate?.pushToManage()
    }
    
}

extension HomeQuicklinkTableCell{
    struct HomeQuicklink {
        let id: Int
        let name: String
        let image: String
    }
}

extension HomeQuicklinkTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuicklinksCollectionCell", for: indexPath) as! HomeQuicklinksCollectionCell
        cell.bind(image: items[indexPath.row].image ?? "", title: items[indexPath.row].title ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75, height: 83)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = collectionView.cellForItem(at: indexPath) as? HomeQuicklinksCollectionCell
            self.cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
        }
    }
}
