//
//  ViewController.swift
//  storageTesr
//
//  Created by AA on 9/6/22.
//

import UIKit
import Firebase
import FirebaseStorage
import SDWebImage


class ViewController: UIViewController {
    
    var imagePicker = UIImagePickerController()

    
    
    @IBOutlet weak var selectedImage: UIImageView!
    @IBOutlet weak var fetchedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
    }
    @IBAction func didSelectImage(_ sender: Any) {
           present(imagePicker, animated: true)
    }
    
    @IBAction func didSelectUploadToStorage(_ sender: Any) {
        guard let imageData = selectedImage.image?.jpegData(compressionQuality: 0.5) else {
            return
        }
        let imageFileName = UUID().uuidString
        let storeReference = Storage.storage().reference(withPath: imageFileName)
        storeReference.putData(imageData, metadata: nil) { storageMetadata, error in
            if let error = error {
                print("error while uploading image \(error)")
                return
            }
            storeReference.downloadURL { imageUrl, error in
                if let error = error {
                    print("error while downloading URL Image \(error)")
                    return
                }
                
                if let imageUrl = imageUrl {
                    self.fetchedImage.sd_setImage(with: imageUrl)
                }
            }
        }
    }
    
}

extension ViewController: UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let selectedImage = info[.originalImage] as? UIImage {
            self.selectedImage.image = selectedImage
        }
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
