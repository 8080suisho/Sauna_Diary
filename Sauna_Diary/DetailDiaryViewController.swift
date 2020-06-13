//
//  DetailDiaryViewController.swift
//  Sauna_Diary
//
//  Created by 諸星水晶 on 2020/05/20.
//  Copyright © 2020 諸星水晶. All rights reserved.
//

import UIKit

class DetailDairyViewController: UIViewController {
   
   var selectedDiary = Diary()
   
   @IBOutlet weak var detailTextView: UITextView!
   @IBOutlet var photoImageView: UIImageView!
    
    

   override func viewDidLoad() {
       super.viewDidLoad()
       
       self.navigationController?.title = "\(selectedDiary.title)"
       detailTextView.text = selectedDiary.note
       if selectedDiary.photo != nil{
        photoImageView.image = UIImage(data: selectedDiary.photo!)
       }
    
   }
    
    @IBAction func onTappedUploadButton(){
        if photoImageView.image != nil {
            let activityVC = UIActivityViewController(activityItems: [selectedDiary.photo!,"#サ活"], applicationActivities: nil)
            self.present(activityVC,animated: true,completion: nil)
        }else{
            print("画像がありません")
        }
    }
    
    
    
   

}
