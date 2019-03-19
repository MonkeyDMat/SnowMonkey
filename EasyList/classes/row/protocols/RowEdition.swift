//
//  RowEdition.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 19/03/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

@objc public protocol RowEdition {
    @objc optional func isEditable() -> Bool
    @objc optional func getEditingStyle() -> UITableViewCell.EditingStyle
    @objc optional func getTitleForDeleteConfirmation() -> String?
}

protocol RowEditionProvider: class {
    associatedtype ReturnType
    
    var _editable: (() -> Bool)? { get set }
    var _editingStyle: (() -> UITableViewCell.EditingStyle)? { get set }
    var _titleForDeleteConfirmation: (() -> String?)? { get set }
}

extension RowEditionProvider {
    @discardableResult
    public func setEditable(editable: (() -> Bool)?, editingStyle: (() -> UITableViewCell.EditingStyle)? = {return .delete}, titleForDeleteConfirmation: (() -> String?)? = nil) -> ReturnType {
        _editable = editable
        _editingStyle = editingStyle
        _titleForDeleteConfirmation = titleForDeleteConfirmation
        return self as! ReturnType
    }
}
