//
//  DatePickerViewController.h
//  GoEuroTask
//
//  Created by Ahmed Sabry on 6/13/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerViewController : UIViewController <UIPopoverPresentationControllerDelegate>

-(nullable id) initWithSourceView:(UIView* _Nonnull) sourceView;

@property (nonatomic,readonly) UIDatePicker* _Nullable datePicker;

@end
