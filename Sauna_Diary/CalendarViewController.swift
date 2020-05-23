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
   
   // MARK: - TableView Delegate
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // 詳細画面に遷移
       self.performSegue(withIdentifier: "toDetail", sender: nil)
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
