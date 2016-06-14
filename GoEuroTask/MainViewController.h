//
//  ViewController.h
//  GoEuroTask
//
//  Created by Ahmed Sabry on 6/7/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutocompleteViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface MainViewController : UIViewController <  UITextFieldDelegate,AutocompleteViewControllerDelegate , CLLocationManagerDelegate>


@end

