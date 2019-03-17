//
//  Section.swift
//  EasyList
//
//  Created by mathieu lecoupeur on 08/07/2018.
//  Copyright © 2018 mathieu lecoupeur. All rights reserved.
//

import Foundation

public class Section<HeaderType: BaseHeader, FooterType: BaseFooter>: BaseSection {
    
    var header: HeaderType?
    var footer: FooterType?
    
    public init(header: HeaderType? = nil, footer: FooterType? = nil) {
        super.init()
        
        self.header = header
        self.header?.section = self
        self.footer = footer
        self.footer?.section = self
    }
    
    public override func getHeader() -> BaseHeader? {
        return header
    }
    
    public override func getFooter() -> BaseFooter? {
        return footer
    }
}
