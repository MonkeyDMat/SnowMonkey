//
//  Store.swift
//  EasyListExample
//
//  Created by mathieu lecoupeur on 08/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import Foundation

class Store {
    var vocation: String
    var name: String
    var isOpened: Bool
    
    init(vocation: String, name: String, isOpened: Bool) {
        self.vocation = vocation
        self.name = name
        self.isOpened = isOpened
    }
}
