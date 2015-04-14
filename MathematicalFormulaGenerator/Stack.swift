//
//  Stack.swift
//  MathematicalFormulaGenerator
//
//  Created by Kubota Daisuke on 2015/04/15.
//  Copyright (c) 2015年 Kubota Daisuke. All rights reserved.
//

class Stack<T> {
    var array : [T] = [T]();
    func count() -> Int {
        return array.count;
    }
    
    func push(item: T) {
        array += [item];
    }
    
    func pop() -> T? {
        var item: T? = array.last;
        if (item != nil) {
            array.removeLast();
        }
        return item;
    }
    
    func top() -> T? {
        return array.last;
    }
    
    func toArray() -> [T] {
        return array;
    }
}