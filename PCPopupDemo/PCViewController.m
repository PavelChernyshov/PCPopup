//
//  PCViewController.m
//  PCPopupDemo
//
//  Created by Pavel Chernyshov on 03.03.13.
//  Copyright (c) 2013 Pavel Chernyshov. All rights reserved.
//

#import "PCViewController.h"
#import "UIViewController+PCPopup.h"
#import "TestPopupController.h"

@interface PCViewController ()

@end

@implementation PCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showPopup:(id)sender
{
    TestPopupController *p = [[TestPopupController alloc] init];
    
    [self presentPopupViewController:p animated:YES completion:NULL];
}

@end
