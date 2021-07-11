//
//  ImagePickerController.swift
//  NBP-Baseball App
//
//  Created by iOS System on 20/07/20.
//  Copyright © 2020 MAC. All rights reserved.
//

import UIKit
import Foundation
import AVKit
import MobileCoreServices


class ImagePickerController: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    lazy var picker = UIImagePickerController();
        var alert       = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        var viewControllers   : UIViewController?
        var pickImageCallback : ((UIImage) -> ())?;
        var openCameraOnly    : Bool?
        var cameraFront       : Bool?
        var controller = UIImagePickerController()
        let videoFileName = "/video.mp4"
        override init(){
            super.init()
        }
        
        func pickImage(_ viewController: UIViewController,isCamraFront:Bool, _ callback: @escaping ((UIImage) -> ())) {
            pickImageCallback = callback;
            self.viewControllers = viewController;
            picker.delegate = self
            cameraFront = isCamraFront
            if openCameraOnly ?? false
            {
                self.openCamera()
            }
            else{
                let cameraAction = UIAlertAction(title: "Camera", style: .default){
                    UIAlertAction in
                    self.openCamera()
                }
                let galleryAction = UIAlertAction(title: "Gallery", style: .default){
                    UIAlertAction in
                    self.openGallery()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
                    UIAlertAction in
                }
                
                // Add the actions
                alert.addAction(cameraAction)
                alert.addAction(galleryAction)
                alert.addAction(cancelAction)
                alert.popoverPresentationController?.sourceView = self.viewControllers!.view
                viewController.present(alert, animated: true, completion: nil)
            }
            
        }
        func openCamera(){
            alert.dismiss(animated: true, completion: nil)
            if(UIImagePickerController .isSourceTypeAvailable(.camera)){
                picker.sourceType = .camera
                picker.modalPresentationStyle = .fullScreen
             
                if cameraFront ?? true{
                picker.cameraDevice = UIImagePickerController.isCameraDeviceAvailable(.front) ? .front : .rear
                }
                self.viewControllers!.present(picker, animated: true, completion: nil)
                
           }
   
        }
        func openGallery(){
            alert.dismiss(animated: true, completion: nil)
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.modalPresentationStyle = .fullScreen
            self.viewControllers!.present(picker, animated: true, completion: nil)
        }
        
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true, completion: nil)
        }
        
    
          func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
              picker.dismiss(animated: true, completion: nil)
              guard let image = info[.originalImage] as? UIImage else {
                  fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
              }
              pickImageCallback?(image)
          }
        
        
        
        @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
        }
           
}

