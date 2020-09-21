//
//  ProfileEditVC.swift
//  Tango
//
//  Created by Shyam Future Tech on 18/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit

class ProfileEditVC: BaseViewController {

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPhone: UITextField!
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    var userdetails = ProfiledetailsModel()
    
    var imagePath = String()
    var imagePicker = UIImagePickerController()
    var userSelectedImage : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tabBarView.isHidden = true
        headerView.imgLogo.isHidden = true
        headerView.btnBackAction.isHidden = false
        
        userName.text = userdetails.name
        userPhone.text = userdetails.phone
        userPhone.isUserInteractionEnabled = false
        userPhone.textColor = UIColor.lightGray
        userEmail.text = userdetails.email
        imagePicker.delegate = self
        
        profileImage.layer.borderWidth = 0
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
    }
    
    private func configureUI(){
        //topHeaderSet(vc: self)
    }
    
    @IBAction func btnUploadImage(_ sender: Any) {
        selectUserImageAction()
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        
    }
}

extension ProfileEditVC : UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func selectUserImageAction() {
        
        let alert:UIAlertController=UIAlertController(title: nil , message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive)
        {
            UIAlertAction in
        }
        
        //alert.addAction(viewAction)
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x:view.frame.size.width / 2, y: view.frame.size.height,width: 200,height : 200)
        }
        self.present(alert, animated: true, completion: nil)
    }
    // MARK: open camera method
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)){
            
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self .present(imagePicker, animated: true, completion: nil)
            
        }else{
            
            let alertController = UIAlertController(title: commonAlertTitle, message: "Device has no camera", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                (result : UIAlertAction) -> Void in
            }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: open gallary method
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: PickerView Delegate Methods
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        userSelectedImage = selectedImage
        profileImage.image = selectedImage
        dismiss(animated:true, completion: nil)
    }
    
    //MARK: PickerView Delegate Methods
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        print("picker cancel.")
        dismiss(animated: true, completion: nil)
    }
}
