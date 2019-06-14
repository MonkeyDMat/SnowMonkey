//
//  IndexPathExtensions.swift
//  EasyList
//
//  Created by Red10 on 11/06/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import Foundation

extension IndexPath {
    init?(row: Int?, section: Int?) {
        guard let row = row, let section = section else {
            return nil
        }
        
        self = IndexPath(row: row, section: section)
    }
}
