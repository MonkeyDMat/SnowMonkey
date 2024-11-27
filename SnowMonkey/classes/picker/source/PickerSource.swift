//
//  PickerSource.swift
//  SnowMonkey
//
//  Created by Red10 on 04/03/2021.
//  Copyright © 2021 mathieu lecoupeur. All rights reserved.
//

import UIKit

@objc public protocol PickerSourceDelegate {
    func didSelectRow(picker: PickerView, rowId: String, value: String, inComponent component: Int)
}

open class PickerSource: NSObject {
    
    var components: [PickerComponent] = []
    
    public var delegate: PickerSourceDelegate?
    public weak var picker: PickerView?
    
    public init(picker: PickerView, delegate: PickerSourceDelegate? = nil) {
        self.picker = picker
        self.delegate = delegate
        
        super.init()
        
        self.picker?.source = self
    }
    
    public func setup(components: [PickerComponent]) {
        self.components = components
        self.picker?.reloadAllComponents()
    }
    
    public func setup(rows: [PickerRow], selectedRowIds: [String] = []) {
        Task { @MainActor [weak self] in
            guard let self = self else { return }
            self.components = [PickerComponent(layout: PickerComponentLayout.default, rows: rows)]
            for (component, selectedRowId) in selectedRowIds.enumerated() {
                if let rowIndex = rows.firstIndex(where: { (row) -> Bool in
                    return row.id == selectedRowId
                }) {
                    self.picker?.selectRow(rowIndex, inComponent: component, animated: false)
                }
            }
            self.picker?.reloadAllComponents()
        }
    }
}
