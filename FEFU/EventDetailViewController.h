//
//  EventDetailViewController.h
//  FEFU
//
//  Created by Илья on 12.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *text;

@property (nonatomic, strong) UIImage *imageValue;
@property (nonatomic, strong) NSString *textValue;

@end
