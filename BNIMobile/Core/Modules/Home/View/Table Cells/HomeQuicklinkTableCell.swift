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
    
    private let width = UIScreen.main.bounds.width / 3
    private var height = 154.0
//    var items: [HomePageRevampProgram]?
    var didSelectCell: ((Int)->Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = .clear
        setupCollectionView()
    }
    
    private func setupCollectionView(){
//        collectionView.register([HomeQuicklinksCollectionCell.self])
        collectionView.delegate = self
        collectionView.dataSource = self
        
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func bind(data: [HomePageRevampProgram], bottomLine: Bool = false){
//        items = data
        collectionView.reloadData()
//        bottomLineView.isHidden = !bottomLine
        height = bottomLine ? 170.0 : 154.0
    }
}

extension HomeQuicklinkTableCell{
    struct HomePageRevampProgram {
        let id: Int
        let name: String
        let desc: String
        let image: String
    }
}

extension HomeQuicklinkTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.items?.count ?? 0
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if let cell: HomePageRevampProgramCollectionCell = collectionView.dequeueReusableCell(for: indexPath){
//            cell.bind(image: items?[indexPath.row].image ?? "", title: items?[indexPath.row].name ?? "", body: items?[indexPath.row].desc ?? "")
//            return cell
//        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width, height: 92)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCell?(indexPath.row)
    }
}
