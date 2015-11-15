//
//  DetailsViewController.m
//  FEFU
//
//  Created by Илья on 15.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import "DetailsViewController.h"

@implementation DetailsViewController

@synthesize picture;
@synthesize pictureValue;

@synthesize content;
@synthesize contentValue;

- (void) viewDidLoad{
    [super viewDidLoad];
    content.editable = NO;
    content.text = contentValue;
    picture.image = pictureValue;
}

@end
