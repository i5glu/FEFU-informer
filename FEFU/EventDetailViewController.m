//
//  EventDetailViewController.m
//  FEFU
//
//  Created by Илья on 12.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import "EventDetailViewController.h"

@implementation EventDetailViewController


@synthesize image;
@synthesize text;

@synthesize textValue;
@synthesize imageValue;

- (void) viewDidLoad{
    [super viewDidLoad];
    text.text = textValue;
    image.image = imageValue;
    text.editable = NO;
}

@end
