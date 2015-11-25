//
//  AvatarViewController.m
//  FEFU
//
//  Created by Илья on 19.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import "AvatarViewController.h"

@implementation AvatarViewController

@synthesize picture;
@synthesize pictureValue;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.tabBarController.tabBar setHidden:YES];
    picture.image = pictureValue;
}



@end
