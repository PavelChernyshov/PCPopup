//
//  PCPopupContainerViewController.h
//  PCPopup
//
//  Created by Pavel Chernyshov on 03.03.13.
//  Copyright (c) 2013 Pavel Chernyshov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface PCPopupContainerViewController : UIViewController
{
    UIView *_popoverView;
}

@property (nonatomic, readwrite, strong) UIView *backgroundView;
@property (nonatomic, readwrite, strong) UIViewController *popupViewController;

-(void)presentPopupAnimated:(BOOL)flag completion:(void (^)(void))completions;
-(void)dismissPopupAnimated:(BOOL)flag completion:(void (^)(void))completion;

@end
