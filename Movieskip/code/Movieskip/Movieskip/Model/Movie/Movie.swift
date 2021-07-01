//
//  Movie.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-13.
//

import Foundation
import SwiftyJSON

struct Movie {
    let id: Int
    let title: String
    let rating: Double
    let overview: String
    var posterPath: URL?
    let released: String
    var images = [String]()
    var reviews = [String]()
    var trailer: String?
    var genres = [Genre]()
    var actors = [Actor]()

        
    init(data: JSON) {
        self.id = data["id"].int ?? 0
        self.title = data["title"].string ?? "No title found"
        self.rating = data["vote_average"].double ?? 5.0
        self.released = data["release_date"].string ?? "Not available"
        self.overview = data["overview"].string ?? "No description available"
        self.images = data["images"]["backdrops"].arrayValue.map({ $0["file_path"].string ?? "" })
        self.reviews = data["reviews"]["results"].arrayValue.map({ $0["content"].stringValue })
        
        if let posterString = data["poster_path"].string {
            self.posterPath = URL(string: "\(K.TMDB_IMAGE_BASE)\(posterString)")
        }
        
        let videos = data["videos"]["results"].arrayValue
        self.trailer = videos.count != 0 ? videos[0]["key"].string : nil
        
        if !data["genres"].arrayValue.isEmpty {
            data["genres"].arrayValue.forEach({ value in
                guard let id = value["id"].int else { return }
                guard let name = value["name"].string else { return }
                let genre = Genre(id: id, name: name)
                genres.append(genre)
            })
        }
        
        let cast = data["credits"]["cast"].arrayValue
        if !cast.isEmpty {
            for index in 0...10 {
                if cast.count == index { break }
                guard let name = cast[index]["name"].string else { return }
                guard let photoPath = cast[index]["profile_path"].string else { return }
                let actor = Actor(name: name, photoPath: URL(string: photoPath))
                actors.append(actor)
            }
        }
    }
    
}


