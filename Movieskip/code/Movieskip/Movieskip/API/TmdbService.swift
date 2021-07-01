//
//  TmdbService.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-13.
//

import Foundation
import Alamofire
import SwiftyJSON


struct TmdbService {
    
    static let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    static func fetchMovies(completion: @escaping([Movie]?, Error?) -> Void) {
        
        let urlString = "\(K.TMDB_DISCOVER_BASE)\(FilterService.filter.filterUrlString)"
                        
        FilterService.filter.page += 1

        if let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) {

            AF.request(url).validate().responseJSON { (response) in
                switch response.result {
                case .success(let value):
                                        
                    let data = JSON(value)["results"]
                    
                    FilterService.filter.totalPages = JSON(value)["total_pages"].int ?? 10
                    print("PAge: \(FilterService.filter.page)")
                    
                    let moviesResult = data.arrayValue.map({ Movie(data: $0) })
                    removeAlreadySwiped(allMovies: moviesResult) { newMovies in
                        completion(newMovies, nil)
                    }
                    
                case .failure(let error):
                    completion(nil, error)
                }
            }
        }
    }
    
    
    static func removeAlreadySwiped(allMovies: [Movie], completion: ([Movie]) -> Void) {
        var newMovies = [Movie]()
        var swipedMovies = [Int]()
                        
        if let user = sceneDelegate.user {
            swipedMovies = user.watchlist + user.excluded + user.skipped
        } else if let localUser = sceneDelegate.localUser {
            swipedMovies = localUser.watchlist + localUser.excluded + localUser.skipped
        }
                     
        allMovies.forEach { movie in
        
            if swipedMovies.contains(movie.id) { print("Movie excluded: \(movie.id)"); return }
            newMovies.append(movie)
        }
        completion(newMovies)
    }
    
    static func fetchMovieWithDetails(withId id: Int, completion: @escaping(Movie) -> Void) {
        let url = "\(K.TMDB_MOVIE_BASE)\(id)?api_key=\(K.TMDB_API_KEY)&append_to_response=credits,videos,images,reviews"
                                
        AF.request(url).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                
                let movie = Movie(data: JSON(value))
                completion(movie)

            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}

