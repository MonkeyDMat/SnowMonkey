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
    
    public init(text: String, detail: String?, style: UITableViewCell.CellStyle) {
        self.text = text
        self.detail = detail
        self.style = style
    }
}

public class NativeRow: Row<TextData, NativeCell> {
    
    public init(id: String, text: String, detail: String? = nil, style: UITableViewCell.CellStyle = .default) {
        super.init(id: id, data: TextData(text: text, detail: detail, style: style), cellIdentifier: nil) { (cell, data) in
            cell.textLabel?.text = data.text
            cell.detailTextLabel?.text = data.detail
        }
    }
    
    //MARK: - RowType
    public override func getCell(tableView: UITableView) -> UITableViewCell {
        if let data = data {
            let cell = NativeCell(style: data.style, reuseIdentifier: cellIdentifier)
            
            cellPresenter?.configureCell(cell: cell, source: data)
            
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
