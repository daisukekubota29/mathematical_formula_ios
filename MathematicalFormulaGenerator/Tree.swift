//
//  Tree.swift
//  MathematicalFormulaGenerator
//
//  Created by daisuke.kubota on 2015/04/15.
//  Copyright (c) 2015年 daisuke.kubota. All rights reserved.
//

import Foundation

class Tree {
    var _key:AnyObject?;
    var key:AnyObject? {
        get {
            return _key;
        }
        set(newValue) {
            _key = newValue;
        }
    }
    var _left:AnyObject?;
    var left:AnyObject? {
        get {
            return _left;
        }
        set(newValue) {
            _left = newValue;
        }
    }
    var _right:AnyObject?;
    var right:AnyObject? {
        get {
            return _right;
        }
        set(newValue) {
            _right = newValue;
        }
    }
    init() {
    }
}