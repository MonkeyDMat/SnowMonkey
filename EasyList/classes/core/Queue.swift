//
//  Queue.swift
//  EasyList
//
//  Created by Red10 on 24/05/2019.
//  Copyright © 2019 mathieu lecoupeur. All rights reserved.
//

import Foundation

class Queue<Element>: NSCopying {
    
    var elements: [Element]
    
    init(_ elements: [Element]? = nil) {
        self.elements = elements ?? [Element]()
    }
    
    // MARK: - NSCopying
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Queue<Element>()
        for element in elements {
            copy.enqueue(element: element)
        }
        
        return copy
    }
    
    // MARK: - Public Methods
    func enqueue(element: Element) {
        elements.append(element)
    }
    
    func append(queue: Queue<Element>) {
        guard let queueToAppend = queue.copy() as? Queue<Element> else {
            return
        }
        
        while let head = queueToAppend.dequeue() {
            enqueue(element: head)
        }
    }
    
    func append(queue: [Element]) {
        elements.append(contentsOf: queue)
    }
    
    func dequeue() -> Element? {
        if count() != 0 {
            return elements.removeFirst()
        }
        
        return nil
    }
    
    func head() -> Element? {
        return elements.first
    }
    
    func count() -> Int {
        return elements.count
    }
    
    func isEmpty() -> Bool {
        return count() == 0
    }
    
    func clear() {
        elements.removeAll()
    }
    
    func filter(_ isIncluded: (Element) throws -> Bool) rethrows -> Queue<Element> {
        return try Queue<Element>(elements.filter(isIncluded))
    }
    
    func toArray() -> [Element] {
        return elements
    }
}
