//
//  DatePickerViewController.m
//  GoEuroTask
//
//  Created by Ahmed Sabry on 6/13/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void) loadView {
    [super loadView];
    _datePicker = [[UIDatePicker alloc] initWithFrame:self.view.bounds];
    self.datePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    self.datePicker.minimumDate = [NSDate date];
    [self.view addSubview:self.datePicker];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIModalPresentationStyle) adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}

-(void) viewDidLayoutSubviews
{
    // update the source rectangle so that the arrow is always in the center after the rotation
    self.popoverPresentationController.sourceRect = CGRectMake(0, 0, self.popoverPresentationController.sourceView.bounds.size.width, self.popoverPresentationController.sourceView.bounds.size.height);
}

-(id) initWithSourceView:(UIView*) sourceView
{
    self = [super init];
    if(self)
    {
        self.modalPresentationStyle = UIModalPresentationPopover;
        self.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown;
        self.popoverPresentationController.delegate = self;
        self.popoverPresentationController.sourceView = sourceView;
        self.popoverPresentationController.sourceRect = CGRectMake(0, 0, sourceView.bounds.size.width, sourceView.bounds.size.height);
        self.popoverPresentationController.canOverlapSourceViewRect = NO;
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        
    }
    return self;
}

@end
