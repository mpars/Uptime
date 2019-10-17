//
//  shellCommands.swift
//  Uptime
//
//  Created by mark on 11/10/2019.
//  Copyright © 2019 Mark Parsons. All rights reserved.
//

import Foundation
import Cocoa

class shellCommands {
    
    static func uptime() -> String {
     
        // Create a Task instance
        let task = Process()
        task.launchPath="/usr/bin/uptime"
        //task.arguments=["-h"]
        // Create a Pipe and make the task
        // put all the output there
        let pipe = Pipe()
        task.standardOutput = pipe
        // Launch the task
        task.launch()
        // Get the data
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
        // Split up the output string
        let uptimeOutput    = output! as String
        //let uptimeOutput = "10:17 up 10 days, 11:02, 4 users, load averages: 0.34 0.29 0.24"
        let uptimeOutputArr = uptimeOutput.components(separatedBy: ",")
        
        let part1 = uptimeOutputArr[0]
        
        // strip out the time at beginning of string
        
        let start = part1.index(part1.startIndex, offsetBy: 9)
        let end = part1.index(part1.endIndex, offsetBy: 0)
        let time = part1[start..<end]
        if time.contains(":") {
            let timeArr = time.components(separatedBy: ":")
            let substring = "↑" + timeArr[0] + "hr "+timeArr[1]
            return substring
        }else{
            let substring = "↑" + part1[start..<end]
      return substring
        }
      
    }
    
    static func uptimeDetail(command: String) -> String {
        let task = Process()
        task.launchPath="/bin/bash"
        //uptime | sed -E 's/^[^,]*up *//; s/, *[[:digit:]]* users.*//; s/mins/minutes/; s/([[:digit:]]+):0?([[:digit:]]+)/\\1 hours, \\2 minutes/'
        // uptime | sed -E 's/^[^,]*up *//; s/, *[[:digit:]]* users.*//; s/mins/minutes/; s/([[:digit:]]+):0?([[:digit:]]+)/\1 hours, \2 minutes/'
        task.arguments = ["-c", command]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        return output! as String
        
    }
    
    
}
