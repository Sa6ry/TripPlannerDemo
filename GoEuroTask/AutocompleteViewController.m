//
//  AutocompleteViewController.m
//  GoEuroTask
//
//  Created by Ahmed Sabry on 6/9/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import "AutocompleteViewController.h"
#import "AutocompleteAnimator.h"

@interface AutocompleteViewController()

@property (nonatomic,strong) UIDynamicAnimator* tableAnimator;
@property (nonatomic,weak) NSLayoutConstraint *tableTopConstrant;
@property (nonatomic,weak) NSLayoutConstraint *tableBottomConstrant;

@end

@implementation AutocompleteViewController
@synthesize sourceView = _sourceView;

#pragma mark - Keyboard Observers
-(void) addKeyboardObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

-(void) removeKeyboardObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void) keyboardWillShow:(NSNotification*) notification {
    
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    CGFloat height = keyboardFrame.size.height;
    
    self.tableBottomConstrant.constant = -height;
    
    [UIView animateWithDuration:animationDuration animations:^{
        
        [self.view setNeedsLayout];
    }];
}

-(void) keyboardWillHide:(NSNotification*) notification {
    
    if(self.searchTextField.userInteractionEnabled) {
        NSDictionary *info = [notification userInfo];
        NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        self.tableBottomConstrant.constant = 0;
        
        [UIView animateWithDuration:animationDuration animations:^{
            
            [self.view setNeedsLayout];
        }];
    }
}

#pragma mark - Transition delegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    return [[AutocompleteAnimator alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[AutocompleteAnimator alloc] init];
}

#pragma mark - Life Cycle

-(instancetype) initWithSourceTextField:( UITextField* _Nonnull ) sourceView
{
    self = [super init];
    if(self)
    {
        _sourceView = sourceView;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
    }
    return self;
}

-(void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    [self.searchTextField becomeFirstResponder];
}

-(void) loadView
{
    [super loadView];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor clearColor];
    
    [self addKeyboardObservers];
    [self setupViews];
    [self setupConstraints];
}

-(void) dealloc
{
    [self removeKeyboardObservers];
}

-(void) dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(autocompleteViewControlerWillDismiss:)]) {
        [self.delegate autocompleteViewControlerWillDismiss:self];
    }
    [super dismissViewControllerAnimated:flag completion:completion];
}


-(void) onCancel:(UIButton*) sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Setup

-(void) setupViews
{
    //////////////////////////////
    // The serach text field view
    //////////////////////////////
    self.searchTextField = [[UITextField alloc] init];
    self.searchTextField.translatesAutoresizingMaskIntoConstraints = NO;
    self.searchTextField.layer.cornerRadius = 5.0f;
    self.searchTextField.backgroundColor = [UIColor whiteColor];
    self.searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    self.searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchTextField.spellCheckingType = UITextSpellCheckingTypeNo;
    self.searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTextField.font = self.sourceView.font;
    self.searchTextField.backgroundColor = self.sourceView.backgroundColor;
    self.searchTextField.tintColor = self.sourceView.tintColor;
    self.searchTextField.textColor = self.sourceView.textColor;
    self.searchTextField.delegate = self;
    
    /////////////////////
    // The cancel button
    /////////////////////
    self.cancelButton = [[UIButton alloc] init];
    self.cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.cancelButton.titleLabel.font = self.sourceView.font;
    
    [self.cancelButton setTitle:NSLocalizedString(@"Cancel", @"Cancel") forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    //////////////////
    // The table view
    //////////////////
    self.tableView = [[UITableView alloc] init];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableView.rowHeight = 46;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor cyanColor];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    //////////////////////////
    // Adding visual effects
    /////////////////////////
    self.tableView.backgroundColor = [UIColor whiteColor];
}


-(void) setupConstraints
{
    ////////////////////////////////////
    // search & cancel button contianer
    ////////////////////////////////////
    UIStackView* searchCancelContainer = [[UIStackView alloc] initWithArrangedSubviews:@[self.searchTextField,self.cancelButton]];
    searchCancelContainer.axis = UILayoutConstraintAxisHorizontal;
    searchCancelContainer.translatesAutoresizingMaskIntoConstraints = NO;
    searchCancelContainer.layoutMargins = self.view.layoutMargins;
    searchCancelContainer.layoutMarginsRelativeArrangement = YES;
    searchCancelContainer.spacing = 10;
    
    ////////////////////////////////////
    // table and search contianer
    ////////////////////////////////////
    UIView* tableContainer = [[UIView alloc] init];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [tableContainer addSubview:self.tableView];
    tableContainer.clipsToBounds = YES;
    
    UIStackView* tableSearchContainer = [[UIStackView alloc] initWithArrangedSubviews:@[searchCancelContainer,tableContainer]];
    tableSearchContainer.axis = UILayoutConstraintAxisVertical;
    tableSearchContainer.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:tableSearchContainer];
    [tableSearchContainer.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [tableSearchContainer.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    
    self.tableTopConstrant = [tableSearchContainer.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor];
    self.tableTopConstrant.active = YES;
    
    self.tableBottomConstrant = [tableSearchContainer.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor];
    self.tableBottomConstrant.active = YES;
}

#pragma mark - Text Field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(self.delegate && [self.delegate respondsToSelector:@selector(autocompleteViewControler:newText:oldText:)]) {
        [self.delegate autocompleteViewControler:self newText:newString oldText:textField.text];
    }
    return true;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(autocompleteViewControler:newText:oldText:)]) {
        [self.delegate autocompleteViewControler:self newText:@"" oldText:self.searchTextField.text];
    }
    return true;
}

#pragma mark TableView delegates

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(autocompleteViewControler:didSelectItemAtIndex:)])
    {
        [self.delegate autocompleteViewControler:self didSelectItemAtIndex:indexPath.row];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.delegate autocompleteViewControlerNoOfItems:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"Cell";
    UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = [self.searchTextField.tintColor colorWithAlphaComponent:0.5f];
    }
    cell.textLabel.text = [self.delegate autocompleteViewControler:self titleAtIndex:indexPath.row];
    if(self.delegate && [self.delegate respondsToSelector:@selector(autocompleteViewControler:subTitleAtIndex:)]) {
        cell.detailTextLabel.text = [self.delegate autocompleteViewControler:self subTitleAtIndex:indexPath.row];
    }
    return cell;
}

-(void) reloadData
{
    if([NSThread isMainThread] == false)
    {
        return [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:YES];
    }
    else
    {
        [self.tableView reloadData];
    }
}

@end
