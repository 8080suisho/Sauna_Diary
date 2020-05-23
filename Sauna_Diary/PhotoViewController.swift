//
//  PhotoViewController.swift
//  Sauna_Diary
//
//  Created by 諸星水晶 on 2020/05/22.
//  Copyright © 2020 諸星水晶. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    @IBOutlet var photoImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func presentPickerController(sourceType:UIImagePickerController.SourceType){
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            self.present(picker,animated: true,completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey: Any]) {
        self.dismiss(animated: true,completion: nil)
        
        photoImageView.image = info[.originalImage]as?UIImage
    }

    
    func drawText(image:UIImage)->UIImage{
        let text = "#サ活"
        
        let textFontAttributes = [
            NSAttributedString.Key.font: UIFont(name:"Arial",size:120)!,
            NSAttributedString.Key.foregroundColor:UIColor.red
        ]
        
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(in:CGRect(x:0, y:0, width: image.size.width,height: image.size.height))
        
        let margin: CGFloat = 5.0
        let textRect = CGRect(x: margin, y: margin, width: image.size.width, height: image.size.height - margin)
        
        text.draw(in: textRect,withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    
    @IBAction func onTappedCameraButton(){
           presentPickerController(sourceType: .camera)
       }
       
       @IBAction func onTappedAlbumButton(){
           presentPickerController(sourceType: .photoLibrary)
       }
       
    @IBAction func onTappedTagButton(){
        if photoImageView.image != nil{
            photoImageView.image = drawText(image: photoImageView.image!)
        }else{
            print("画像がありません")
        }
    }
    
   
    
    @IBAction func onTappedUploadButton(){
        if photoImageView.image != nil {
            let activityVC = UIActivityViewController(activityItems: [photoImageView.image!,"#PhotoMaster"], applicationActivities: nil)
            self.present(activityVC,animated: true,completion: nil)
        }else{
            print("画像がありません")
        }
    }
    
    
    
    
}

