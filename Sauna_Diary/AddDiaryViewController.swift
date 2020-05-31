//
//  AddDiaryViewController.swift
//  Sauna_Diary
//
//  Created by 諸星水晶 on 2020/05/20.
//  Copyright © 2020 諸星水晶. All rights reserved.
//

import UIKit

class AddDiaryViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

   @IBOutlet weak var titleTexitField: UITextField!
   @IBOutlet weak var detailTextView: UITextView!
   @IBOutlet var photoImageView: UIImageView!

   
   override func viewDidLoad() {
       super.viewDidLoad()
       
       titleTexitField.delegate = self
       detailTextView.delegate = self

   }
  
   
   // MARK: - TextField Delegate
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       textField.resignFirstResponder()
       return true
   }
   
   // MARK: - TextView Delegate
   func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
       textView.resignFirstResponder()
       return true
   }
   
   @IBAction func save() {
       if titleTexitField.text != "" {
           if detailTextView.text != "" {
            if photoImageView.image != nil{
                let newDiary = Diary.create()
                newDiary.title = titleTexitField.text!
                newDiary.note = detailTextView.text
                newDiary.photo = photoImageView.image?.jpegData(compressionQuality: 1.0)
                let today = Diary.changeDateType(date: Date())
                newDiary.date = today
                newDiary.save()
                self.navigationController?.popViewController(animated: true)
            }else{
               SimpleAlert.showAlert(viewController: self, title: "写真なし", message: "写真を選んでください", buttonTitle: "OK")
            }
           } else {
               SimpleAlert.showAlert(viewController: self, title: "日記なし", message: "内容を描いてください", buttonTitle: "OK")
           }
       } else {
           SimpleAlert.showAlert(viewController: self, title: "タイトルなし", message: "タイトルを書いてください", buttonTitle: "OK")
       }
       
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
    
    
    @IBAction func onTappedAlbumButton(){
        presentPickerController(sourceType: .photoLibrary)
    }
    
   
}
