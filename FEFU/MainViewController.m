//
//  mainViewController.m
//  FEFU
//
//  Created by Илья on 10.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController()
@end

@implementation MainViewController

- (IBAction)showNews:(id)sender{
    [self performSegueWithIdentifier: @"showNews" sender: sender];
}

@end
