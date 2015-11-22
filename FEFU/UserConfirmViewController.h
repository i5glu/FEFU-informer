//
//  UserConfirmViewController.h
//  FEFU
//
//  Created by Илья on 19.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserConfirmViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *confirmCode;
@property (strong,nonatomic) NSString *phoneNumber;


@end
