//
//  LeftSideMenu.swift
//  YJGameEngine
//
//  Created by Yujie Liu on 5/4/19.
//  Copyright © 2019 Yujie Liu. All rights reserved.
//

import Cocoa

class LeftSideMenu: NSMenu {
  
  init(presentedItem: Any?) {
    super.init(title: "menu")
    
    let item = NSMenuItem(title: "delete", action: #selector(LeftSideViewController.clickDelete(_:)), keyEquivalent: String(format: "%c", NSEvent.SpecialKey.backspace.rawValue));
    insertItem(item, at: 0);
    item.representedObject = presentedItem;
    
  }
  required init(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
