//
//  MovieCollectionView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-03-15.
//

import UIKit

private let cellIdentifier = "MovieCell"

protocol MovieCollectionDelegate: class {
    func collectionPresentMovieDetails(movie: Movie)
}

class MovieCollection: UIView {
    
    //MARK: - Properties
    
    weak var delegate: MovieCollectionDelegate?
    
    var movies: [Movie]! {
        didSet{ loadData() }
    }
    
    private let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .white
        return cv
    }()

    
    //MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        movies = []
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(WatchlistCollectionCell.self, forCellWithReuseIdentifier: cellIdentifier)
        
        addSubview(collectionView)
        collectionView.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Actions
    
    func loadData() {
        collectionView.reloadData()
    }
    
}

//MARK: - UICollectionViewDelegateFlowLAyout, UICollectionViewDataSource

extension MovieCollection: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
        
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! WatchlistCollectionCell
        cell.poster.sd_setImage(with: movies[indexPath.row].posterPath)
        cell.poster.layer.cornerRadius = 30
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (frame.width - 10) / 2
        return CGSize(width: width, height: width * 1.5 + 5)    //w*h ratio + 5 spacing between movies
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionPresentMovieDetails(movie: movies[indexPath.row])
    }
    
}



