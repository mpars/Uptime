//
//  ViewController.swift
//  Uptime
//
//  Created by mark on 11/10/2019.
//  Copyright © 2019 Mark Parsons. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    
    

    
    @IBOutlet var fullUptimeInfo: NSTextView!

    @IBOutlet weak var uptimeButton: NSButton!
    @IBOutlet weak var rebootsButton: NSButton!
    @IBOutlet weak var shutdownsButton: NSButton!
    @IBOutlet weak var aboutButton: NSButton!
    
    var timer = Timer()
    
    override func viewWillAppear() {
        super.viewWillAppear()
        getMoreUptimeInfo()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup timer for uptime info refresh
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getMoreUptimeInfo), userInfo: nil, repeats: true)
        
        fullUptimeInfo.font = NSFont.systemFont(ofSize: 13)
        //optionsMenuButton.menu = optionsMenu

    }
    override func viewWillDisappear() {
      
    }
    override var representedObject: Any? {
        didSet {
        }
    }


    @IBAction func quitButtonClicked(_ sender: Any) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func aboutButtonClicked(_ sender: Any) {
            timer.invalidate()
            fullUptimeInfo.string = "↑\nUptime v0.1.0\ngithub.com/mpars/uptime \n(c) 2019 Mark Parsons\n\nReleased under an MIT License \n--\nIcons created by dindin@G41T-R3 Released under a GNU GPL 3.0 licence. dindin_hernawan@yahoo.com"
        
    }
        
        @IBAction func uptimeMenuItemClicked(_ sender: Any) {
           getMoreUptimeInfo()
        // Start timer again
            fullUptimeInfo.font = NSFont.systemFont(ofSize: 13)
            if timer.isValid {  }else{
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.getMoreUptimeInfo), userInfo: nil, repeats: true)
       }
        
        
    }
    
    @IBAction func shutdownsItemClicked(_ sender: Any) {
        // sed 's/\( \)*/\1/g'  -- replaces multiple spaces with single space
        var shutdownOutput = shellCommands.uptimeDetail(command: "last shutdown | sed 's/\\( \\)*/\\1/g'")
        if timer.isValid {
            timer.invalidate()
        }
        shutdownOutput = shutdownOutput.replacingOccurrences(of: "shutdown ~ ", with: "")
        fullUptimeInfo.string = "System shutdowns:\n\n" + shutdownOutput
        
    }
    
    @IBAction func rebootsItemClicked(_ sender: Any) {
        var rebootOutput = shellCommands.uptimeDetail(command: "last reboot | sed 's/\\( \\)*/\\1/g'")
        if timer.isValid {
            timer.invalidate()
        }
        rebootOutput = rebootOutput.replacingOccurrences(of: "reboot ~ ", with: "")
            fullUptimeInfo.string = "System Reboots:\n\n" + rebootOutput
    }
    
    
    
    @objc func getMoreUptimeInfo() {
        //get days/hours/mins
        let sedOutput = shellCommands.uptimeDetail(command: "uptime | sed -E 's/^[^,]*up *//; s/, *[[:digit:]]* user.*//; s/mins/mins/; s/([[:digit:]]+):0?([[:digit:]]+)/\\1 hrs, \\2 mins/'")
        //get full uptime output for processing
        let uptimeOutput = shellCommands.uptimeDetail(command: "uptime")
        let uptimeOutputArr = uptimeOutput.components(separatedBy: ",")
        var loads = ""
        var users = ""
        //guard let loads = uptimeOutputArr[3] else { let loads = uptimeOutputArr[2] }
        
        if uptimeOutputArr.count == 3 {
            users = uptimeOutputArr[1]
            loads = uptimeOutputArr[2]
        }else if uptimeOutputArr.count == 4 {
            users = uptimeOutputArr[2]
            loads = uptimeOutputArr[3]
            
        }
        
        //let loadsArr = loads.components(separatedBy: " ")
        var usersArr = users.components(separatedBy: " ")
        var loadsArr = loads.components(separatedBy: " ")
        loadsArr[5] = loadsArr[5].trimmingCharacters(in: CharacterSet.newlines)
        
        fullUptimeInfo.string = sedOutput + usersArr[1] + " users logged in" + "\nLoad averages \n" + loadsArr[3] + "\t - 1 min\n" + loadsArr[4] + "\t - 5 mins\n" + loadsArr[5] + "\t - 15 mins"
    }
    
    
    
   
}



