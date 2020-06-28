//
//  NewPlaceViewController.swift
//  My Places
//
//  Created by Smart Cash on 25.06.2020.
//  Copyright © 2020 Denis Svetlakov. All rights reserved.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    var newPlace: Places?
    var imageIsChanged = false
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet var placeName: UITextField!
    @IBOutlet var placeLocation: UITextField!
    @IBOutlet var placeType: UITextField!
    @IBOutlet var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        tableView.tableFooterView = UIView()
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
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
    func saveNewPlace() {
        let image: UIImage?
        if imageIsChanged {
            image = placeImage.image
        } else {
            image = UIImage(systemName: "photo")
        }
        newPlace = Places (name: placeName.text!,
                           location: placeLocation.text!,
                           type: placeType.text!,
                           image: image,
                           restaurantImage: nil)
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
