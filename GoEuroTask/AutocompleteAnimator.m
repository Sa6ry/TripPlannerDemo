//
//  AutocompletePresentAnimator.m
//  GoEuroTask
//
//  Created by Ahmed Sabry on 6/7/16.
//  Copyright © 2016 Sa6ry. All rights reserved.
//

#import "AutocompleteAnimator.h"
#import "AutocompleteViewController.h"

@implementation AutocompleteAnimator

-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
                                   view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
                                   view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    [view setTranslatesAutoresizingMaskIntoConstraints:YES];
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView* containerView = [transitionContext containerView];
    
    if ([toViewController isKindOfClass:[AutocompleteViewController class]]) { // we are presenting
        
        ////////////////////////////////////////////////////
        // add the new view controller
        ////////////////////////////////////////////////////
        [containerView addSubview:toViewController.view];
        
        AutocompleteViewController* autoCompleteViewController = (AutocompleteViewController*)toViewController;
        
        autoCompleteViewController.cancelButton.hidden = YES;
        
        // Force the constriant to be updated
        [containerView layoutIfNeeded];
        
        ////////////////////////////////////////////////////
        // Update the anchro point around the search field
        ////////////////////////////////////////////////////
        CGPoint newAnchorPoint = [autoCompleteViewController.searchTextField convertPoint:CGPointZero toView:autoCompleteViewController.view] ;
        newAnchorPoint.x /= autoCompleteViewController.view.frame.size.width;
        newAnchorPoint.y /= autoCompleteViewController.view.frame.size.height;
        [self setAnchorPoint:newAnchorPoint forView:autoCompleteViewController.view];
        
        ////////////////////////////////////////////
        // Calculate the transalation and the Scale
        ////////////////////////////////////////////
        CGPoint move = [autoCompleteViewController.sourceView convertPoint:CGPointZero toView:autoCompleteViewController.searchTextField];
        CGPoint scale = CGPointMake(autoCompleteViewController.sourceView.frame.size.width/autoCompleteViewController.searchTextField.frame.size.width,
                                    autoCompleteViewController.sourceView.frame.size.height/autoCompleteViewController.searchTextField.frame.size.height);
        
        ////////////////////////////////////////////
        // update the translation and the scale
        ////////////////////////////////////////////
        autoCompleteViewController.view.transform = CGAffineTransformScale(CGAffineTransformMakeTranslation(move.x, move.y), scale.x, scale.y);
        
        ////////////////////////////////////////////////////////////////
        // Copy the source view controller to fake a smoth transition
        ////////////////////////////////////////////////////////////////
        UIView* sourceViewImage = [autoCompleteViewController.sourceView snapshotViewAfterScreenUpdates:NO];
        sourceViewImage.frame = [autoCompleteViewController.sourceView convertRect:autoCompleteViewController.sourceView.bounds toView:containerView];
        [containerView addSubview:sourceViewImage];
        
        
        //////////////////////////////////////////////////////////////////
        // Hide the source text field to give the impression it's moving
        //////////////////////////////////////////////////////////////////
        autoCompleteViewController.sourceView.alpha = 0.0;
        autoCompleteViewController.tableView.alpha = 0.0f;
        
        [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        //[UIView animateWithDuration:0.4f animations:^{
            
            autoCompleteViewController.view.transform = CGAffineTransformIdentity;
            
            sourceViewImage.frame = [autoCompleteViewController.searchTextField convertRect:autoCompleteViewController.searchTextField.bounds toView:containerView];

            sourceViewImage.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            
            [sourceViewImage removeFromSuperview];
        }];
        
        autoCompleteViewController.tableView.transform = CGAffineTransformMakeTranslation(0, -autoCompleteViewController.tableView.bounds.size.height);
        
        autoCompleteViewController.tableView.alpha = 1.0f;
        
        [UIView animateWithDuration:0.7 delay:0.25f usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            autoCompleteViewController.tableView.transform = CGAffineTransformIdentity;
            autoCompleteViewController.cancelButton.hidden = NO;
            
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
            
        }];

    }
    else {
        //////////////////////
        // we are dismissing
        //////////////////////
        AutocompleteViewController* autoCompleteViewController = (AutocompleteViewController*)fromViewController;
        
        
        // Force the constriant to be updated
        [containerView layoutIfNeeded];
        
        
        ////////////////////////////////////////////////////////////////////
        // Create a copy of the destination source to fake smooth transition
        ////////////////////////////////////////////////////////////////////
        autoCompleteViewController.sourceView.alpha = 1.0;
        UIView* sourceTextFieldImage = [autoCompleteViewController.sourceView snapshotViewAfterScreenUpdates:YES];
        autoCompleteViewController.sourceView.alpha = 0.0;
        
        autoCompleteViewController.cancelButton.hidden = YES;
        sourceTextFieldImage.frame = [autoCompleteViewController.searchTextField convertRect:autoCompleteViewController.searchTextField.bounds toView:containerView];
        autoCompleteViewController.cancelButton.hidden = NO;
        sourceTextFieldImage.alpha = 0.0f;
        [containerView addSubview:sourceTextFieldImage];
        
        
        // Force hiding the keyboard
        autoCompleteViewController.searchTextField.userInteractionEnabled  = NO;
        
        [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            autoCompleteViewController.tableView.transform = CGAffineTransformMakeTranslation(0, -autoCompleteViewController.tableView.bounds.size.height);
            autoCompleteViewController.cancelButton.hidden = YES;
            
        }completion:^(BOOL finished) {
        
            ////////////////////////////////////////////
            // Calculate the transalation and the Scale
            ////////////////////////////////////////////
            CGPoint move = [autoCompleteViewController.sourceView convertPoint:CGPointZero toView:autoCompleteViewController.searchTextField];
            CGPoint scale = CGPointMake(autoCompleteViewController.sourceView.frame.size.width/autoCompleteViewController.searchTextField.frame.size.width,
                                        autoCompleteViewController.sourceView.frame.size.height/autoCompleteViewController.searchTextField.frame.size.height);
            
            ////////////////////////////////////////////
            // update the translation and the scale
            ////////////////////////////////////////////
            CGAffineTransform finalTranform = CGAffineTransformScale(CGAffineTransformMakeTranslation(move.x, move.y), scale.x, scale.y);
            
            [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.75 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            //[UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                autoCompleteViewController.tableView.transform  = CGAffineTransformMakeTranslation(0, -autoCompleteViewController.tableView.bounds.size.height);
                
                autoCompleteViewController.view.transform  = finalTranform;
                
                sourceTextFieldImage.frame = [autoCompleteViewController.sourceView convertRect:autoCompleteViewController.sourceView.bounds toView:containerView];
                sourceTextFieldImage.alpha = 1.0f;
                
                
            }completion:^(BOOL finished) {
                
                [sourceTextFieldImage removeFromSuperview];
                autoCompleteViewController.sourceView.alpha = 1.0f;
                [transitionContext completeTransition:YES];
                
            }];
        }];
        
        
    }
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 1.25f;
}


@end
