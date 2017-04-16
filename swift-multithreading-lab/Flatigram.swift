//
//  Flatigram.swift
//  swift-multithreading-lab
//
//  Created by Lloyd W. Sykes on 4/16/17.
//  Copyright © 2017 Flatiron School. All rights reserved.
//

import UIKit

class Flatigram {
    var image: UIImage?
    var state: ImageState = .unfiltered
}

enum ImageState {
    case filtered
    case unfiltered
}
