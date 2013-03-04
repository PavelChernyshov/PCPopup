//
//  PCPopupContainerViewController.m
//  PCPopup
//
//  Created by Pavel Chernyshov on 03.03.13.
//  Copyright (c) 2013 Pavel Chernyshov. All rights reserved.
//

#import "PCPopupContainerViewController.h"
#import "PCPopupDelegate.h"

#define kDefaultTransitonDuration 0.4f

@interface PCPopupContainerViewController ()
{
    CGSize _spaceAvailable;
    
    CAAnimation *_popupAppearanceAnimation;
    CAAnimation *_backgroundAppearanceAnimation;
    CAAnimation *_popupDismissAnimation;
    CAAnimation *_backgroundDismissAnimation;
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

-(void)viewDidLoad
{
    [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)]];
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
        
        if ([_popupViewController conformsToProtocol:@protocol(PCPopupDelegate) ])
        {
            UIViewController<PCPopupDelegate> *controller = (UIViewController<PCPopupDelegate> *)_popupViewController;
            
//            _popupAppearanceAnimation = [controller popupAppearanceAnimation];
//            _popupDismissAnimation = [controller popupDismissAnimation];
//            _backgroundAppearanceAnimation = [controller backgroundAppearanceAnimation];
//            _backgroundDismissAnimation = [controller backgroundDismissAnimationn];
            
            _popupAppearanceAnimation = [self defaultPopupAnimationReverse:NO];
            _popupDismissAnimation = [self defaultPopupAnimationReverse:YES];
            _backgroundAppearanceAnimation = [self defaultBackgroundAnimationReverse:NO];
            _backgroundDismissAnimation = [self defaultBackgroundAnimationReverse:YES];
            
            BOOL dismissPopup = YES;
            if ([_popupViewController respondsToSelector:@selector(pcPopupDismissesOnOutsideClick)]) {
                dismissPopup = [controller pcPopupDismissesOnOutsideClick];
            }
            if (dismissPopup)
            {
                [_backgroundView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)]];
            }
        }
        else
        {
            _popupAppearanceAnimation = [self defaultPopupAnimationReverse:NO];
            _popupDismissAnimation = [self defaultPopupAnimationReverse:YES];
            _backgroundAppearanceAnimation = [self defaultBackgroundAnimationReverse:NO];
            _backgroundDismissAnimation = [self defaultBackgroundAnimationReverse:YES];
        }
    }
}

#pragma mark - presentation mgmnt
-(void)presentPopupAnimated:(BOOL)flag completion:(void (^)(void))completions
{
    //Presentation prior checks
    if (!_popupViewController) return;
    [self registerForKeyboardEvents];
        
    //Setup Animations
    _popupView = _popupViewController.view;
    _popupView.frame = [self centerFrame:_popupView.frame inFrame:self.view.bounds];
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if (completions != NULL) completions();
    }];
    
    [_popupView.layer addAnimation:_popupAppearanceAnimation forKey:kCATransition];
    [self.view addSubview:_popupView];
    [[self windowRootVC].view addSubview:self.view];
    [_backgroundView.layer addAnimation:_backgroundAppearanceAnimation forKey:@"Appearance"];
    
    [CATransaction commit];
}

-(void)dismissPopupAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    //Dismission prior checks
    [self unregisterForKeyboardEvents];
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:kDefaultTransitonDuration];
    [CATransaction setCompletionBlock:^{
        if (completion != NULL) completion();
        [self.view removeFromSuperview];
    }];
    
    [_popupView.layer addAnimation:_popupDismissAnimation forKey:kCATransition];    
    [_backgroundView.layer addAnimation:_backgroundDismissAnimation forKey:@"Appearance"];
    
    [CATransaction commit];
}

#pragma mark - Popup positioning
-(void)positonPopupAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.2f animations:^{
            _popupView.frame = [self centerFrame:_popupView.frame inFrame:CGRectMake(0.0f, 0.0f, _spaceAvailable.width, _spaceAvailable.height)];
        }];
    }
    else
    {
        _popupView.frame = [self centerFrame:_popupView.frame inFrame:CGRectMake(0.0f, 0.0f, _spaceAvailable.width, _spaceAvailable.height)];
    }
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
    _spaceAvailable = CGSizeMake(_spaceAvailable.width, _spaceAvailable.height - kbHeight);
    [self positonPopupAnimated:YES];
}

-(void)keyboardDidShow:(NSNotification *)notification
{
    
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGFloat kbHeight = MIN(kbSize.width, kbSize.height);
    _spaceAvailable = CGSizeMake(_spaceAvailable.width, _spaceAvailable.height + kbHeight);
    [self positonPopupAnimated:YES];
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

#pragma mark - Background Tap Handle
-(void)tapHandle:(UITapGestureRecognizer *)tapGesture
{
    [self dismissPopupAnimated:YES completion:NULL];
}

#pragma mark - Default Animations
-(CAAnimation *)defaultBackgroundAnimationReverse:(BOOL)reverse
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = kDefaultTransitonDuration;
    if (reverse)
    {
        animation.fromValue = @0.5f;
        animation.toValue = @0.0f;
    }
    else
    {
        animation.fromValue = @0.0f;
        animation.toValue = @0.5f;
    }
    animation.fillMode = kCAFillModeBoth;
    
    return animation;
}

-(CAAnimation *)defaultPopupAnimationReverse:(BOOL)reverse
{
    CATransition *transitionAnimation = [CATransition animation];
    
    transitionAnimation.duration = kDefaultTransitonDuration;
    transitionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    if (reverse)
    {
        transitionAnimation.type = kCATransitionPush;
        transitionAnimation.subtype = kCATransitionFromBottom;
    }
    else
    {
        transitionAnimation.type = kCATransitionMoveIn;
        transitionAnimation.subtype = kCATransitionFromTop;
    }
    
    return transitionAnimation;
}
@end
