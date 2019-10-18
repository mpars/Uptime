//
//  AppDelegate.swift
//  Uptime
//
//  Created by mark on 11/10/2019.
//  Copyright © 2019 Mark Parsons. All rights reserved.
//

import Cocoa
import AppKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate{
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    lazy var popover: NSPopover = {
        let popover = NSPopover()
        popover.behavior = .semitransient
        popover.contentViewController = ViewController()
        popover.delegate = self
        
        return popover
    }()
    
    private var detachedWindowControllerLoaded = false
    
    lazy var detachedWindowController: DetachedPopOver = {
        let detachedWindowController = DetachedPopOver(windowNibName: NSNib.Name("DetachedPopOver"))
        detachedWindowController.contentViewController = ViewController()
        self.detachedWindowControllerLoaded = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(detachedWindowWillClose(notification:)), name: NSWindow.willCloseNotification, object: detachedWindowController.window)
        
        return detachedWindowController
    }()
    
    
    var eventMonitor: EventMonitor?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        if let button = statusItem.button {
            button.action = #selector(AppDelegate.togglePopover(_:))
           
        }
        
        
        let mainViewController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "popUpViewController") as! ViewController
        
        Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(AppDelegate.uptime), userInfo: nil, repeats: true)
        self.uptime()
        
        popover.contentViewController = mainViewController
        
        
        eventMonitor = EventMonitor(mask: [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown]) { [weak self] event in
            if let popover = self?.popover {
                if popover.isShown {
                    
                    if popover.isDetached {
                    }else{
                    self?.closePopover(event)
                    }
                }
            }
        }
        eventMonitor?.start()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    func popoverShouldDetach(_ popover: NSPopover) -> Bool {
        return true
    }
    
    func popoverDidDetach(_ popover: NSPopover) {
        //print("popoverDidDetach")
        detachedWindowController.window?.level = .floating
    }
    
    func showPopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            //for vibrantDark appearance
            //popover.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
            eventMonitor?.start()
        }
    }
    
    func closePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func detachableWindow(for popover: NSPopover) -> NSWindow? {
        return detachedWindowController.window
    }
    
    private var customDetachedWindowVisible : Bool {
        get { return detachedWindowControllerLoaded && detachedWindowController.window!.isVisible }
    }
   
    
    @objc func uptime(){
        statusItem.button?.title = (shellCommands.uptime())
        }

    
    @objc func detachedWindowWillClose(notification: NSNotification) {
        
    }
    
   deinit {
        if (detachedWindowControllerLoaded) {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
}


