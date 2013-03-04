//
//  PCPopup.h
//  PCPopup
//
//  Created by Pavel Chernyshov on 04.03.13.
//  Copyright (c) 2013 Pavel Chernyshov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@protocol PCPopupDelegate <NSObject>

@optional
-(CAAnimation *)popupAppearanceAnimation;
-(CAAnimation *)popupDismissAnimation;
-(CAAnimation *)backgroundAppearanceAnimation;
-(CAAnimation *)backgroundDismissAnimationn;

-(BOOL)pcPopupDismissesOnOutsideClick;

@end