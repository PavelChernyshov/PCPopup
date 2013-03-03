//
//  PCPopupContainerViewController.m
//  PCPopup
//
//  Created by Pavel Chernyshov on 03.03.13.
//  Copyright (c) 2013 Pavel Chernyshov. All rights reserved.
//

#import "PCPopupContainerViewController.h"

@interface PCPopupContainerViewController ()
{
    CGSize _spaceAvailable;
}

-(UIViewController *)windowRootVC;

@end

@implementation PCPopupContainerViewController

-(void)loadView
{
    CGRect viewBounds = [self windowRootVC].view.bounds;
    _spaceAvailable = viewBounds.size;
    
    UIView *view = [[UIView alloc] initWithFrame:viewBounds];
    
    UIView *background = [[UIView alloc] initWithFrame:viewBounds];
    background.backgroundColor = [UIColor blackColor];
    background.alpha = 0.5f;
    _backgroundView = background;
    [view addSubview:_backgroundView];
    
    self.view = view;
}

#pragma mark - Accessors
-(void)setBackgroundView:(UIView *)backgroundView
{
    if (_backgroundView != backgroundView)
    {
        _backgroundView = backgroundView;
        [self.view insertSubview:_backgroundView atIndex:0];
    }
}

-(void)setPopupViewController:(UIViewController *)popupViewController
{
    if (_popupViewController != popupViewController)
    {
        _popupViewController = popupViewController;
    }
}

#pragma mark - presentation mgmnt
-(void)presentPopupAnimated:(BOOL)flag completion:(void (^)(void))completions
{
    //Presentation prior checks
    if (!_popupViewController) return;
    [self registerForKeyboardEvents];
    
    [_popupViewController viewWillAppear:flag];
    
    //Setup Animations
    //Show view
    
    [_popupViewController viewDidAppear:flag];
    if (completions != NULL) completions();

}

-(void)dismissPopupAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    //Dismission prior checks
    [self unregisterForKeyboardEvents];
    
    [_popupViewController viewWillDisappear:flag];
    
    //SetupAnimations
    //RemoveView
    
    [_popupViewController viewDidDisappear:flag];
    if (completion != NULL) completion();
}

#pragma mark - Popup positioning
-(void)positonPopup
{
    
}

-(CGRect)centerFrame:(CGRect)frame inFrame:(CGRect)inFrame
{
    return CGRectMake(ceilf((inFrame.size.width - frame.size.width) / 2.0f), ceilf((inFrame.size.height - frame.size.height) / 2.0f), frame.size.width, frame.size.height);
}


#pragma mark - Handling keyboard events
-(void)registerForKeyboardEvents
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification object:nil];
}

-(void)unregisterForKeyboardEvents
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat kbHeight = MIN(kbSize.width, kbSize.height);
//    _availableSpace = CGSizeMake(_availableSpace.width, _availableSpace.height - kbHeight);
//    [self centerPopoverInAvailableSpaceAnimated:YES];
}

-(void)keyboardDidShow:(NSNotification *)notification
{
    
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat kbHeight = MIN(kbSize.width, kbSize.height);
//    _availableSpace = CGSizeMake(_availableSpace.width, _availableSpace.height + kbHeight);
//    [self centerPopoverInAvailableSpaceAnimated:YES];
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    
}

#pragma mark - Helpers 
-(UIViewController *)windowRootVC
{
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    
    if (!currentWindow) {
        currentWindow = [UIApplication sharedApplication].windows[0];
    }
    return currentWindow.rootViewController;
}

@end
