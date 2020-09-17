//
//  ImagePickerManager.swift
//  Sihatku
//
//  Created by Shyam Future Tech on 06/03/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIDocumentPickerDelegate {

    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose File", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage,String) -> ())?;

    override init(){
        super.init()
    }

    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage,String) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;

        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let fileAction = UIAlertAction(title: "Camera roll", style: .default){
            UIAlertAction in
            self.openFile()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }

        // Add the actions
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(fileAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            let alertWarning = UIAlertView(title:"Warning", message: "You don't have camera", delegate:nil, cancelButtonTitle:"OK", otherButtonTitles:"")
            alertWarning.show()
        }
    }
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }

    func openFile(){

        let types = [kUTTypePDF,kUTTypeText,kUTTypeRTF,kUTTypeSpreadsheet,kUTTypeBMP,kUTTypePNG,kUTTypeJPEG]
        let importMenu = UIDocumentPickerViewController(documentTypes: types as [String], in: .import)
        if #available(iOS 11.0, *) {
            importMenu.allowsMultipleSelection = true
        }
        importMenu.delegate = self
        //importMenu.modalPresentationStyle = .formSheet
        
        self.viewController?.present(importMenu, animated: true, completion: nil)
    }
    
    private func documentPicker(controller: UIDocumentPickerViewController, didPickDocumentAtURL url: NSURL) {
        if controller.documentPickerMode == UIDocumentPickerMode.import {
            // This is what it should be
            print("URL Path :",url.path!)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    //for swift below 4.2
    //func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    //    picker.dismiss(animated: true, completion: nil)
    //    let image = info[UIImagePickerControllerOriginalImage] as! UIImage
    //    pickImageCallback?(image)
    //}

    // For Swift 4.2+
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        var imgName : String?
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL{
            imgName = imageURL.lastPathComponent
            print("imgName==>\(String(describing: imgName))")
            let imgExtension = imageURL.pathExtension
            print("imgExtension==>\(imgExtension)")
        }
        else
        {
            imgName = "image_1.png"
            let fileManager = FileManager.default
            let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
            let imagePath = documentsPath?.appendingPathComponent(imgName!)
            
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
                let imageData = pickedImage.jpegData(compressionQuality: 0.75)
                try! imageData?.write(to: imagePath!)
                print("imageData==>\(String(describing: imageData))")
            }
            print("documentsPath==>\(String(describing: documentsPath))")
            print("imagePath==>\(String(describing: imagePath))")
        }
        print("prescirptionImgName==>\(imgName)")
        pickImageCallback?(image,imgName!)
    }



    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }

}
