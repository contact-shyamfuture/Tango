//
//  ProfileEditVC.swift
//  Tango
//
//  Created by Shyam Future Tech on 18/08/20.
//  Copyright © 2020 Samir Samanta. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

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
        
        headerView.btnHeartOutlet.isHidden = true
        
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
        if userdetails.avatar != nil {
            profileImage.sd_setImage(with: URL(string: userdetails.avatar!))
            if let data = try? Data(contentsOf: URL(string: userdetails.avatar!)!)
            {
                let image: UIImage = UIImage(data: data)!
                userSelectedImage = image
            }
        }
    }
    
    private func configureUI(){
        //topHeaderSet(vc: self)
    }
    
    @IBAction func btnUploadImage(_ sender: Any) {
        selectUserImageAction()
    }
    
    @IBAction func uploadProfileImageBtnAction(_ sender: Any) {
        selectUserImageAction()
    }
    
    func validateUserInputs(user: UpdateProfileParam) -> [String: Any]? {
        return user.toJSON()
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        let param = UpdateProfileParam()
        param.email = userEmail.text
        param.phone = userPhone.text
        param.name = userName.text
        if let params = self.validateUserInputs(user: param) {
            if let img = userSelectedImage {
                let data = img.jpegData(compressionQuality: 0)
                self.requestWith(endUrl: "", imageData: data, parameters: params)
            }else{
                
            }
        }
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
extension ProfileEditVC {
    func requestWith(endUrl: String, imageData: Data?, parameters: [String : Any], onCompletion: ((Any?) -> Void)? = nil, onError: ((Error?) -> Void)? = nil){
        let url = "http://166.62.54.122/swiggy/public/api/user/profile"
        let header = ["X-Requested-With":"XMLHttpRequest" , "Content-Type": "application/json" , "Authorization" : "Bearer " + UserDefaults.standard.string(forKey: PreferencesKeys.userAccessToken)!]
        self.addLoaderView()
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            if let data = imageData{
                multipartFormData.append(data, withName: "avatar", fileName: "filename" , mimeType: "image")
            }
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: header) { (result) in
            switch result{
                
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted * 100)")
                })
                upload.responseJSON { response in
                    upload.responseJSON { response in
                        self.removeLoaderView()
                        guard let result = response.result.value else { return }
                        print("\(result)")
                        let resultDic = result as! Dictionary<String,Any>
                        let status = resultDic["id"] as? Int
                        
                        if status != nil {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    if let err = response.error{
                        onError?(err)
                        return
                    }
                    onCompletion?(nil)
                }
            case .failure(let error):
                self.removeLoaderView()
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
    }
}
