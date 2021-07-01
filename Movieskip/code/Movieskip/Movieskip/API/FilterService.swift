//
//  Service.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-13.
//

import Foundation


struct FilterService  {
    
    static var filter: Filter = Filter(genres: K.TMDB_GENRES, minYear: 2000, maxYear: 2021, popular: false, page: 1, totalPages: 100)
        
    static func saveFilter() {
        
        let genres = try! JSONEncoder().encode(filter.genres)
        
        UserDefaults.standard.set(genres, forKey: K.FILTER_GENRES_KEY)
        UserDefaults.standard.set(filter.minYear, forKey: K.FILTER_MINYEAR_KEY)
        UserDefaults.standard.set(filter.maxYear, forKey: K.FILTER_MAXYEAR_KEY)
        UserDefaults.standard.set(filter.popular, forKey: K.FILTER_POPULAR_KEY)
        UserDefaults.standard.set(filter.totalPages, forKey: K.FILTER_TOTAL_PAGES)
        
        if filter.page != 1 { filter.page -= 1 }
        UserDefaults.standard.set(filter.page, forKey: K.FILTER_PAGE_KEY)
        
    }
    
    static func fetchFilter(completion: @escaping(Filter) -> Void) {
        
        if  let genresData = UserDefaults.standard.data(forKey: K.FILTER_GENRES_KEY) {
            filter.genres = try! JSONDecoder().decode([Genre].self, from: genresData)
            filter.minYear = UserDefaults.standard.float(forKey: K.FILTER_MINYEAR_KEY)
            filter.maxYear = UserDefaults.standard.float(forKey: K.FILTER_MAXYEAR_KEY)
            filter.popular = UserDefaults.standard.bool(forKey: K.FILTER_POPULAR_KEY)
            filter.page = UserDefaults.standard.integer(forKey: K.FILTER_PAGE_KEY)
            filter.totalPages = UserDefaults.standard.integer(forKey: K.FILTER_TOTAL_PAGES)
        }
                
        completion(filter)
    }
    
}
