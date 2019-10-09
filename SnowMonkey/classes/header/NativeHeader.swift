//
//  NativeHeader.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 15/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import UIKit

public class NativeHeader: BaseHeader {
    var title: String
    var height: CGFloat?
    
    public init(title: String, height: CGFloat? = nil) {
        self.title = title
        self.height = height
        
        super.init(frame: CGRect(x: 10, y: 10, width: 10, height: 10))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - HeaderLayout
    public func headerHeight() -> CGFloat {
        return height ?? Config.Layout.DefaultHeaderHeight
    }
}
