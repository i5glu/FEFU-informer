//
//  RegistrationViewController.h
//  FEFU
//
//  Created by Илья on 19.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
}

@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;

@end
