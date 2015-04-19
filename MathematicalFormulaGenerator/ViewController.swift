//
//  ViewController.swift
//  MathematicalFormulaGenerator
//
//  Created by daisuke.kubota on 2015/04/15.
//  Copyright (c) 2015年 daisuke.kubota. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onTapGestureRecognizer:");
        self.view.addGestureRecognizer(gesture);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        var views:[UIView] = findViews(view, tag: 100);
        var result:Bool = true;
        for subview in views {
            if (subview is UITextField) {
                var textView:UITextField = subview as! UITextField;
                if (count(textView.text) == 0) {
                    textView.text = "0";
                }
                var textInt:Int? = textView.text.toInt();
                if (textInt == nil || textInt >= 10) {
                    textView.backgroundColor = UIColor.redColor();
                    result = false;
                } else {
                    textView.backgroundColor = UIColor.whiteColor();
                }
            }
        }
        
        return result;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var views:[UIView] = findViews(self.view, tag: 100);
        var nums:[Int] = [Int]();
        for view in views {
            if (view is UITextField) {
                var textView:UITextField = view as! UITextField;
                var textInt:Int? = textView.text.toInt();
                if (textInt != nil) {
                    nums.append(textInt!);
                }
            }
        }
        var controller:ResultViewController = segue.destinationViewController as! ResultViewController;
        controller.inputNumbers = nums;
    }

    @IBAction func onClickButton(sender: AnyObject) {
        var views:[UIView] = findViews(self.view, tag: 100);
        for view in views {
            if (view is UITextField) {
                var textField = view as! UITextField;
                var n = arc4random() % 10;
                textField.text = String(n);
            }
        }
    }
    
    func onTapGestureRecognizer(recognizer: UIGestureRecognizer) {
        var views:[UIView] = findViews(self.view, tag: 100);
        for view in views {
            if (view is UITextField) {
                if (view.isFirstResponder()) {
                    view.resignFirstResponder();
                }
            }
        }
    }
    
    // MARK: タグからUIView配列を探す
    func findViews(findView:UIView, tag:Int) -> [UIView] {
        var result:[UIView] = [UIView]();
        for (var i:Int = 0; i < findView.subviews.count; i++) {
            if (findView.subviews[i] is UIView) {
                var subView:UIView = findView.subviews[i] as! UIView;
                if (subView.tag == tag) {
                    result.append(subView);
                }
                result += findViews(subView, tag:tag);
            }
        }
        return result;
    }

}

