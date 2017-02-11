//
//  Stack.swift
//  MyBarnabot
//
//  Created by VAUTRIN on 05/02/2017.
//  Copyright © 2017 gabrielvv. All rights reserved.
//

import Foundation

struct Stack<Element> {
    var items = [Element]()
    var count : Int {
        get {
            return items.count
        }
    }
    var last : Element? {
        get {
            return items.last
        }
    }
    mutating func push(_ item: Element) {
        items.append(item)
    }
    mutating func pop() -> Element {
        return items.removeLast()
    }
//    func copy() -> Stack<Element> {
//        var stack = Stack<Element>()
//        for it in self.items {
//            stack.items.append(it.copy())
//        }
//        return stack
//    }
}
