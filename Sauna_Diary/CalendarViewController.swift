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
import CalculateCalendarLogic

class CalendarViewController: UIViewController,FSCalendarDelegateAppearance {
    

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    // 祝日判定を行い結果を返すメソッド(True:祝日)
    func judgeHoliday(_ date : Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)

        // 祝日判定を行う日にちの年、月、日を取得
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)

        // CalculateCalendarLogic()：祝日判定のインスタンスの生成
        let holiday = CalculateCalendarLogic()

        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }

    //曜日判定(日曜日:1 〜 土曜日:7)
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }

    // 土日や祝日の日の文字色を変える
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする（祝日は赤色で表示する）
        if self.judgeHoliday(date){
            return UIColor.red
        }

        //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {   //日曜日
            return UIColor.red
        }
        else if weekday == 7 {  //土曜日
            return UIColor.blue
        }

        return nil
    }
   
    
    
    
    
    
    var anyImage = UIImage(named: "LiT.png")
    
    //画像をつける関数
    func calendar(_ calendar: FSCalendar!, imageFor date: NSDate!) -> UIImage! {
        return anyImage
    }
    
    
    
    
    
    

    
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
                
                diaryArray.remove(at: indexPath.row)
                
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
