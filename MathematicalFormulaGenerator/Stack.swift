//
//  Stack.swift
//  MathematicalFormulaGenerator
//
//  Created by daisuke.kubota on 2015/04/15.
//  Copyright (c) 2015年 daisuke.kubota. All rights reserved.
//

import Foundation

class Stack<T> {
    var array : [T] = [T]();
    func count() -> Int {
        return array.count;
    }
    
    func push(item: T) {
        array.append(item);
    }
    
    func pop() -> T? {
        if (array.count > 0) {
            return array.removeLast();
        }
        return nil;
    }
    
    func top() -> T? {
        return array.last;
    }
    
    func toArray() -> [T] {
        return array;
    }
}