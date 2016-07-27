//
//  LinkedListNode.swift
//  Shapes
//
//  Created by Rodrigo Labronici on 28/05/16.
//  Copyright © 2016 Rodrigo Labronici. All rights reserved.
//

public class LinkedListNode<T> {
    var value: T
    var next: LinkedListNode?
    weak var previous: LinkedListNode?
    
    public init(value: T) {
        self.value = value
    }
}