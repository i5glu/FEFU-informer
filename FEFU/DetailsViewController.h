//
//  DetailsViewController.h
//  FEFU
//
//  Created by Илья on 15.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UITextView *content;

@property (nonatomic, strong) UIImage *pictureValue;
@property (nonatomic, strong) NSString *contentValue;

@end
