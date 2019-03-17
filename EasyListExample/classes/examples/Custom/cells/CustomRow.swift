//
//  CustomRow.swift
//  EasyListExample
//
//  Created by mathieu lecoupeur on 17/03/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

class CustomRow: Row<String, CustomCell> {
    
    public init(text: String) {
        super.init(data: text, cellIdentifier: "CustomRow") { (cell, data) in
            cell.label?.text = text
        }
    }
    
    override public func getCell(tableView: UITableView) -> UITableViewCell {
        if let cellIdentifier = cellIdentifier,
            let data = data,
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CustomCell {
            
            cellPresenter?.configureCell(cell: cell, source: data)
            
            return cell
        } else {
            if let data = data,
                let cellIdentifier = cellIdentifier {
                
                let cellNib = UINib(nibName: "CustomCell", bundle: nil)
                tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
                if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CustomCell {
                    cellPresenter?.configureCell(cell: cell, source: data)
                    return cell
                }
                
                return UITableViewCell()
            } else {
                return UITableViewCell()
            }
        }
    }
}
