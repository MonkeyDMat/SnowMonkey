//
//  RowLayout.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 19/03/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

@MainActor
@objc public protocol RowLayout {
    @objc optional func rowHeight() -> CGFloat
    @objc optional func estimatedRowHeight() -> CGFloat
    @objc optional func selectionStyle() -> UITableViewCell.SelectionStyle
}
@MainActor
protocol RowLayoutProvider {
    associatedtype ReturnType
    
    var _height: ((RowType) -> CGFloat)? { get set }
    var _estimatedHeight: ((RowType) -> CGFloat)? { get set }
    var _selectionStyle: ((RowType) -> UITableViewCell.SelectionStyle)? { get set }
}
