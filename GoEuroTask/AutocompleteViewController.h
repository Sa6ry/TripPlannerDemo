//
//  AutocompleteViewController.h
//  GoEuroTask
//
//  Created by Ahmed Sabry on 6/9/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AutocompleteViewController;

@protocol AutocompleteViewControllerDelegate <NSObject>

-(NSString* _Nullable) autocompleteViewControler:(AutocompleteViewController* _Nonnull)autoCompleteViewController titleAtIndex:(NSInteger)itemIndex;
-(NSUInteger) autocompleteViewControlerNoOfItems:(AutocompleteViewController* _Nonnull)autoCompleteViewController;

@optional
-(void) autocompleteViewControler:(AutocompleteViewController* _Nonnull)autoCompleteViewController newText:(NSString* _Nullable)newText oldText:(NSString* _Nullable)oldText;
-(NSString* _Nullable) autocompleteViewControler:(AutocompleteViewController* _Nonnull)autoCompleteViewController subTitleAtIndex:(NSInteger)itemIndex;
-(void) autocompleteViewControlerWillDismiss:(AutocompleteViewController* _Nonnull) autoCompleteViewController;
-(void) autocompleteViewControler:(AutocompleteViewController* _Nonnull)autoCompleteViewController didSelectItemAtIndex:(NSUInteger)itemIndex;
@end

@interface AutocompleteViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIViewControllerTransitioningDelegate>

@property (nonnull, nonatomic,readonly) UITextField* sourceView;
@property (nonnull,nonatomic,strong) UITableView* tableView;
@property (nonnull,nonatomic,strong) UITextField* searchTextField;
@property (nonnull,nonatomic,strong) UIButton*  cancelButton;

@property (nonatomic,weak) id<AutocompleteViewControllerDelegate> _Nullable delegate;

- (instancetype _Nullable) init __attribute__((unavailable("Must use initWithSourceTextField: instead.")));

-( instancetype _Nullable) initWithSourceTextField:( UITextField* _Nonnull ) sourceView;

-(void) reloadData;

@end
