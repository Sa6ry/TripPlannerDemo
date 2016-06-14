//
//  DatePickerPopoverViewController.swift
//  GoEuroTask
//
//  Created by Ahmed Sabry on 6/14/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

import UIKit

@objc class DatePickerPopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    var datePicker = UIDatePicker()
    
    
    // MARK: - Life Cycle
    init(sourceView aSourceView: UIView?) {
        
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .Popover
        self.popoverPresentationController?.permittedArrowDirections = [.Up,.Down]
        self.popoverPresentationController?.delegate = self
        self.popoverPresentationController?.sourceView = aSourceView
        self.popoverPresentationController?.sourceRect = CGRect(origin: CGPointZero, size: (self.popoverPresentationController?.sourceView!.bounds.size)!)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        super.loadView()
        
        // Add the date picker view
        self.datePicker.frame = self.view.bounds
        self.datePicker.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        self.datePicker.datePickerMode = UIDatePickerMode.Date;
        self.datePicker.minimumDate = NSDate()
        self.view.addSubview(self.datePicker)

    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        // update the source rectangle so that the arrow is always in the center after the rotation
        self.popoverPresentationController?.sourceRect = CGRect(origin: CGPointZero, size: (self.popoverPresentationController?.sourceView!.bounds.size)!)
    }
    
    // MARK: - Presentaton Delegates
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}
