//
//  UserConfirmViewController.m
//  FEFU
//
//  Created by Илья on 19.11.15.
//  Copyright © 2015 FARPOST. All rights reserved.
//

#import "UserConfirmViewController.h"
#import "AFNetworking.h"

@implementation UserConfirmViewController

- (IBAction)sendVerificationCode:(id)sender {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{
                                 @"phoneNumber": _phoneNumber,
                                 @"phoneCode"  : _confirmCode.text
                                 };
    [manager POST:@"http://31.131.24.188:8080/validationUsers" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Успех!" message:@"Поздравляем, теперь вы один из нас" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ок"
                                                              style: UIAlertActionStyleDefault
                                                            handler: ^(UIAlertAction *action) {
                                                                [[NSUserDefaults standardUserDefaults] setObject:_phoneNumber forKey:@"phoneNumber"];
                                                                [self.navigationController popToRootViewControllerAnimated:YES];
                                                            }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Ошибка" message:@"Что-то пошло не так(( попробуйте пожалуйста позже" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Ок"
                                                              style: UIAlertActionStyleDefault
                                                            handler: ^(UIAlertAction *action) {
                                                                [self.navigationController popToRootViewControllerAnimated:YES];
                                                            }];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:nil];

    }];
}


@end
