//
//  StoreCollectionCell.swift
//  EasyList
//
//  Created by Red10 on 16/05/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import UIKit

class StoreCollectionItem: CollectionItem<Store, StoreCollectionCell> {
}

class StoreCollectionCell: CollectionCell<Store> {
    @IBOutlet weak var name: UILabel!
}
