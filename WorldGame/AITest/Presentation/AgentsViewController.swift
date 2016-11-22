//
//  AgentsViewController.swift
//  WorldGame
//
//  Created by Michael Rommel on 19.11.16.
//  Copyright © 2016 Michael Rommel. All rights reserved.
//

class AgentsViewController: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = TableViewContentDataSource.init()
        
        self.dataSource.setTitle("Policies", forHeaderInSection:0)
        
        let c = TableViewContent(title: "abc", andSubtitle:"def", andStyle:.Normal, andAction:nil)
        self.dataSource.addContent(c, inSection:0)
        
        self.tableView.reloadData()
    }
}

extension AgentsViewController {
    
    
    
}
