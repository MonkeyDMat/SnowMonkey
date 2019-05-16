//
//  RowLayout.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 19/03/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

@objc public protocol RowLayout {
    @objc optional func rowHeight() -> CGFloat
    @objc optional func estimatedRowHeight() -> CGFloat
    @objc optional func selectionStyle() -> UITableViewCell.SelectionStyle
}

protocol RowLayoutProvider: class {
    associatedtype ReturnType
    
    var _height: ((RowType) -> CGFloat)? { get set }
    var _estimatedHeight: ((RowType) -> CGFloat)? { get set }
    var _selectionStyle: ((RowType) -> UITableViewCell.SelectionStyle)? { get set }
}

extension RowLayoutProvider {
    @discardableResult
    public func setRowHeight(_ height: ((RowType) -> CGFloat)?) -> ReturnType {
        _height = height
        return self as! ReturnType
    }
    
    @discardableResult
    public func setRowEstimatedHeight(_ estimatedHeight: ((RowType) -> CGFloat)?) -> ReturnType {
        _estimatedHeight = estimatedHeight
        return self as! ReturnType
    }
    
    @discardableResult
    public func setRowSelectionStyle(_ selectionStyle: ((RowType) -> UITableViewCell.SelectionStyle)?) -> ReturnType {
        _selectionStyle = selectionStyle
        return self as! ReturnType
    }
}
