//
//  ViewController.swift
//  BusyCalendar
//
//  Created by Kelsey Law on 2017-09-09.
//  Copyright © 2017 Kelsey Law. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var year: UILabel!

    
    //MARK: Colour Attributes
    
    let outsideMonthDateColor = UIColor(colorWithHexValue: 0x999999)
    let monthColor = UIColor.white
    let selectedMonthDateColor = UIColor(colorWithHexValue: 0x333333)
    let todayDateSelectedViewColor = UIColor(colorWithHexValue: 0xA97E0A)
    
    //MARK: Attributes
    
    let formatter = DateFormatter()
    let todaysDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Allows for Multiple Selections
        
        calendarView.allowsMultipleSelection = true
        
        // Scrolls to current date at load
        
        calendarView.scrollToDate( Date() , animateScroll:false)
        
        
        setupCalendarView()
        
    }
    
    func setupCalendarView() { // puts cells directly next to each other, preventing selected view cutoff
        
        // Setup calendar spacing
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        // Setup labels
        calendarView.visibleDates {(visibleDates) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        
        
    }
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.month.text = self.formatter.string(from: date)
    }
    
    func handleCellTextColor(view: JTAppleCell?, cellstate: CellState) {
        guard let validCell = view as? DateCell else {return}
        
        let todaysDate = Date()
        
        formatter.dateFormat = "yyyy MM dd"
        
        let todaysDateString = formatter.string(from:todaysDate)
        let monthDateString = formatter.string(from: cellstate.date)
        
        if todaysDateString == monthDateString {
            validCell.dateLabel.textColor = todayDateSelectedViewColor
            
        } else {
            if cellstate.isSelected {
                validCell.dateLabel.textColor = selectedMonthDateColor
            } else {
                if cellstate.dateBelongsTo == .thisMonth {
                    validCell.dateLabel.textColor = monthColor
                } else {
                    validCell.dateLabel.textColor = outsideMonthDateColor
                }
            }
        }

    }
    
    func handleCellSelected(view:JTAppleCell?, cellState: CellState) {
        guard let validCell = view as? DateCell else {return}
    
        
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
        }
        else {
            validCell.selectedView.isHidden = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    // scrolls back to today's month when button is pressed
    
    @IBAction func todayButton(_ sender: Any) {
                calendarView.scrollToDate( Date() )
    }
    
}

extension ViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2016 01 01")!
        let endDate = formatter.date(from: "2020 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        
        return parameters
    }
}

extension ViewController: JTAppleCalendarViewDelegate {
    
    //Display the cell
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        
        cell.dateLabel.text = cellState.text
        
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellstate: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellstate: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
        handleCellTextColor(view: cell, cellstate: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsOfCalendar(from: visibleDates)
        
    }
}

// Adds hex input to UIColor

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

