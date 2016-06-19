//
//  ViewController.swift
//  ArcLog
//
//  Created by LandCruiser on 2/16/16.
//  Copyright © 2016 LandCruiser. All rights reserved.
//

import UIKit
import EventKit





class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    
    var myEvents: [MyEvent!] = []

    
    @IBOutlet weak var analogClockView: ClockView!
   
    
    func initEvents(){
        self.myEvents = []
    }
    
    let eventStore = EKEventStore()
    var calendars: [EKCalendar]?
    
    @IBOutlet weak var eventTableView: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        self.analogClockView.start()
        self.initEvents()
        self.loadCalendars()
        self.eventTableView.reloadData()
    }
    override func viewWillDisappear(animated: Bool) {
        self.analogClockView.stop()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventTableView.dataSource = self
        self.eventTableView.delegate = self
        
        checkCalendarAuthorizationStatus()
        self.initAnalogClock()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        
        switch (status) {
        case EKAuthorizationStatus.NotDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case EKAuthorizationStatus.Authorized:
            // Things are in line with being able to show the calendars in the table view
            loadCalendars()
            refreshTableView()
        case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied: break
            // We need to help them give us permission
            
        }
    }
    func refreshTableView() {
        eventTableView.hidden = false
        eventTableView.reloadData()
    }
    
    func requestAccessToCalendar() {
        eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
            (accessGranted: Bool, error: NSError?) in
            
            if accessGranted == true {
                dispatch_async(dispatch_get_main_queue(), {
                    self.loadCalendars()
                    self.refreshTableView()
                })
            } else {
                
            }
        })
    }
    
    func loadCalendars() {
        self.calendars = eventStore.calendarsForEntityType(EKEntityType.Event)
        let calendars = eventStore.calendarsForEntityType(.Event)

        let cuTime = NSDate().time.componentsSeparatedByString(":")

        print("Current: \(cuTime)::\(NSDate().time)")
        let remainderSec: Int!
        if Int(cuTime[0])!-12>0{
            remainderSec = 24*3600 - 3600*(Int(cuTime[0])!-12) - 60*Int(cuTime[1])!
        }else{
            remainderSec = 24*3600 - 3600*Int(cuTime[0])! - 60*Int(cuTime[1])!+3600
        }
        
        for calendar in calendars {
            
            let startDate = NSDate()
            let endDate = NSDate(timeIntervalSinceNow: Double(remainderSec))
            let predicate = eventStore.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: [calendar])
            let events = eventStore.eventsMatchingPredicate(predicate)
            
            for event in events {
                let newEvent: MyEvent = MyEvent(title: event.title, start: event.startDate, end: event.endDate, eventID: event.eventIdentifier, selected: false)
                myEvents.append(newEvent)
            }
            
        }
        if self.myEvents.count == 0{
            self.eventTableView.hidden = true
        }
    }

    // Removes an event from the EKEventStore. The method assumes the eventStore is created and
    // accessible
    func deleteEvent(eventStore: EKEventStore, eventIdentifier: String) {
        let eventToRemove = eventStore.eventWithIdentifier(eventIdentifier)
        if (eventToRemove != nil) {
            do {
                try eventStore.removeEvent(eventToRemove!, span: .ThisEvent)
            } catch {
                print("Bad things happened")
            }
        }
    }

    @IBAction func btnTapped(sender: AnyObject) {
        
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myEvents.count
    }
    var lastSelectedIndexPath: NSIndexPath!
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        print("Selected: \(indexPath.row)")
        if indexPath.row == self.lastSelectedIndexPath?.row{
            if self.myEvents[indexPath.row].selected{
                print("(old,new): (\(self.lastSelectedIndexPath.row), \(indexPath.row))")
                let oldCell = tableView.cellForRowAtIndexPath(indexPath)
                oldCell?.accessoryType = .None
                self.lastSelectedIndexPath = indexPath
                self.myEvents[indexPath.row] = MyEvent(title: self.myEvents[indexPath.row].title, start: self.myEvents[indexPath.row].start, end: self.myEvents[indexPath.row].end, eventID: self.myEvents[indexPath.row].eventID, selected: false)
            }else{
                print("(old,new): (\(self.lastSelectedIndexPath?.row), \(indexPath.row))")
                let newCell = tableView.cellForRowAtIndexPath(indexPath)
                newCell?.accessoryType = .Checkmark
                lastSelectedIndexPath = indexPath
                self.myEvents[indexPath.row] = MyEvent(title: self.myEvents[indexPath.row].title, start: self.myEvents[indexPath.row].start, end: self.myEvents[indexPath.row].end, eventID: self.myEvents[indexPath.row].eventID, selected: true)
            }
        }else{
            if self.myEvents[indexPath.row].selected{
                print("(old,new): (\(self.lastSelectedIndexPath.row), \(indexPath.row))")
                let oldCell = tableView.cellForRowAtIndexPath(indexPath)
                oldCell?.accessoryType = .None
                self.lastSelectedIndexPath = indexPath
                self.myEvents[indexPath.row] = MyEvent(title: self.myEvents[indexPath.row].title, start: self.myEvents[indexPath.row].start, end: self.myEvents[indexPath.row].end, eventID: self.myEvents[indexPath.row].eventID, selected: false)
            }else{
                print("(old,new): (\(self.lastSelectedIndexPath?.row), \(indexPath.row))")
                let newCell = tableView.cellForRowAtIndexPath(indexPath)
                newCell?.accessoryType = .Checkmark
                lastSelectedIndexPath = indexPath
                self.myEvents[indexPath.row] = MyEvent(title: self.myEvents[indexPath.row].title, start: self.myEvents[indexPath.row].start, end: self.myEvents[indexPath.row].end, eventID: self.myEvents[indexPath.row].eventID, selected: true)
            }
        }
        //Draw arc view on analog clock
        let startStr = NSDate2IntArray(myEvents[indexPath.row].start)
        var startH = Int(startStr[0])
        let startM = Int(startStr[1])
        
        let endStr = NSDate2IntArray(myEvents[indexPath.row].end)
        var endH = Int(endStr[0])
        let endM = Int(endStr[1])
        
        if startH >= 12{
            startH = startH! - 12
            endH = endH! - 12
        }
        let startArc = CGFloat(startH!)/12+CGFloat(startM!)/720
        let endArc = CGFloat(endH!)/12+CGFloat(endM!)/720
        self.drawArcOnClock(indexPath.row, startArc: startArc, endArc: endArc)
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = eventTableView.dequeueReusableCellWithIdentifier("eventCell")
        cell!.textLabel!.text = self.myEvents[indexPath.row].title
        
//        let startD = NSCalendar.currentCalendar().component(.Day, fromDate: self.startDates[indexPath.row])
        let startH = NSCalendar.currentCalendar().component(.Hour, fromDate: self.myEvents[indexPath.row].start)
        let startM = NSCalendar.currentCalendar().component(.Minute, fromDate: myEvents[indexPath.row].start)
        
//        let endD = NSCalendar.currentCalendar().component(.Day, fromDate: self.endDates[indexPath.row])
        let endH = NSCalendar.currentCalendar().component(.Hour, fromDate: myEvents[indexPath.row].end)
        let endM = NSCalendar.currentCalendar().component(.Minute, fromDate: myEvents[indexPath.row].end)
        
        
        
        cell!.detailTextLabel!.text = "\(startH):\(startM) - \(endH):\(endM)"
        return cell!
    }
    //
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            self.deleteEvent(self.eventStore, eventIdentifier: self.myEvents[indexPath.row].eventID)
            self.initEvents()
            self.loadCalendars()
            self.eventTableView.reloadData()
        }
    }
    // MARK: - Analog clock displaying.
    
    func initAnalogClock(){

        self.analogClockView.setClockBackgroundImage(UIImage(named: "clockc.png")?.CGImage)
        self.analogClockView.setHourHandImage(UIImage(named: "rHourHand.png")?.CGImage)
        self.analogClockView.setMinHandImage(UIImage(named: "rMinHand.png")?.CGImage)
        self.analogClockView.setSecHandImage(UIImage(named: "rSecondHand.png")?.CGImage)
    }
    //Draw arc according to the period between start and end
    var arcView0: CircleGraphView!
    var arcView1: CircleGraphView!
    var arcView2: CircleGraphView!
    var arcView3: CircleGraphView!
    var arcView4: CircleGraphView!
    var arcView: CircleGraphView!
    func drawArcOnClock(eIndex: Int, startArc: CGFloat, endArc: CGFloat){
        if !self.myEvents[eIndex].selected{
            switch eIndex{
            case 0:
//                self.arcView0.removeFromSuperview()
                self.arcView0.hidden = true
            case 1:
                self.arcView1.hidden = true
            case 2:
                self.arcView2.hidden = true
            case 3:
                self.arcView3.hidden = true
            case 4:
                self.arcView4.hidden = true
            default:
                break
            }
        }else{
            switch eIndex{
            case 0:
                
                self.arcView0 = CircleGraphView(frame: CGRect(x: 0, y: 0, width: self.analogClockView.frame.width, height: self.analogClockView.frame.height))
                self.arcView0.backgroundColor = UIColor.clearColor()
                self.arcView0.arcBackgroundColor = UIColor.clearColor()
                self.arcView0.startArc = startArc
                self.arcView0.endArc = endArc
                self.arcView0.arcWidth = 5
                self.arcView0.arcColor = UIColor.redColor()
                self.analogClockView.addSubview(arcView0)
                self.arcView0.hidden = false
            case 1:
                
                self.arcView1 = CircleGraphView(frame: CGRect(x: 0, y: 0, width: self.analogClockView.frame.width, height: self.analogClockView.frame.height))
                self.arcView1.backgroundColor = UIColor.clearColor()
                self.arcView1.arcBackgroundColor = UIColor.clearColor()
                self.arcView1.startArc = startArc
                self.arcView1.endArc = endArc
                self.arcView1.arcWidth = 5
                self.arcView1.arcColor = UIColor.greenColor()
                self.analogClockView.addSubview(arcView1)
                self.arcView1.hidden = false
            case 2:
                
                self.arcView2 = CircleGraphView(frame: CGRect(x: 0, y: 0, width: self.analogClockView.frame.width, height: self.analogClockView.frame.height))
                self.arcView2.backgroundColor = UIColor.clearColor()
                self.arcView2.arcBackgroundColor = UIColor.clearColor()
                self.arcView2.startArc = startArc
                self.arcView2.endArc = endArc
                self.arcView2.arcWidth = 5
                self.arcView2.arcColor = UIColor.blueColor()
                self.analogClockView.addSubview(arcView2)
                self.arcView2.hidden = false
            case 3:
                
                self.arcView3 = CircleGraphView(frame: CGRect(x: 0, y: 0, width: self.analogClockView.frame.width, height: self.analogClockView.frame.height))
                self.arcView3.backgroundColor = UIColor.clearColor()
                self.arcView3.arcBackgroundColor = UIColor.clearColor()
                self.arcView3.startArc = startArc
                self.arcView3.endArc = endArc
                self.arcView3.arcWidth = 5
                self.arcView3.arcColor = UIColor.orangeColor()
                self.analogClockView.addSubview(arcView3)
                self.arcView3.hidden = false
            case 4:
                
                self.arcView4 = CircleGraphView(frame: CGRect(x: 0, y: 0, width: self.analogClockView.frame.width, height: self.analogClockView.frame.height))
                self.arcView4.backgroundColor = UIColor.clearColor()
                self.arcView4.arcBackgroundColor = UIColor.clearColor()
                self.arcView4.startArc = startArc
                self.arcView4.endArc = endArc
                self.arcView4.arcWidth = 5
                self.arcView4.arcColor = UIColor.purpleColor()
                self.analogClockView.addSubview(arcView4)
                self.arcView4.hidden = false
            default:
                break
            }
        }
    }
    
}


