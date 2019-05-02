//
//  AppDelegate.swift
//  YJGameEngine
//
//  Created by Yujie Liu on 5/1/19.
//  Copyright © 2019 Yujie Liu. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



  func applicationDidFinishLaunching(_ aNotification: Notification) {
    // Insert code here to initialize your application
  }

  func applicationWillTerminate(_ aNotification: Notification) {
    // Insert code here to tear down your application
  }

  @IBAction func clickNewProject(_ sender: Any) {
    let storyboard = NSStoryboard(name: "NewProjectWindow", bundle: nil)
    let identifier = NSStoryboard.SceneIdentifier("NewProjectViewController")
    let vc = storyboard.instantiateController(withIdentifier: identifier) as! NewProjectViewController
    NSLog("%@", vc)
    if let window = NSApplication.shared.mainWindow {
      window.contentViewController?.presentAsModalWindow(vc)
    }
  }
  
  @IBAction func clickOpenProject(_ sender: Any) {
  }
}

