//
//  MainController.swift
//  AngelHackMoscow
//
//  Created by Alexander Danilyak on 01/07/2017.
//  Copyright © 2017 Alexander Danilyak. All rights reserved.
//

import UIKit
import MobileCoreServices

class MainController: UIViewController {
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func onCameraButton(_ sender: Any) {
        let vc = UIAlertController(title: localize(key: "cameraOrLibrary"),
                                   message: localize(key: "cameraOrLibraryDescription"),
                                   preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: localize(key: "camera"),
                                   style: .default,
                                   handler: { [unowned self] action in
                                    self.present(self.createImagePicker(sourceType: .camera),
                                                 animated: true,
                                                 completion: nil)
        })
        
        let library = UIAlertAction(title: localize(key: "library"),
                                    style: .default,
                                    handler: { [unowned self] action in
                                        self.present(self.createImagePicker(sourceType: .photoLibrary),
                                                     animated: true,
                                                     completion: nil)
        })
        
        let cancel = UIAlertAction(title: localize(key: "cancel"), style: .cancel, handler: nil)
        
        vc.addAction(camera)
        vc.addAction(library)
        vc.addAction(cancel)
        
        present(vc, animated: true, completion: nil)
    }
    
    func createImagePicker(sourceType: UIImagePickerControllerSourceType) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = sourceType
        picker.mediaTypes = [kUTTypeImage as String]
        
        return picker
    }
    
}

extension MainController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("\nERROR, can't get image\n")
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        imageView.image = image
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
