//
//  NibRow.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 19/03/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

open class NibRow<SourceType, CellType: TableCell<SourceType>>: Row<SourceType, CellType> {
    
    var nibName: String?
    
    public init(data: SourceType?, cellIdentifier: String?, nibName: String, cellPresenter: BaseCellPresenter<CellType, SourceType>?) {
        super.init(data: data, cellIdentifier: cellIdentifier, cellPresenter: cellPresenter)
        self.nibName = nibName
    }
    
    public init(data: SourceType?, cellIdentifier: String?, nibName: String, configureCell: @escaping (CellType, SourceType) -> Void) {
        super.init(data: data, cellIdentifier: cellIdentifier, configureCell: configureCell)
        self.nibName = nibName
    }
    
    override public func getCell(tableView: UITableView) -> UITableViewCell {
        
        guard let nibName = nibName else {
            fatalError("Nib Name is not set for row : " + String(describing:type(of: self)))
        }
        
        var cell: CellType?
        
        let cellNib = UINib(nibName: nibName, bundle: nil)
        
        if let cellIdentifier = cellIdentifier {
            tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? CellType
        } else {
            cell = cellNib.instantiate(withOwner: nil, options: nil).first as? CellType
        }
        
        if let data = data, cell != nil {
            cellPresenter?.configureCell(cell: cell!, source: data)
        }
        
        return cell ?? UITableViewCell()
    }
}
