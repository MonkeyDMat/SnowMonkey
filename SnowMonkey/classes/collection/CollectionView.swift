//
//  CollectionView.swift
//  EasyList
//
//  Created by Red10 on 10/04/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import Foundation
import UIKit

open class CollectionView: UICollectionView {
    public var source: CollectionSource? {
        didSet {
            delegate = source
            dataSource = source
        }
    }
}
