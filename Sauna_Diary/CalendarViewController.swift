//
//  CalendarViewController.swift
//  Sauna_Diary
//
//  Created by 諸星水晶 on 2020/05/20.
//  Copyright © 2020 諸星水晶. All rights reserved.
//

import UIKit
import FSCalendar
import Realm
import RealmSwift

class CalendarViewController: UIViewController {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            do{
                let realm = try Realm()
                try realm.write {
                    realm.delete(diaryArray[indexPath.row])
                }
                
                diaryArray.removeLast()
                
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
                        }catch{
                        }
                }
    }

   var diaryArray: [Diary] = []
   
   @IBOutlet weak var calendar: FSCalendar!
   @IBOutlet weak var diaryTitleTableView: UITableView!
   
   override func viewDidLoad() {
       super.viewDidLoad()
       
       calendar.delegate = self
       calendar.dataSource = self
       
       configureTableView()
       
       diaryArray = Diary.search(date: Date())
       
   }
   
   override func viewWillAppear(_ animated: Bool) {
       diaryArray = Diary.search(date: Date())
       diaryTitleTableView.reloadData()
   }
   
  
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "toDetail" {
           let detailDiaryViewController = segue.destination as! DetailDairyViewController
           let selectedIndex = diaryTitleTableView.indexPathForSelectedRow!
           detailDiaryViewController.selectedDiary = diaryArray[selectedIndex.row]
       }
   }
   
   // Private
   func configureTableView() {
       //dataSourceとdelegateメソッドが使えるように。
       diaryTitleTableView.delegate = self
       diaryTitleTableView.dataSource = self
       
       //セルの高さを30.0で固定
       diaryTitleTableView.rowHeight = 30.0
       
       //余白を消す
       diaryTitleTableView.tableFooterView = UIView()
   }
   
   
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
   
   // MARK: - TableView DataSource
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return diaryArray.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "diaryCell")!
       
       cell.textLabel?.text = diaryArray[indexPath.row].title
       
       return cell
   }
   
}

extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegate {
   // MARK: - FSCalendar Delegate
   func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
       //日付選択時に呼ばれるメソッド
       diaryArray = Diary.search(date: date)
       diaryTitleTableView.reloadData()
       
   }

}
