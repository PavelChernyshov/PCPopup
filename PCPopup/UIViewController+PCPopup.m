//
//  UIViewController+PCPopup.m
//  PCPopup
//
//  Created by Pavel Chernyshov on 03.03.13.
//  Copyright (c) 2013 Pavel Chernyshov. All rights reserved.
//

#import "UIViewController+PCPopup.h"
#import "PCPopupContainerViewController.h"
#import <objc/runtime.h>

@implementation UIViewController (PCPopup)

static void * const presentingKeyPath = (void*)&presentingKeyPath;
static void * const presentedKeyPath = (void*)&presentedKeyPath;

-(UIViewController *)pcPresentedPopupViewController
{
    return [(PCPopupContainerViewController *)[self pcPresentedPopupViewControllerInt_] popupViewController];
}

-(UIViewController *)pcPresentedPopupViewControllerInt_
{
    return objc_getAssociatedObject(self, presentedKeyPath);
}

-(void)setPcPresentedPopupViewController:(UIViewController *)pcPresentedPopupViewController
{
    NSParameterAssert(pcPresentedPopupViewController);
    objc_setAssociatedObject(self, presentedKeyPath, pcPresentedPopupViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIViewController *)pcPresentingPopupViewController
{
    return objc_getAssociatedObject(self, presentingKeyPath);
}

-(void)setPcPresentingPopupViewController:(UIViewController *)pcPresentingPopupViewController
{
    NSParameterAssert(pcPresentingPopupViewController);
    objc_setAssociatedObject(self, presentingKeyPath, pcPresentingPopupViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)presentPopupViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completions
{
    viewControllerToPresent.pcPresentingPopupViewController = self;
    
    PCPopupContainerViewController *popoverController = [[PCPopupContainerViewController alloc] init];
    popoverController.popupViewController = viewControllerToPresent;
    self.pcPresentedPopupViewController = popoverController;
    
    [popoverController presentPopupAnimated:YES completion:completions];
}

-(void)dismissPopupViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
    if (!self.pcPresentedPopupViewController) {
        [self.pcPresentingPopupViewController dismissViewControllerAnimated:flag completion:completion];
    }
    else
    {
        [[self pcPresentedPopupViewControllerInt_] dismissViewControllerAnimated:flag completion:completion];
        self.pcPresentedPopupViewController = nil;
    }
}

@end
