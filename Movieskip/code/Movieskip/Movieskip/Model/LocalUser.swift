//
//  LocalUser.swift
//  Movieskip
//
//  Created by marchelmon on 2021-03-09.
//

import Foundation


struct LocalUser {
    
    var watchlist: [Int]
    var excluded: [Int]
    var skipped: [Int]
    
    init(data: [String: [Int]]) {
        self.watchlist = data["watchlist"] ?? []
        self.excluded = data["excluded"] ?? []
        self.skipped = data["skipped"] ?? []
    }
}
