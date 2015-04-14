//
//  ViewController.swift
//  MathematicalFormulaGenerator
//
//  Created by Kubota Daisuke on 2015/04/14.
//  Copyright (c) 2015年 Kubota Daisuke. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func onClickButton(sender: AnyObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)) {
            var result:[AnyObject]? = Generator.toReversePorlishNotation([1,2,3,4], operators: [2, 2, 1]);
            if (result != nil) {
                NSLog("%@, str = %@", __FUNCTION__, Generator.toString(result!));
            }
            result = Generator.toReversePorlishNotation([5,4,3,2,6], operators: [0, 2, 0, 3]);
            if (result != nil) {
                NSLog("%@, str = %@", __FUNCTION__, Generator.toString(result!));
            }
            result = Generator.toReversePorlishNotation([1,2,3,4,5], operators: [1, 2, 3, 0]);
            if (result != nil) {
                NSLog("%@, str = %@", __FUNCTION__, Generator.toString(result!));
            }
        };
    }
}

