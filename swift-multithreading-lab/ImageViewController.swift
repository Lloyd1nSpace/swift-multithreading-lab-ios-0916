//
//  ImageViewController.swift
//  swift-multithreading-lab
//
//  Created by Ian Rahman on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

//MARK: Image View Controller

class ImageViewController : UIViewController {
    
    var scrollView: UIScrollView!
    var imageView = UIImageView()
    let picker = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView()
    let filtersToApply = ["CIBloom",
                          "CIPhotoEffectProcess",
                          "CIExposureAdjust"]
    
    var flatigram = Flatigram()
    
    @IBOutlet weak var filterButton: UIBarButtonItem!
    @IBOutlet weak var chooseImageButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        setUpViews()
    }
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        selectImage()
    }
    
    @IBAction func filterButtonTapped(_ sender: AnyObject) {
        if flatigram.state == .unfiltered {
            startProcess()
        } else {
            presentFilteredAlert()
        }
    }
    
}

extension ImageViewController {
    func filterImage(with completion: @escaping (Bool) -> ()) {
        
        let queue = OperationQueue()
        queue.name = "Image Filtration Queue"
        queue.qualityOfService = .userInitiated
        queue.maxConcurrentOperationCount = 1
        
        for filter in filtersToApply {
            let filterOperation = FilterOperation(flatigram: flatigram, filter: filter)
            filterOperation.completionBlock =  { [weak self] in
                guard let strongSelf = self else { return }
                if queue.operationCount == 0 {
                    strongSelf.flatigram.state = .filtered
                    completion(true)
                }
            }
            queue.addOperation(filterOperation)
            print("Added FilterOperation with \(filter) to \(queue.name!)")
        }
    }
    
    func startProcess() {
        filterButton.isEnabled = false
        chooseImageButton.isEnabled = false
        activityIndicator.startAnimating()
        filterImage { [weak self] (filtered) in
            guard let strongSelf = self else { return }
            OperationQueue.main.addOperation({
                filtered ? print("Image successfully filtered") : print("Image filtering did not complete")
                strongSelf.imageView.image = strongSelf.flatigram.image
                strongSelf.activityIndicator.stopAnimating()
                strongSelf.filterButton.isEnabled = true
                strongSelf.chooseImageButton.isEnabled = true
            })
        }
    }
}
