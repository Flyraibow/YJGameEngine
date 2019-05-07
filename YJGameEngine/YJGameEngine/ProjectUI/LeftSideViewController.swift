//
//  LeftSideViewController.swift
//  YJGameEngine
//
//  Created by Yujie Liu on 5/3/19.
//  Copyright © 2019 Yujie Liu. All rights reserved.
//

import Cocoa

enum DefinedCategory {
  case topSchema
  case topType
  case schema
  case type
  case schemaField
  case schemaData
  case schemaFieldDetail
  case undefined
}

let TopDefinedCategoryTypes : [DefinedCategory : String] = [
  DefinedCategory.topSchema : "Schema",
  DefinedCategory.topType : "type",
  DefinedCategory.schemaField : "Fields",
  DefinedCategory.schemaData : "Data",
  DefinedCategory.undefined : "undefined"
]

let TopDefinedCategory = [
  Cell(name: TopDefinedCategoryTypes[DefinedCategory.topSchema], type: DefinedCategory.topSchema),
  Cell(name: TopDefinedCategoryTypes[DefinedCategory.topType], type: DefinedCategory.topType),
]


class Cell: NSObject {
  let name: String
  let type: DefinedCategory
  let children : [Cell]
  var parentCell: Cell?
  
  init(name: String?, type: DefinedCategory, parentCell:Cell? = nil) {
    self.name = name ?? "undefined"
    self.type = type
    if type == DefinedCategory.schema {
      self.children = [
        Cell(name: TopDefinedCategoryTypes[DefinedCategory.schemaField], type: DefinedCategory.schemaField),
        Cell(name: TopDefinedCategoryTypes[DefinedCategory.schemaData], type: DefinedCategory.schemaData),
      ]
    } else {
      self.children = [];
    }
    self.parentCell = parentCell;
    super.init();
    for child in self.children {
      child.parentCell = self;
    }
  }
}

class LeftSideViewController: NSViewController, NSOutlineViewDataSource, NSOutlineViewDelegate , NSMenuItemValidation, NSMenuDelegate {
  
  
  @IBOutlet weak var _outlineView: NSOutlineView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(dataRefresh),
                                           name: NSNotification.Name(rawValue: YJEngineObserverSchemaChange),
                                           object: nil);
  }
  
  @objc func dataRefresh() -> Void {
    _outlineView.reloadData();
  }
  
  func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int
  {
    if item == nil {
      return TopDefinedCategory.count;
    } else {
      if let feed = item as? Cell {
        if feed.type == DefinedCategory.topSchema {
          return ProjectManager.shared.getAllSchemas().count;
        } else if feed.type == DefinedCategory.schemaField {
          let schema = ProjectManager.shared.getSchema(schemaName: feed.parentCell!.name);
          return schema?.fieldMap.count ?? 0
        } else {
          return feed.children.count;
        }
      }
    }
    return 0;
  }

  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any
  {
    if item == nil {
      return TopDefinedCategory[index];
    } else {
      if let feed = item as? Cell {
        if feed.type == DefinedCategory.topSchema {
          let schemaList = ProjectManager.shared.getAllSchemas();
          return Cell(name: schemaList[index].name, type: DefinedCategory.schema, parentCell: feed);
        } else if feed.type == DefinedCategory.schemaField {
          let schema = ProjectManager.shared.getSchema(schemaName: feed.parentCell!.name);
          if schema != nil {
            let fields = schema!.getAllFields();
            return Cell(name: fields[index].fieldName, type: DefinedCategory.schemaFieldDetail, parentCell: feed);
          }
        } else {
          return feed.children[index];
        }
      }
    }
    return Cell(name: "error", type: DefinedCategory.undefined);
  }

  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool
  {
    let cell = item as? Cell
    if cell != nil {
      if cell!.type == DefinedCategory.topSchema ||
        cell!.type == DefinedCategory.topType ||
        cell!.type == DefinedCategory.schemaField
        || cell!.children.count > 0 {
        return true;
      }
    }
    return false;
  }
  
  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    var view: NSTableCellView?
    if let feed = item as? Cell {
      view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "FeedCell"), owner: self) as? NSTableCellView
      if let textField = view?.textField {
        textField.stringValue = feed.name
      }
    }
    return view;
  }
  
  func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
    let cell : Cell? = menuItem.representedObject as? Cell;
    if cell != nil && (cell!.type == DefinedCategory.schema || cell!.type == DefinedCategory.schemaFieldDetail) {
      return true;
    }
    return false;
  }
  
  func menuNeedsUpdate(_ menu: NSMenu) {
    let row = _outlineView.clickedRow
    let cell = _outlineView.item(atRow: row);
    
    guard row != -1 else { return }
    for item in menu.items {
      item.representedObject = cell
    }
  }
  
  @IBAction func clickDelete(_ menuItem: NSMenuItem) {
    let cell : Cell? = menuItem.representedObject as? Cell;
    if cell != nil {
      if cell!.type == DefinedCategory.schema {
        if (selectionAlert(title: "Warning", text: String(format: "Are you sure to delete this schema : %@", cell!.name))) {
          // delete the schema
          do {
            try ProjectManager.shared.deleteSchema(schemaName: cell!.name)
          } catch let error as NSError {
            errorAlert(title: "Error", text: String(format: "Failed delete schema: %@", error.localizedDescription));
            return;
          }
        }
      } else if cell!.type == DefinedCategory.schemaFieldDetail {
        let schema = ProjectManager.shared.getSchema(schemaName: cell!.parentCell!.parentCell!.name);
        if (selectionAlert(title: "Warning", text: String(format: "Are you sure to delete this field : %@ from %@", cell!.name, schema!.name))) {
          // delete the field
          do {
            try schema?.deleteField(fieldName: cell!.name);
          } catch let error as NSError {
            errorAlert(title: "Error", text: String(format: "Failed delete schema: %@", error.localizedDescription));
            return;
          }
        }
      }
    }
  }
}
