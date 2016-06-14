//
//  ViewController.m
//  GoEuroTask
//
//  Created by Ahmed Sabry on 6/7/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import "MainViewController.h"
#import "AutocompleteViewController.h"
#import "WebGetSuggestionAPI.h"
#import "Place.h"
#import "DatePickerViewController.h"
#import "GoEuroTask-Swift.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UITextField *inputFrom;
@property (weak, nonatomic) IBOutlet UITextField *inputTo;
@property (weak, nonatomic) IBOutlet UITextField *inputDate;

// Play with those constriant to add the startup animation
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoNormalHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *logoFullHeightConstraint;

@property (nonatomic,retain) CAGradientLayer* gradientBackground;

// the suggested place array
@property (nonatomic,strong) NSArray<Place*> * suggestions;
@property (nonatomic,strong) AutocompleteViewController* autocompleteViewController;

// the user geo location
@property (nonatomic,strong) CLLocation* currentLocation;
@end

@implementation MainViewController


-(void) viewDidLayoutSubviews {
    self.gradientBackground.frame = self.view.bounds;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self animateLogo];
}

-(void) animateLogo {
    self.logoNormalHeightConstraint.active = NO;
    self.logoFullHeightConstraint.active = YES;
    [self.view layoutIfNeeded];
    
    self.logoFullHeightConstraint.active = NO;
    self.logoNormalHeightConstraint.active = YES;
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionLayoutSubviews animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setNeedsStatusBarAppearanceUpdate];
    
    ///////////////////////////
    // Add Gradiant background
    ///////////////////////////
    UIColor* topColor = [UIColor colorWithRed:20.0/255.0 green:88.0/255.0 blue:153.0/255.0 alpha:1.0];
    UIColor* bottomColor = [UIColor colorWithRed:43.0/255.0 green:54.0/255.0 blue:70.0/255.0 alpha:1.0];
    self.view.backgroundColor = bottomColor;
    self.gradientBackground = [CAGradientLayer layer];
    self.gradientBackground.frame = self.view.bounds;
    self.gradientBackground.colors = [NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil];
    [self.view.layer insertSublayer:self.gradientBackground atIndex:0];
    
    ////////////////////////////////////////////////
    // Set the textfield place holder and left view
    ////////////////////////////////////////////////
    [@[self.inputFrom,self.inputTo,self.inputDate] enumerateObjectsUsingBlock:^(UITextField*  _Nonnull textField, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UITextField* leftTitle = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        leftTitle.userInteractionEnabled = NO;
        leftTitle.text = textField.placeholder;
        leftTitle.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        leftTitle.font = [textField.font fontWithSize:self.inputFrom.font.pointSize-4];
        leftTitle.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 16, 20)];
        leftTitle.leftViewMode = UITextFieldViewModeAlways;
        textField.leftView = leftTitle;
        textField.leftViewMode = UITextFieldViewModeAlways;
        textField.placeholder = nil;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onSearch:(id)sender {
    
    NSString* message = self.inputTo.text.length == 0 || self.inputFrom.text.length == 0 || self.inputDate.text.length == 0 ? NSLocalizedString(@"Please select your From, To & Date first!",nil) : NSLocalizedString(@"Search is not yet implemented!",nil);
    
    // We have to present the autocomplte
    UIAlertController * alert =   [UIAlertController
                                  alertControllerWithTitle:@"GoEuro"
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:NSLocalizedString(@"OK",nil)
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:ok];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if([textField isEqual:self.inputTo] || [textField isEqual:self.inputFrom]) {
        self.autocompleteViewController = [[AutocompleteViewController alloc] initWithSourceTextField:textField];
        self.autocompleteViewController.delegate = self;
        
        [self presentViewController:self.autocompleteViewController animated:YES completion:^{
            [self updateCurrentLocation];
        }];
    }else if([textField isEqual:self.inputDate]) {
        
        //build our custom popover view
        DatePickerPopoverViewController* datePickerVC = [[DatePickerPopoverViewController alloc] initWithSourceView:textField];
        
        [self presentViewController:datePickerVC animated:YES completion:^{
            [datePickerVC.datePicker addTarget:self action:@selector(onDateChange:) forControlEvents:UIControlEventValueChanged];
            if(self.inputDate.text == nil || self.inputDate.text.length == 0) {
                [self onDateChange:datePickerVC.datePicker];
            }
        }];
        
    }
    return false;
}

-(void) onDateChange:(UIDatePicker*) sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"cccc, MMM d, YYYY"];
    self.inputDate.text = [dateFormat stringFromDate:sender.date];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

-(UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Getting the current location
-(CLLocationCoordinate2D) updateCurrentLocation
{
    static dispatch_once_t onceToken;
    static CLLocationManager* locationManager = nil;
    dispatch_once (&onceToken, ^{
        // Do some work that happens once
        locationManager = [[CLLocationManager alloc] init];
    });
    
    [locationManager requestWhenInUseAuthorization];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    return coordinate;
}

#pragma mark CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation = [locations objectAtIndex:0];
    [manager stopUpdatingLocation];
}

#pragma mark - Suggestion table delegates

-(void) autocompleteViewControlerWillDismiss:(AutocompleteViewController *)autoCompleteViewController
{
    self.autocompleteViewController = nil;
    self.suggestions = nil;
}

-(void) autocompleteViewControler:(AutocompleteViewController *)autoCompleteViewController didSelectItemAtIndex:(NSUInteger)itemIndex
{
    if(autoCompleteViewController.sourceView == self.inputTo)
    {
        self.inputTo.text = self.suggestions[itemIndex].fullNameFirstPart;
    }else {
        self.inputFrom.text = self.suggestions[itemIndex].fullNameFirstPart;
    }
    [autoCompleteViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void) autocompleteViewControler:(AutocompleteViewController *)autoCompleteViewController newText:(NSString *)newText oldText:(NSString *)oldText
{
    // We are on the main Queue here
    
    // We safe the latestAPI and check the result agianst it
    // not to update the table to frequenlty while the user is typing!
    static WebGetSuggestionAPI* latestAPI = nil;
    WebGetSuggestionAPI* api = [[WebGetSuggestionAPI alloc] initWithText:newText location:self.currentLocation];
    latestAPI = api;
    AutocompleteViewController* currentViewController = autoCompleteViewController;
    
    [api runWithCompletion:^(WebGetSuggestionAPI * _Nullable getRequest) {
        if(getRequest) {
            
            // We only make our changes on the main queue
            // not to have our data corrupted!
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // make sure we are on the same viewController and we are the latestAPI
                if(currentViewController == self.autocompleteViewController && latestAPI == api) {
                    self.suggestions = getRequest.suggestions;
                    [self.autocompleteViewController reloadData];
                }
            }];
        }
    }];
}

-(NSString* _Nullable) autocompleteViewControler:(AutocompleteViewController* _Nonnull)autoCompleteViewController titleAtIndex:(NSInteger)itemIndex
{
    return self.suggestions[itemIndex].fullNameFirstPart;
}

-(NSString* _Nullable) autocompleteViewControler:(AutocompleteViewController* _Nonnull)autoCompleteViewController subTitleAtIndex:(NSInteger)itemIndex
{
    return self.suggestions[itemIndex].fullNameLastPart;
}

-(NSUInteger) autocompleteViewControlerNoOfItems:(AutocompleteViewController* _Nonnull)autoCompleteViewController
{
    return self.suggestions.count;
}

@end
