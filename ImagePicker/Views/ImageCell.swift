//
//  ImageCell.swift
//  ImagePicker
//
//  Created by Alex Paul on 1/20/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

// step 1: creating custom delegation
protocol ImageCellDelegate: AnyObject {
    // AnyObject requires ImageCellDelegate only works with class types
    
    // list required functions, initializers, vartiables
    func didLongPress(_ imageCell: ImageCell)
}

class ImageCell: UICollectionViewCell {
    
  
  @IBOutlet weak var imageView: UIImageView!
    
    // step 2: creating custom delegation - define optional delegate variable
    weak var delegate: ImageCellDelegate?
    
    // setup long press gesture recognizer
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer()
        gesture.addTarget(self, action: #selector(longPressAction(gesture:)))
        return gesture
    }()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = 20.0
    backgroundColor = .orange
    addGestureRecognizer(longPressGesture)
  }
    
    // function gets called when long press is activated
    @objc
    private func longPressAction(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            gesture.state = .cancelled
            print("long press activated")
            
            // step 3: creating custom delegation - explicitly use
            // delegate object to notify of any updates e.g
            // notifying the ImagesViewController when the user long presses on the cell
            delegate?.didLongPress(self)
            // cell.delegate
            // imagesViewController.didLongPress(:)

        }
        
    }
    
    
    public func configureCell(imageObject: ImageObject) {
        guard let image = UIImage(data: imageObject.imageData) else{
            return
        }
        imageView.image = image
    }
}
