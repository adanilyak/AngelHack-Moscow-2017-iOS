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
    
    @IBOutlet weak var createPhotoButton: UIButton!
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var frameImageView: UIImageView!
    
    var activityView: ActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPhotoButton.setTitle(localize(key: "addPhoto"), for: .normal)
        addMotion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func onCreatePhoto(_ sender: Any) {
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
        
        vc.view.tintColor = defaultTintColor
        
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
    
    func createActivity() {
        activityView = ActivityView(frame: CGRect(x: 0, y: 0, width: 240, height: 75))
        guard let av = activityView else {
            return
        }
        
        view.isUserInteractionEnabled = false
        av.titleLabel.text = localize(key: "analyzing")
        av.activityIndicator.startAnimating()
        av.center = CGPoint(x: view.center.x, y: view.center.y + 50)
        view.addSubview(av)
    }
    
    func algoSuccess(looks: [Look]) {
        view.isUserInteractionEnabled = true
        activityView?.removeFromSuperview()
        performSegue(withIdentifier: "toLooks", sender: looks)
    }
    
    func algoError(text: String) {
        view.isUserInteractionEnabled = true
        activityView?.removeFromSuperview()
        
        let vc = UIAlertController(title: localize(key: "errorTitle"),
                                   message: text,
                                   preferredStyle: .alert)
        vc.view.tintColor = defaultTintColor
        let ok = UIAlertAction(title: localize(key: "errorOk"), style: .cancel, handler: nil)
        vc.addAction(ok)
        present(vc, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLooks" {
            if let vc: PageLooksController = segue.destination as? PageLooksController,
                let looks: [Look] = sender as? [Look] {
                vc.looks = looks
            }
        }
    }
    
    func addMotion() {
        let delta = 15
        
        let verticalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.y",
                                                               type: .tiltAlongVerticalAxis)
        verticalMotionEffect.minimumRelativeValue = -delta
        verticalMotionEffect.maximumRelativeValue = delta
        
        let horizontalMotionEffect = UIInterpolatingMotionEffect(keyPath: "center.x",
                                                                 type: .tiltAlongHorizontalAxis)
        horizontalMotionEffect.minimumRelativeValue = -delta
        horizontalMotionEffect.maximumRelativeValue = delta
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontalMotionEffect, verticalMotionEffect]
        
        frameImageView.addMotionEffect(group)
    }
    
}

extension MainController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            print("\nERROR, can't get image\n")
            picker.dismiss(animated: true, completion: nil)
            return
        }
        
        createActivity()
        
        API().findLooks(image: image,
                        onSuccess: algoSuccess,
                        onError: algoError)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
