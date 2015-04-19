//
//  ResultViewController.swift
//  MathematicalFormulaGenerator
//
//  Created by daisuke.kubota on 2015/04/15.
//  Copyright (c) 2015年 daisuke.kubota. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    var result:[String]?;
    
    var runThread:Bool = false;
    
    var _generator:Generator = Generator();
    
    var _inputNumbers:[Int]?;
    var inputNumbers:[Int]? {
        get {
            return _inputNumbers;
        }
        set(newValue) {
            _inputNumbers = newValue;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        if (_inputNumbers == nil || _inputNumbers!.count == 0) {
            self.navigationController?.popToRootViewControllerAnimated(true);
            return;
        }
        if (!runThread && result == nil && _inputNumbers != nil) {
            self.indicatorView.startAnimating();
            self.runThread = true;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                let start:NSDate = NSDate();
                var result:[String] = self._generator.getMathematicalFormula(self.inputNumbers!, success: 100);
                var end:NSDate = NSDate();
                NSLog("%@, time = %f", __FUNCTION__, (end.timeIntervalSinceNow - start.timeIntervalSinceNow));
                dispatch_async(dispatch_get_main_queue()) {
                    if (self._generator.isCanceled()) {
                        if (self.navigationController?.topViewController == self) {
                            self.navigationController?.popViewControllerAnimated(true);
                        }
                    } else if (result.count == 0) {
                        self.navigationController?.popViewControllerAnimated(true);
                        var alert:UIAlertController = UIAlertController(title: "答えなし", message: "答えが発見できませんでした", preferredStyle: UIAlertControllerStyle.Alert);
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel) { (action) -> Void in
                        }
                        alert.addAction(okAction);
                        self.navigationController?.presentViewController(alert, animated: true, completion: nil);
                        
                    } else {
                        self.indicatorView.stopAnimating();
                        self.result = result;
                        self.tableView.reloadData();
                    }
                    self.runThread = false;
                }
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated);
        _generator.cancel();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (result != nil) {
            return result!.count;
        }
        return 0;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell");
        cell.textLabel?.text = result![indexPath.row];
        return cell;
    }
    
    
    
}
