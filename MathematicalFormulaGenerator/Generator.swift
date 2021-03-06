//
//  Generator.swift
//  MathematicalFormulaGenerator
//
//  Created by daisuke.kubota on 2015/04/15.
//  Copyright (c) 2015年 daisuke.kubota. All rights reserved.
//

import Foundation

// TODO: 並びだけ変わった重複が存在する
// TODO: 高速化
class Generator {
    
    var _canceled:Bool = false;
    
    var _index:Int = 0;
    
    // 配列と取得したい数字から数式を文字列で取得
    func getMathematicalFormula(numArray: [Int], success:Int) -> [String] {
        _canceled = false;
        var result:[String] = [String]();
        _index = 0;
        generateAllReversePolishNotation(&result, numArray: numArray, rpn: [AnyObject](), numIndex: 0, opeCount: 0, success:success);
        var orderSet = NSOrderedSet(array: result);
        NSLog("count = %d", _index);
        result = orderSet.array as! [String];
        return result;
    }
    
    // 配列からすべての逆ポーランド記法を作成し、計算を行い指定した数値になる数式を結果配列に追加する
    func generateAllReversePolishNotation(inout result: [String], numArray: [Int], rpn: [AnyObject], numIndex:Int, opeCount:Int, success:Int) {
        if (_canceled) {
            return result.removeAll();
        }
        if (numIndex + opeCount >= numArray.count + numArray.count - 1) {
            _index++;
            var str:String = "";
            var cal:Float? = calculateReversePolishNotation(rpn);
            if (cal != nil && abs(cal! - Float(success)) < 0.01) {
                result.append(reversePolishNotationToNormalFromat(rpn));
            }
            
            return;
        }
        if (numIndex - opeCount >= 2) {
            // 数字が2つ以上積まれている場合は演算子をすべて試す
            // 足し算
            generateAllReversePolishNotation(
                &result, numArray: numArray, rpn: rpn + ["+"], numIndex: numIndex, opeCount: opeCount + 1, success: success);
            
            // 引き算
            generateAllReversePolishNotation(
                &result, numArray: numArray, rpn: rpn + ["-"], numIndex: numIndex, opeCount: opeCount + 1, success: success);
            
            // 掛け算
            generateAllReversePolishNotation(
                &result, numArray: numArray, rpn: rpn + ["*"], numIndex: numIndex, opeCount: opeCount + 1, success: success);
            
            // 割り算
            generateAllReversePolishNotation(
                &result, numArray: numArray, rpn: rpn + ["/"], numIndex: numIndex, opeCount: opeCount + 1, success: success);
            
        }
        
        if (numIndex < numArray.count) {
            var localArray:[Int] = numArray;
            for (var i:Int = 0; i < localArray.count; i++) {
                if (localArray[i] >= 0) {
                    let number:Int = localArray[i];
                    var isThrough:Bool = false;
                    for (var j = 0; j < i; j++) {
                        // 前に同じ数字だ存在すると同じパターンを試すことになるので実行しない
                        if (number == localArray[j]) {
                            isThrough = true;
                            break;
                        }
                    }
                    if (!isThrough) {
                        localArray[i] = -1;
                        generateAllReversePolishNotation(
                            &result, numArray: localArray, rpn: rpn + [number], numIndex:numIndex + 1 , opeCount: opeCount, success: success);
                        localArray[i] = number;
                    }
                }
            }
        }
        
    }

    
    // 逆ポーランド記法で入っている配列を計算する
    func calculateReversePolishNotation(rpn: [AnyObject]) -> Float? {
        var stack:Stack<Float> = Stack();
        for obj:AnyObject in rpn {
            if (obj is Int) {
                stack.push(Float(obj as! Int));
            } else if (obj is String) {
                if (stack.count() < 2) {
                    return nil;
                }
                let ope:String = obj as! String;
                let num2:Float! = stack.pop()!;
                let num1:Float! = stack.pop()!;
                if (ope == "+") {
                    var add:Float = num1 + num2;
                    stack.push(add);
                } else if (ope == "-") {
                    var sub:Float = num1 - num2;
                    stack.push(sub);
                } else if (ope == "*") {
                    var mul:Float = num1 * num2;
                    stack.push(mul);
                } else if (ope == "/") {
                    if (num2 == 0) {
                        return nil;
                    }
                    var div = num1 / num2;
                    stack.push(div);
                } else {
                    return nil;
                }
            }
        }
        if (stack.count() == 1) {
            return stack.pop();
        }
        return nil;
    }
    
    // 逆ポーランド記法の配列を通常の数式文字列に変換する
    func reversePolishNotationToNormalFromat(rpn: [AnyObject]) -> String {
        var stack: Stack<AnyObject> = Stack<AnyObject>();
        for obj:AnyObject in rpn {
            stack.push(obj);
        }
        var root:Tree = Tree();
        makeTree(root, stack: stack);
        return treeToString(root, operatorRank:0);
    }
    
    // Treeを文字列に変換する
    func treeToString(tree:Tree, operatorRank:Int) -> String {
        if (tree.key is Int) {
            return String(tree.key as! Int);
        }
        var str:String = "";
        var rank:Int = 0;
        if (tree.key is String) {
            rank = toOperatorRank(tree.key as! String);
        }
        if (tree.left is Tree) {
            let left:Tree = tree.left as! Tree;
            str += treeToString(left, operatorRank:rank);
        }
        if (tree.key is String) {
            let key:String = tree.key as! String;
            str += key;
        }
        if (tree.right is Tree) {
            let right:Tree = tree.right as! Tree;
            str += treeToString(right, operatorRank:rank);
        }
        if (operatorRank >= rank) {
            str = "(" + str + ")";
        }
        
        return str;
    }
    
    // 演算子のランクを返す
    func toOperatorRank(ope:String) -> Int {
        if (ope == "*" || ope == "/") {
            return 2;
        } else if (ope == "+" || ope == "-") {
            return 1;
        }
        return 0;
    }
    
    // ツリーをStackから作成
    func makeTree(tree:Tree, stack:Stack<AnyObject>) {
        if (stack.count() == 0) {
            return;
        }
        var obj:AnyObject! = stack.pop()!;
        if (obj is Int) {
            tree.key = obj;
        } else if (obj is String) {
            var right:Tree = Tree();
            makeTree(right, stack: stack);
            tree.right = right;
            var left:Tree = Tree();
            makeTree(left, stack: stack);
            tree.left = left;
            tree.key = obj;
        }
    }
    
    func isCanceled() -> Bool {
        return _canceled;
    }
    
    func cancel() {
        _canceled = true;
    }
    
}