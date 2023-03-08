//
//  HomeQuicklinkTableCell.swift
//  BNIMobile
//
//  Created by Naratama on 06/03/23.
//

import UIKit

class HomeQuicklinkTableCell: UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var viewQuicklink: UIView!
    @IBOutlet weak var circleImg: UIButton!
    
    var items: [HomeQuicklink]?
    var didSelectCell: ((Int)->Void)?
    
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
        viewQuicklink.layer.shadowOffset = CGSize(width: 0.3,
                                                  height: 0.7)
        viewQuicklink.layer.shadowRadius = 1.3
        viewQuicklink.layer.shadowOpacity = 0.08
        viewQuicklink.layer.cornerRadius = 8
    }
    
    func bind(data: [HomeQuicklink]){
        items = data
        collectionView.reloadData()
    }
    
    @IBAction func manageTapped(_ sender: UIButton) {
    }
    
    @IBAction func circleTapped(_ sender: UIButton) {
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
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QuicklinksCollectionCell", for: indexPath) as! HomeQuicklinksCollectionCell
//        cell.bind(image: <#T##String#>, title: <#T##String#>)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/4, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCell?(indexPath.row)
    }
}
