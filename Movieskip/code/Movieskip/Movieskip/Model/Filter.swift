//
//  Filter.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-13.
//

import Foundation

struct Filter {
    var genres: [Genre]
    var minYear: Float
    var maxYear: Float
    var popular: Bool
    var page: Int
    var totalPages: Int
    
    var minYearString: String {
        let string = "\(String(Int(minYear) + 1))-01-01"
        return string
    }
    
    var maxYearString: String {
        let string = "\(String(Int(maxYear) + 1))-01-01"
        return string
    }
    
    var filterUrlString: String {
        var requestString: String = "release_date.gte=\(minYearString)&release_date.lte=\(maxYearString)&page=\(page)"
        requestString.append(popular ? "&vote_average.gte=7" : "")
        requestString.append(popular ? "&vote_count.gte=500" : "&vote_count.gte=100")
        
        if genres.count != 0 {
            requestString.append("&with_genres=")
            self.genres.forEach { genre in
                requestString.append("\(genre.id)|")
            }
        }
        return requestString
    }
    
}




