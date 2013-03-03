//
//  TestPopupController.m
//  PCPopupTests
//
//  Created by Pavel Chernyshov on 03.03.13.
//  Copyright (c) 2013 Pavel Chernyshov. All rights reserved.
//

#import "TestPopupController.h"

@interface TestPopupController ()

@end

@implementation TestPopupController
- (void)viewDidLoad
{
    NSLog(@"View did load");
}

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"View will appear %@", animated ? @"animated" : @"not animated");
}

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"View did appear %@", animated ? @"animated" : @"not animated");
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"View will disappear %@", animated ? @"animated" : @"not animated");
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"View did disappear %@", animated ? @"animated" : @"not animated");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
