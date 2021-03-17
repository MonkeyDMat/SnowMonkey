//
//  PickerView.swift
//  SnowMonkey
//
//  Created by Red10 on 04/03/2021.
//  Copyright © 2021 mathieu lecoupeur. All rights reserved.
//

import UIKit

open class PickerView: UIPickerView {
    var id: String?
    
    public var source: PickerSource? {
        didSet {
            delegate = source
            dataSource = source
        }
    }
}
