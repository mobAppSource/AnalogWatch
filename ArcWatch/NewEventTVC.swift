//
//  NewEventTVC.swift
//  ArcWatch
//
//  Created by LandCruiser on 2/16/16.
//  Copyright © 2016 LandCruiser. All rights reserved.
//

import UIKit
import EventKit

class NewEventTVC: UITableViewController, UITextFieldDelegate{

    
    @IBOutlet weak var titleLbl: UITextField!
    @IBOutlet weak var startLbl: UILabel!
    @IBOutlet weak var startPicker: UIDatePicker!
    
    
    @IBOutlet weak var endLbl: UILabel!
    @IBOutlet weak var endPicker: UIDatePicker!
    ///
    var startPickerHidden = true
    var endPickerHidden = true
    let pickerCellSize: CGFloat = 250
    var stDate: NSDate!
    var enDate: NSDate!
    
    @IBAction func eventSetBtnTapped(sender: AnyObject) {
        let eventStore = EKEventStore()
        if self.titleLbl.text == ""{
            
        }else{
            if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
                eventStore.requestAccessToEntityType(.Event, completion: {
                    granted, error in
                    self.createEvent(eventStore, title: self.titleLbl.text!, startDate: self.stDate, endDate: self.enDate)
                })
            } else {
                self.createEvent(eventStore, title: self.titleLbl.text!, startDate: self.stDate, endDate: self.enDate)
            }
        }
        
    }
    @IBAction func datePickerChanged(sender: AnyObject) {
        let timeStyle = NSDateFormatter()
        timeStyle.timeStyle = .ShortStyle
        if sender as! NSObject == self.startPicker{
            self.startLbl.text = timeStyle.stringFromDate(self.startPicker.date)
            self.stDate = self.startPicker.date
            print("Start Date Picker: \(self.startPicker.date)")
        }else{
            self.endLbl.text = timeStyle.stringFromDate(self.endPicker.date)
            self.enDate = self.endPicker.date
            print("End Date Picker: \(self.endPicker.date)")
        }
    }
    //event add in calendar
    // Creates an event in the EKEventStore. The method assumes the eventStore is created and
    // accessible
    func createEvent(eventStore: EKEventStore, title: String, startDate: NSDate, endDate: NSDate) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.saveEvent(event, span: .ThisEvent)
//            savedEventId = event.eventIdentifier
        } catch {
            print("Bad things happened")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialization of datePicker
        self.initDatePicker()
        //
        //
        toggleStartDatePicker()
        toggleEndDatePicker()
        
                self.titleLbl.delegate = self
        //Define the dismissing the keyboard after tapped other place of screen.
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
    }
    
    func initDatePicker(){
        let cuDateTime = NSDate()
        self.startPicker.datePickerMode = .Time
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        self.startPicker.date = dateFormatter.dateFromString(cuDateTime.time)!
        self.startPicker.minimumDate = cuDateTime
        self.startPicker.minuteInterval = 5
        
        
        
        self.endPicker.datePickerMode = .Time
        self.endPicker.minimumDate = cuDateTime
        self.endPicker.date = dateFormatter.dateFromString(cuDateTime.time)!
        print("NSDatePicker: \(dateFormatter.dateFromString(cuDateTime.time)!)")
        self.endPicker.minuteInterval = 5
        self.startLbl.text = cuDateTime.time
        self.endLbl.text = cuDateTime.time

    }
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    
    //Hidden and show of date Picker
    func toggleStartDatePicker() {

        self.startPicker.hidden = self.startPickerHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    func toggleEndDatePicker() {

        self.endPicker.hidden = self.endPickerHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    //Text field delegate
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.titleLbl.resignFirstResponder()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    // tableView cell did be selected by user.
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row
        {
        case 0:
            self.startPickerHidden = true
            self.toggleStartDatePicker()
            self.endPickerHidden = true
            self.toggleEndDatePicker()
        case 1:
            self.startPickerHidden = !self.startPickerHidden
            self.toggleStartDatePicker()
            self.endPickerHidden = true
            self.toggleEndDatePicker()
        case 3:
            self.startPickerHidden = true
            self.toggleStartDatePicker()
            self.endPickerHidden = !self.endPickerHidden
            self.toggleEndDatePicker()
        
        default:
            self.startPickerHidden = true
            self.toggleStartDatePicker()
            self.endPickerHidden = true
            self.toggleEndDatePicker()
        }
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 44
        }else if indexPath.row == 1{
            return 44
        }else if indexPath.row == 2{
            if self.startPickerHidden{
                return 0
            }
            self.pickerCellSize
        }else if indexPath.row == 3{
            return 44
        }else if indexPath.row == 4{
            if self.endPickerHidden{
                return 0
            }
            self.pickerCellSize
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
       return 1
    }


}
