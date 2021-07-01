//
//  ActorCollection.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-24.
//

import UIKit

private let cellIdentifier = "ActorCell"

class ActorCollection: UICollectionReusableView {
    
    //MARK: - Properties
    
    var actors = [Actor]() {
        didSet { collectionView.reloadData() }
    }
        
    private let actorsLabel: UILabel = {
        let label = UILabel()
        label.text = "Actors"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        cv.register(ActorCell.self, forCellWithReuseIdentifier: cellIdentifier)
        return cv
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(actorsLabel)
        
        actorsLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        addSubview(collectionView)
        collectionView.anchor(
            top: actorsLabel.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,
            paddingTop: 4, paddingLeft: 12, paddingBottom: 24, paddingRight: 12
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UICollectionViewDataSource


extension ActorCollection: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ActorCell
        cell.actor = actors[indexPath.row]
        print("CELL FÅR ACTOR")
        return cell
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ActorCollection: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 110)
    }
}
    
