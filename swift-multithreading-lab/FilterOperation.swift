//
//  FilterOperation.swift
//  swift-multithreading-lab
//
//  Created by Lloyd W. Sykes on 4/16/17.
//  Copyright © 2017 Flatiron School. All rights reserved.
//

import Foundation

class FilterOperation: Operation {
    let flatigram: Flatigram
    let filter: String
    
    init(flatigram: Flatigram, filter: String) {
        self.flatigram = flatigram
        self.filter = filter
    }
    
    override func main() {
        if let filteredImage = flatigram.image?.filter(with: filter) {
            self.flatigram.image = filteredImage
        }
    }

}
