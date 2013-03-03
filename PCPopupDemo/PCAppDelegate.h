//
//  PCAppDelegate.h
//  PCPopupDemo
//
//  Created by Pavel Chernyshov on 03.03.13.
//  Copyright (c) 2013 Pavel Chernyshov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCViewController;

@interface PCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) PCViewController *viewController;

@end
