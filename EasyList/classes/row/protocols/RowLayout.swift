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
    
    var _height: (() -> CGFloat)? { get set }
    var _estimatedHeight: (() -> CGFloat)? { get set }
    var _selectionStyle: (() -> UITableViewCell.SelectionStyle)? { get set }
}

extension RowLayoutProvider {
    @discardableResult
    public func setRowHeight(_ height: (() -> CGFloat)?) -> ReturnType {
        _height = height
        return self as! ReturnType
    }
    
    @discardableResult
    public func setRowEstimatedHeight(_ estimatedHeight: (() -> CGFloat)?) -> ReturnType {
        _estimatedHeight = estimatedHeight
        return self as! ReturnType
    }
    
    @discardableResult
    public func setRowSelectionStyle(_ selectionStyle: (() -> UITableViewCell.SelectionStyle)?) -> ReturnType {
        _selectionStyle = selectionStyle
        return self as! ReturnType
    }
}
