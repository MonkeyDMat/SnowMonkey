//
//  Config.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 15/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import UIKit

struct Config {
    struct Layout {
        static let DefaultHeaderHeight = CGFloat(30)
        static let DefaultFooterHeight = CGFloat(30)
    }
    
    struct RowIdentifiers {
        private static let identifierPrefix = "EasyList"
        static let TextRow = identifierPrefix + "TextRow"
    }
}
