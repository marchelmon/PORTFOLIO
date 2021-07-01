//
//  Constants.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-12.
//

import Firebase
import UIKit


class K {

    //MARK: - APP Icons, colors and images

    static let MOVIESKIP_ICON: UIImage = #imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysOriginal)
    static let SKIP_ICON = UIImage(systemName: "arrowshape.turn.up.forward.circle")?.withTintColor(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), renderingMode: .alwaysOriginal)
    static let EXCLUDE_ICON = UIImage(systemName: "xmark.circle")?.withTintColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), renderingMode: .alwaysOriginal)
    static let WATCHLIST_ICON = UIImage(systemName: "star.fill")?.withTintColor(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), renderingMode: .alwaysOriginal)

    static let MAIN_COLOR = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)

    //MARK: - Firebase Collection

    static let COLLECTION_USERS = Firestore.firestore().collection("users")

    //MARK: - User defaults

    static let FILTER_GENRES_KEY = "genres"
    static let FILTER_MINYEAR_KEY = "minYear"
    static let FILTER_MAXYEAR_KEY = "maxYear"
    static let FILTER_POPULAR_KEY = "popular"
    static let FILTER_PAGE_KEY = "page"
    static let FILTER_TOTAL_PAGES = "totalPages"

    static let WATCHLIST_IS_TABLE = "tableOrCollection"

    //MARK: - TMDB API

    //TDOD: Ändra sort_by till inget (aka popularity.asc)

    static let TMDB_API_KEY: String = "ab0e29ade2759c5fdac27207fe0ce0b8"
    static let TMDB_DISCOVER_BASE: String = "https://api.themoviedb.org/3/discover/movie?api_key=\(TMDB_API_KEY)&language=en&sort_by=vote_count.desc&include_adult=false&include_video=false"
    static let TMDB_MOVIE_BASE: String = "https://api.themoviedb.org/3/movie/"
    static let TMDB_IMAGE_BASE: String = "https://image.tmdb.org/t/p/w500"

    static let YOUTUBE_STARTING_PATH: String = "https://youtube.com/watch?v="

    static let TMDB_GENRES: [Genre] = [
        Genre(id: 28, name: "Action"),
        Genre(id: 12, name: "Adventure"),
        Genre(id: 16, name: "Animation"),
        Genre(id: 35, name: "Comedy"),
        Genre(id: 80, name: "Crime"),
        Genre(id: 99, name: "Documentary"),
        Genre(id: 18, name: "Drama"),
        Genre(id: 10751, name: "Family"),
        Genre(id: 12, name: "Fantasy"),
        Genre(id: 36, name: "History"),
        Genre(id: 27, name: "Horror"),
        Genre(id: 10402, name: "Music"),
        Genre(id: 9648, name: "Mystery"),
        Genre(id: 10749, name: "Romance"),
        Genre(id: 878, name: "Science Fiction"),
        Genre(id: 10770, name: "TV Movie"),
        Genre(id: 53, name: "Thriller"),
        Genre(id: 10752, name: "War"),
        Genre(id: 37, name: "Western")
    ]

}
