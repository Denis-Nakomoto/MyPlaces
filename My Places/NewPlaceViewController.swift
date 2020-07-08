//
//  NewPlaceViewController.swift
//  My Places
//
//  Created by Smart Cash on 25.06.2020.
//  Copyright © 2020 Denis Svetlakov. All rights reserved.
//

import UIKit
import Cosmos

class NewPlaceViewController: UITableViewController {
    var imageIsChanged = false
    var currentPlace: Places!
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet var placeName: UITextField!
    @IBOutlet var placeLocation: UITextField!
    @IBOutlet var placeType: UITextField!
    @IBOutlet var saveButton: UIBarButtonItem!
    @IBOutlet var ratingControl: RatingController!
    @IBOutlet var cosmosView: CosmosView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
    }
    
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cameraImage = UIImage(systemName: "camera")
        let photoImage = UIImage(systemName: "photo")
        
        if indexPath.row == 0 {
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
                self.cooseImagePicker(source: .camera)
            }
           
            cameraAction.setValue(cameraImage, forKey: "image")
            cameraAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photoAction = UIAlertAction(title: "Photolibrary", style: .default) { _ in
                self.cooseImagePicker(source: .photoLibrary)
            }
            photoAction.setValue(photoImage, forKey: "image")
            photoAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(cameraAction)
            actionSheet.addAction(photoAction)
            actionSheet.addAction(cancelAction)
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    func savePlace() {
        let image: UIImage?
        if imageIsChanged {
            image = placeImage.image
        } else {
            image = UIImage(systemName: "photo")
        }
        let imageData = image?.pngData()
        let newPlace = Places(name: placeName.text!, location: placeLocation.text, type: placeType.text, imageData: imageData, rating: Double(cosmosView.rating))
        
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace.rating = newPlace.rating
            }
        } else {
           StorageManager.saveObject(newPlace)
        }
        
    }
    
    private func setupEditScreen () {
        if currentPlace != nil {
            setupNavigationBar()
            imageIsChanged = true
        guard let data = currentPlace?.imageData, let image = UIImage(data: data) else {return}
        placeImage.image = image
        placeImage.contentMode = .scaleAspectFill
        placeName.text = currentPlace?.name
        placeLocation.text = currentPlace?.location
        placeType.text = currentPlace?.type
        cosmosView.rating = currentPlace.rating
            
        }
        
    }
    
    private func setupNavigationBar () {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        } else {}
        saveButton.isEnabled = true
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
    }
    
}

extension NewPlaceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc private func textFieldChanged() {
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func cooseImagePicker (source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        imageIsChanged = true
        dismiss(animated: true)
    }
}
