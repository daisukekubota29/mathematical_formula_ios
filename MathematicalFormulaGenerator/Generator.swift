//
//  Generator.swift
//  MathematicalFormulaGenerator
//
//  Created by Kubota Daisuke on 2015/04/14.
//  Copyright (c) 2015年 Kubota Daisuke. All rights reserved.
//

import UIKit

struct Generator {
    static func ganarate(array: [Int]) -> String? {
        return nil;
    }
    
    
    private static func calculation(numbers: [Int], operators: [Int]) -> Float? {
        if (numbers.count != operators.count + 1) {
            // 数字の数と演算子の数が合わない場合は0を返す
            return nil;
        }
        var result:Float = Float(numbers[0]);
        for (var i = 0; i < operators.count; i++) {
            switch (operators[i]) {
            case 0:
                // +
                result += Float(numbers[i + 1]);
                break;
            case 1:
                // -
                result -= Float(numbers[i + 1]);
                break;
            case 2:
                // *
                result *= Float(numbers[i + 1]);
                break;
            case 3:
                // /
                if (numbers[i + 1] == 0) {
                    return nil;
                }
                result /= Float(numbers[i + 1]);
                break;
            default:
                return nil;
            }
        }
        return result;
    }
    
    static func toReversePorlishNotation(numbers: [Int], operators: [Int]) -> [AnyObject]? {
        var result:[AnyObject] = [AnyObject]();
        
        var total:[AnyObject] = [AnyObject]();
        total.append(numbers[0]);
        for (var i = 0; i < operators.count; i++) {
            total.append(toOperatorString(operators[i])!);
            total.append(numbers[i + 1]);
        }
        
        var tmp:Stack<String> = Stack();
        
        for obj in total {
            if (obj is Int) {
                NSLog("num = %d", obj as! Int);
                result.append(obj);
            } else if (obj is String) {
                NSLog("ope = %@", obj as! String);
                if (tmp.count() == 0) {
                    tmp.push(obj as! String);
                } else {
                    while (tmp.count() > 0) {
                        if (operationRank(obj as! String) > operationRank(tmp.top()!)) {
                            result.append(tmp.pop()!);
                        } else {
                            tmp.push(obj as! String);
                            break;
                        }
                    }
                }
            }
        }
        while (tmp.count() > 0) {
            result.append(tmp.pop()!);
        }
        
//        result.push(numbers[0]);
        
//        for (var i = 0; i < operators.count; i++) {
//            var operatorString:String? = toOperatorString(operators[i]);
//            if (operatorString == nil) {
//                return nil;
//            }
//            
//            while (tmp.count() > 0) {
//                var lastOperatorString:String? = tmp.top();
//                if (operationRank(lastOperatorString!) < operationRank(operatorString!)) {
//                        result.push(lastOperatorString!);
//                        var pop:String? = tmp.pop();
//                } else {
//                    break;
//                }
//            }
//            
//            result.push(numbers[i + 1]);
//            tmp.push(operatorString!);
//            
//            
//        }
//        
//        while (tmp.count() > 0) {
//            var obj = tmp.pop();
//            if (obj != nil) {
//                result.push(obj!);
//            }
//        }
        
        return result;
    }
    
    static func toString(array: [AnyObject]!) -> String {
        var str: String = "";
        for obj in array {
            str += String(stringInterpolationSegment: obj);
        }
        return str;
    }
    
    static func operationRank(operationString: String) -> Int {
        if (operationString == "*" || operationString == "/") {
            return 4;
        }
        return 5;
    }
    
    static func toOperatorString(ope: Int) -> String? {
        switch (ope) {
        case 0:
            return "+";
        case 1:
            return "-";
        case 2:
            return "*";
        case 3:
            return "/";
        default:
            return nil;
        }
    }
}
