//
//  UIViewController+PCPopup.h
//  PCPopup
//
//  Created by Pavel Chernyshov on 03.03.13.
//  Copyright (c) 2013 Pavel Chernyshov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PCPopup)

@property (nonatomic, readwrite, strong) UIViewController *pcPresentingPopupViewController;
@property (nonatomic, readwrite, strong) UIViewController *pcPresentedPopupViewController;

-(void)presentPopupViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completions;
-(void)dismissPopupViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;

@end
