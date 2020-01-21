//
//  ViewController.swift
//  ImagePicker
//
//  Created by Alex Paul on 1/20/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var imageObjects = [ImageObject]()
    private let imagePickerController = UIImagePickerController()
    private var selectedImage: UIImage?{
        didSet{
            appendNewPhotoToCollection()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        // set UIImagePickerController delegate as this view controller
        imagePickerController.delegate = self
    }
    
    private func appendNewPhotoToCollection(){
        guard let image = selectedImage,
            // image.jpegData(compressionQuality: 1.0) converts UIImage to Data
            let imageData = image.jpegData(compressionQuality: 1.0) else{
                print("image is nil")
                return
        }
        
        // create an ImageObject using the image selected
        let imageObject = ImageObject(imageData: imageData, date: Date())
        // insert new imageObject into imageObjects
        imageObjects.insert(imageObject, at: 0)
        
        // create an indexPath for insertion into collection view
        let indexPath = IndexPath(row: 0, section: 0)
        
        // insert new cell into collection view
        collectionView.insertItems(at: [indexPath])
    }
    
    
    @IBAction func addPictureButtonPressed(_ sender: UIBarButtonItem) {
        // present an action sheet to the user
        // actions: camera, photo library, cancel
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            [weak self]  alertAction in
            self?.showImageController(isCameraSelected: true)
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default){
            [weak self]  alertAction in
            self?.showImageController(isCameraSelected: false)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // check if camera is available, if camera is not available
        // the app will crash
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    private func showImageController(isCameraSelected: Bool){
        // source type default will be .photolibrary
        imagePickerController.sourceType = .photoLibrary
        if isCameraSelected {
            imagePickerController.sourceType = .camera
        }
        present(imagePickerController, animated: true)
    }
    
}

// MARK: - UICollectionViewDataSource
extension ImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCell else {
            fatalError("could not downcast to an ImageCell")
        }
        let imageObject = imageObjects[indexPath.row]
        cell.configureCell(imageObject: imageObject)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ImagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxWidth: CGFloat = UIScreen.main.bounds.size.width
        let itemWidth: CGFloat = maxWidth * 0.80
        return CGSize(width: itemWidth, height: itemWidth)  }
}

extension ImagesViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // we need to acess the UIIMagePickerController.InfoKey.originalImage key to get the UIIMage that was selected
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            print("image selection failed")
            return
        }
        selectedImage = image
        dismiss(animated: true)
    }
}

//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey : Any]) {
//        // we need to acess the UIIMagePickerController.InfoKey.originalImage key to get the UIIMage that was selected
//        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
//            print("image selection failed")
//            return
//        }
//        selectedImage = image
//        dismiss(animated: true)
//    }


// more here: https://nshipster.com/image-resizing/
// MARK: - UIImage extension
extension UIImage {
    func resizeImage(to width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

