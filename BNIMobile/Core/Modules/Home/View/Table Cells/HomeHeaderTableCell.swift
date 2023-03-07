//
//  HomeHeaderTableCell.swift
//  BNIMobile
//
//  Created by Naratama on 06/03/23.
//

import UIKit

class HomeHeaderTableCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var containerView: UIView!
    
    var items:[HomeHeaderTab]?
    var didSelectCell: ((Int)->Void)?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    private func setupCollectionView(){
        collectionView.register(UINib(nibName: "HomeHeaderCollectionCell", bundle: .main), forCellWithReuseIdentifier: "HeaderCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 80, bottom: 0, right: 16)
    }
    
    private func setupView(){
        containerView.layer.cornerRadius = 24
    }
    
    func bind(items: [HomeHeaderTab]){
        self.items = items
        collectionView.reloadData()
    }
    
    @IBAction func copyTapped(_ sender: UIButton) {
    }
    
}

extension HomeHeaderTableCell{
    struct HomeHeaderTab {
        let id: Int
        let name: String
        let image: String
    }
}

extension HomeHeaderTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCollectionCell", for: indexPath) as! HomeHeaderCollectionCell
        cell.bind()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 228, height: 144)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCell?(indexPath.row)
    }
}

