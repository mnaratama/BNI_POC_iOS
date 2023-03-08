//
//  HomepageHeaderTableCell.swift
//  BNIMobile
//
//  Created by Naratama on 07/03/23.
//

import UIKit

class HomepageHeaderTableCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var shadowView: UIView!
    
    var didSelectCell: ((Int)->Void)?
    var items: [QuicklinkModel] = []
    
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
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
    }
    
    private func setupView(){
        shadowView.layer.cornerRadius = 8
        shadowView.layer.shadowOffset = CGSize(width: 0.5,
                                             height: 0.7)
        shadowView.layer.shadowRadius = 1.3
        shadowView.layer.shadowOpacity = 0.2
    }
    
    func bind(data: [QuicklinkModel]){
        items = data
        collectionView.reloadData()
    }
}

extension HomepageHeaderTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuicklinksCollectionCell", for: indexPath) as! HomeQuicklinksCollectionCell
        cell.bind(image: items[indexPath.row].image ?? "", title: items[indexPath.row].title ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/4, height: 84)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCell?(indexPath.row)
    }
}

