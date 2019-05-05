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
    if let window = NSApplication.shared.mainWindow {
      window.contentViewController?.presentAsModalWindow(vc)
    }
  }
  
  @IBAction func clickOpenProject(_ sender: Any) {
    let projectFolder = selectFolderPath(text: "Select Your Project Path");
    if projectFolder != nil {
      do {
        try ProjectManager.shared.openProject(path: projectFolder!)
      } catch let error as NSError {
        errorAlert(title: "Error", text: String(format: "Error: %@", error.localizedDescription));
        return;
      }
    }
  }
  
  @IBAction func clickAddSchema(_ sender: Any) {
    do {
      try ProjectManager.shared.verifyProject();
    } catch let error as NSError {
      errorAlert(title: "Error", text: error.localizedDescription);
      return;
    }
    let storyboard = NSStoryboard(name: "NewSchemaViewController", bundle: nil)
    let identifier = NSStoryboard.SceneIdentifier("NewSchemaViewController")
    let vc = storyboard.instantiateController(withIdentifier: identifier) as! NewSchemaViewController
    if let window = NSApplication.shared.mainWindow {
      window.contentViewController?.presentAsModalWindow(vc)
    }
  }
}

