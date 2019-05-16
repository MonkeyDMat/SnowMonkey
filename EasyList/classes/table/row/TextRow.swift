//
//  NativeRow.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 17/03/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

public struct TextData {
    public var text: String
    public var detail: String?
    public var style: UITableViewCell.CellStyle
}

public class NativeRow: Row<TextData, TextCell> {
    
    public init(text: String, detail: String? = nil, style: UITableViewCell.CellStyle = .default) {
        super.init(data: TextData(text: text, detail: detail, style: style), cellIdentifier: Config.RowIdentifiers.TextRow) { (cell, data) in
            cell.textLabel?.text = data.text
            cell.detailTextLabel?.text = data.detail
        }
    }
    
    //MARK: - RowType
    public override func getCell(tableView: UITableView) -> UITableViewCell {
        if let cellIdentifier = cellIdentifier,
            let data = data,
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? TextCell {
            
            cellPresenter?.configureCell(cell: cell, source: data)
            
            return cell
        } else {
            if let data = data {
                let cell = TextCell(style: data.style, reuseIdentifier: cellIdentifier)
                
                cellPresenter?.configureCell(cell: cell, source: data)
                
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
}
